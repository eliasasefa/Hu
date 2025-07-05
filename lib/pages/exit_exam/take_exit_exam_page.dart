import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TakeExitExamPage extends StatefulWidget {
  final String department;
  final String year;
  final String examType;
  const TakeExitExamPage(
      {Key? key,
      required this.department,
      required this.year,
      required this.examType})
      : super(key: key);

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

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    setState(() => _isLoading = true);
    final snapshot = await FirebaseFirestore.instance
        .collection('exit_exam_questions')
        .where('department', isEqualTo: widget.department)
        .where('year', isEqualTo: widget.year)
        .where('examType', isEqualTo: widget.examType)
        .orderBy('createdAt')
        .get();
    _questions = snapshot.docs.map((doc) => doc.data()).toList();
    _selectedAnswers = List<int?>.filled(_questions.length, null);
    setState(() => _isLoading = false);
  }

  void _next() {
    if (_currentIndex < _questions.length - 1) {
      setState(() => _currentIndex++);
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
    final answers = List<String>.from(q['answers'] ?? []);
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
                      (i) => RadioListTile<int>(
                            value: i,
                            groupValue: _selectedAnswers[_currentIndex],
                            onChanged: (val) {
                              setState(() {
                                _selectedAnswers[_currentIndex] = val;
                              });
                            },
                            title: Text(answers[i]),
                          )),
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
