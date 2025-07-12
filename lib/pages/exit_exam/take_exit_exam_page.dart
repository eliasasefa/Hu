import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TakeExitExamPage extends StatefulWidget {
  final String department;
  final String year;
  final String examType;
  final String? attemptDocId;
  final List<int?>? selectedAnswers;
  const TakeExitExamPage({
    Key? key,
    required this.department,
    required this.year,
    required this.examType,
    this.attemptDocId,
    this.selectedAnswers,
  }) : super(key: key);

  @override
  State<TakeExitExamPage> createState() => _TakeExitExamPageState();
}

class _TakeExitExamPageState extends State<TakeExitExamPage> {
  List<Map<String, dynamic>> _questions = [];
  int _currentIndex = 0;
  List<int?> _selectedAnswers = [];
  bool _isLoading = true;
  bool _submitted = false;
  int _score = 0;
  String? _attemptDocId;
  DateTime? _startedAt;

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
    if (widget.attemptDocId != null) {
      _attemptDocId = widget.attemptDocId;
      _startedAt = null; // Could be restored if needed
    } else {
      _startAttemptTracking();
    }
  }

  Future<void> _fetchQuestions() async {
    setState(() => _isLoading = true);
    try {
      print(
          'Fetching for dept=${widget.department}, year=${widget.year}, type=${widget.examType}');
      final docRef = FirebaseFirestore.instance
          .collection('exit_exam_questions')
          .doc('${widget.department}_${widget.year}_${widget.examType}');
      final snapshot =
          await docRef.collection('questions').orderBy('createdAt').get();
      _questions = snapshot.docs.map((doc) => doc.data()).toList();
      print('Found ${_questions.length} questions');

      // Initialize answers based on priority:
      // 1. Widget selectedAnswers (from exam history resume)
      // 2. Existing answers from in-progress attempt (will be set in _startAttemptTracking)
      // 3. Empty answers
      if (widget.selectedAnswers != null &&
          widget.selectedAnswers!.length == _questions.length) {
        _selectedAnswers = List<int?>.from(widget.selectedAnswers!);
      } else {
        _selectedAnswers = List<int?>.filled(_questions.length, null);
      }

      setState(() => _isLoading = false);
    } catch (e) {
      print('Error fetching questions: $e');
      setState(() {
        _isLoading = false;
        _questions = [];
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading questions: $e')),
        );
      }
    }
  }

  Future<void> _startAttemptTracking() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Check for existing in-progress attempt for this exam
    final existingAttempts = await FirebaseFirestore.instance
        .collection('user_exam_attempts')
        .where('userId', isEqualTo: user.uid)
        .where('department', isEqualTo: widget.department)
        .where('year', isEqualTo: widget.year)
        .where('examType', isEqualTo: widget.examType)
        .where('status', isEqualTo: 'in-progress')
        .get();

    if (existingAttempts.docs.isNotEmpty) {
      // Use existing in-progress attempt
      final existingDoc = existingAttempts.docs.first;
      _attemptDocId = existingDoc.id;
      _startedAt = (existingDoc['startedAt'] as Timestamp).toDate();

      // Restore answers if they exist
      final existingAnswers = existingDoc['answers'] as List<dynamic>?;
      if (existingAnswers != null && existingAnswers.isNotEmpty) {
        _selectedAnswers = existingAnswers.map((a) => a as int?).toList();
      }

      print('DEBUG: Resuming existing attempt: $_attemptDocId');
    } else {
      // Create new attempt
      _startedAt = DateTime.now();
      final doc = await FirebaseFirestore.instance
          .collection('user_exam_attempts')
          .add({
        'userId': user.uid,
        'department': widget.department,
        'year': widget.year,
        'examType': widget.examType,
        'answers': [],
        'score': null,
        'total': null,
        'timeTaken': null,
        'status': 'in-progress',
        'startedAt': Timestamp.fromDate(_startedAt!),
        'completedAt': null,
      });
      setState(() {
        _attemptDocId = doc.id;
      });
      print('DEBUG: Created new attempt: $_attemptDocId');
    }
  }

  Future<void> _saveProgress() async {
    if (_attemptDocId != null) {
      await FirebaseFirestore.instance
          .collection('user_exam_attempts')
          .doc(_attemptDocId)
          .update({
        'answers': _selectedAnswers,
      });
    }
  }

  Future<void> _updateAttemptOnSubmit() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _attemptDocId == null || _startedAt == null) return;
    final completedAt = DateTime.now();
    final timeTaken = completedAt.difference(_startedAt!).inSeconds;
    await FirebaseFirestore.instance
        .collection('user_exam_attempts')
        .doc(_attemptDocId)
        .update({
      'answers': _selectedAnswers,
      'score': _score,
      'total': _questions.length,
      'timeTaken': timeTaken,
      'status': 'completed',
      'completedAt': Timestamp.fromDate(completedAt),
    });
  }

  void _next() {
    if (_currentIndex < _questions.length - 1) {
      setState(() => _currentIndex++);
      _saveProgress();
    }
  }

  void _prev() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
    }
  }

  void _submit() {
    int score = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_selectedAnswers[i] == _questions[i]['correctAnswer']) {
        score++;
      }
    }
    setState(() {
      _score = score;
      _submitted = true;
    });
    _updateAttemptOnSubmit();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_questions.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No questions available.')),
      );
    }
    final q = _questions[_currentIndex];
    print('Current question map: $q');
    final answers = List<String>.from(q['answers'] ?? []);
    final explanation = (q['explanation'] ?? '').toString();
    print('Current question answers: $answers');
    print('Current question explanation: >$explanation<');
    if (answers.isEmpty) {
      return Scaffold(
        body: Center(child: Text('No answers available for this question.')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Exit Exam')),
      body: _submitted
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Your Score: $_score / ${_questions.length}',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _submitted = false;
                        _currentIndex = 0;
                        _selectedAnswers =
                            List<int?>.filled(_questions.length, null);
                      });
                    },
                    child: const Text('Retake Exam'),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Question ${_currentIndex + 1} of ${_questions.length}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Text(q['question'] ?? '',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 24),
                  ...List.generate(
                    answers.length,
                    (i) {
                      final isSelected = _selectedAnswers[_currentIndex] == i;
                      final hasAnswered =
                          _selectedAnswers[_currentIndex] != null;
                      final isCorrect = q['correctAnswer'] == i;
                      Color? tileColor;
                      if (hasAnswered && isCorrect) {
                        tileColor = Colors.green.withOpacity(0.18);
                      } else if (hasAnswered && isSelected && !isCorrect) {
                        tileColor = Colors.red.withOpacity(0.13);
                      }
                      return RadioListTile<int>(
                        value: i,
                        groupValue: _selectedAnswers[_currentIndex],
                        onChanged: (val) {
                          setState(() {
                            _selectedAnswers[_currentIndex] = val;
                          });
                          _saveProgress();
                        },
                        title: Text(answers[i]),
                        tileColor: tileColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        secondary: hasAnswered && isCorrect
                            ? const Icon(Icons.check_circle,
                                color: Colors.green)
                            : null,
                      );
                    },
                  ),
                  // Show explanation only after user has selected an answer
                  if (_selectedAnswers[_currentIndex] != null &&
                      explanation.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: Card(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Text(
                            'Explanation: $explanation',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentIndex > 0)
                        ElevatedButton(
                          onPressed: _prev,
                          child: const Text('Previous'),
                        ),
                      if (_currentIndex < _questions.length - 1)
                        ElevatedButton(
                          onPressed: _selectedAnswers[_currentIndex] == null
                              ? null
                              : _next,
                          child: const Text('Next'),
                        ),
                      if (_currentIndex == _questions.length - 1)
                        ElevatedButton(
                          onPressed: _selectedAnswers[_currentIndex] == null
                              ? null
                              : _submit,
                          child: const Text('Submit'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
