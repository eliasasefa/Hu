import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'take_exit_exam_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'my_exam_history_page.dart';

class ExamCenterPage extends StatefulWidget {
  const ExamCenterPage({Key? key}) : super(key: key);

  static final Future<QuerySnapshot> _examsFuture =
      FirebaseFirestore.instance.collection('exit_exam_questions').get();

  @override
  State<ExamCenterPage> createState() => _ExamCenterPageState();
}

class _ExamCenterPageState extends State<ExamCenterPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isAdmin = user?.email == 'eliasasefa3@gmail.com';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Center'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: FutureBuilder<QuerySnapshot>(
          future: ExamCenterPage._examsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _examHistoryCard(context),
                  const SizedBox(height: 24),
                  const Text(
                      'No departments found. Import questions to get started.'),
                  const SizedBox(height: 24),
                  if (isAdmin)
                    ElevatedButton.icon(
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Import Exam Questions'),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed('/import-exit-exam-questions');
                      },
                    ),
                ],
              );
            }
            // Group exams by department
            final Map<String, List<Map<String, String>>> grouped = {};
            for (final doc in snapshot.data!.docs) {
              final data = doc.data() as Map<String, dynamic>;
              final dept = data['department']?.toString();
              final year = data['year']?.toString();
              final examType = data['examType']?.toString();
              if (dept != null &&
                  dept.isNotEmpty &&
                  year != null &&
                  examType != null) {
                grouped.putIfAbsent(dept, () => []);
                // Avoid duplicate year+examType pairs
                if (!grouped[dept]!.any(
                    (e) => e['year'] == year && e['examType'] == examType)) {
                  grouped[dept]!.add({'year': year, 'examType': examType});
                }
              }
            }
            // Filter logic
            final String query = _searchQuery.trim().toLowerCase();
            Map<String, List<Map<String, String>>> filteredGrouped;
            List<String> filteredDepartments;
            if (query.isEmpty) {
              filteredGrouped = grouped;
              filteredDepartments = grouped.keys.toList()..sort();
            } else {
              filteredGrouped = {};
              for (final entry in grouped.entries) {
                final dept = entry.key;
                final exams = entry.value;
                // If department matches, include all its exams
                if (dept.toLowerCase().contains(query)) {
                  filteredGrouped[dept] = exams;
                } else {
                  // Otherwise, filter exams by year or examType
                  final filteredExams = exams
                      .where((exam) =>
                          exam['year']!.toLowerCase().contains(query) ||
                          exam['examType']!.toLowerCase().contains(query))
                      .toList();
                  if (filteredExams.isNotEmpty) {
                    filteredGrouped[dept] = filteredExams;
                  }
                }
              }
              filteredDepartments = filteredGrouped.keys.toList()..sort();
            }
            return Column(
              children: [
                // Search bar
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search exams by department, year, or type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 18),
                _examHistoryCard(context),
                const SizedBox(height: 18),
                Expanded(
                  child: filteredDepartments.isEmpty
                      ? const Center(child: Text('No exams found.'))
                      : _DepartmentExpansionList(
                          grouped: filteredGrouped,
                          departments: filteredDepartments,
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _examHistoryCard(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseAuth.instance.currentUser == null
          ? Future.value(null)
          : FirebaseFirestore.instance
              .collection('user_exam_attempts')
              .where('userId',
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .get(),
      builder: (context, snapshot) {
        int completed = 0;
        int inProgress = 0;
        if (snapshot.hasData && snapshot.data != null) {
          for (var doc in snapshot.data!.docs) {
            final status = (doc['status'] ?? 'completed').toString();
            if (status == 'completed') completed++;
            if (status == 'in-progress') inProgress++;
          }
        }
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 5,
          margin: const EdgeInsets.only(bottom: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyExamHistoryPage()),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.18),
                    theme.colorScheme.primary.withOpacity(0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Icon(Icons.history,
                        color: theme.colorScheme.primary, size: 36),
                  ),
                  const SizedBox(width: 22),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('My Exam History',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            )),
                        const SizedBox(height: 4),
                        Text('View your past and in-progress exams',
                            style: theme.textTheme.bodyMedium),
                        if (snapshot.connectionState == ConnectionState.done)
                          Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  if (completed > 0)
                                    Flexible(
                                      child: Row(
                                        children: [
                                          Icon(Icons.check_circle,
                                              color: Colors.green, size: 18),
                                          const SizedBox(width: 4),
                                          Text('$completed completed',
                                              style: const TextStyle(
                                                  fontSize: 13)),
                                        ],
                                      ),
                                    ),
                                  if (completed > 0 && inProgress > 0)
                                    const SizedBox(width: 12),
                                  if (inProgress > 0)
                                    Flexible(
                                      child: Row(
                                        children: [
                                          Icon(Icons.timelapse,
                                              color: Colors.orange, size: 18),
                                          const SizedBox(width: 4),
                                          Text('$inProgress in progress',
                                              style: const TextStyle(
                                                  fontSize: 13)),
                                        ],
                                      ),
                                    ),
                                  if (completed == 0 && inProgress == 0)
                                    const Text('No attempts yet',
                                        style: TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios,
                      size: 22, color: Colors.grey),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ExamCenterCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const ExamCenterCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          child: Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.15),
                child: Icon(icon,
                    size: 40, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(width: 28),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(description,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 24, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class DepartmentExamPage extends StatefulWidget {
  final String department;
  const DepartmentExamPage({Key? key, required this.department})
      : super(key: key);

  @override
  State<DepartmentExamPage> createState() => _DepartmentExamPageState();
}

class _DepartmentExamPageState extends State<DepartmentExamPage> {
  List<Map<String, String>> examPairs = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchExamPairs();
  }

  Future<void> _fetchExamPairs() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('exit_exam_questions')
        .where('department', isEqualTo: widget.department)
        .get();
    final pairSet = <String>{};
    final pairs = <Map<String, String>>[];
    for (final doc in snapshot.docs) {
      final y = doc['year']?.toString();
      final t = doc['examType']?.toString();
      if (y != null && t != null) {
        final key = '$y|$t';
        if (!pairSet.contains(key)) {
          pairSet.add(key);
          pairs.add({'year': y, 'examType': t});
        }
      }
    }
    setState(() {
      examPairs = pairs;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.department} Exams')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : examPairs.isEmpty
              ? const Center(child: Text('No exams found for this department.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(24.0),
                  itemCount: examPairs.length,
                  itemBuilder: (context, index) {
                    final pair = examPairs[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.description),
                        title: Text(
                            'Year ${pair['year']} - ${pair['examType']} Exam'),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => TakeExitExamPage(
                                department: widget.department,
                                year: pair['year']!,
                                examType: pair['examType']!,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}

class _DepartmentExpansionList extends StatefulWidget {
  final Map<String, List<Map<String, String>>> grouped;
  final List<String> departments;
  const _DepartmentExpansionList({
    Key? key,
    required this.grouped,
    required this.departments,
  }) : super(key: key);

  @override
  State<_DepartmentExpansionList> createState() =>
      _DepartmentExpansionListState();
}

class _DepartmentExpansionListState extends State<_DepartmentExpansionList> {
  late List<bool> _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = List.generate(widget.departments.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.departments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 18),
      itemBuilder: (context, i) {
        final department = widget.departments[i];
        final exams = widget.grouped[department]!;
        return ExpansionTile(
          key: PageStorageKey(department),
          initiallyExpanded: _expanded[i],
          onExpansionChanged: (expanded) {
            setState(() {
              _expanded[i] = expanded;
            });
          },
          leading:
              Icon(Icons.school, color: Theme.of(context).colorScheme.primary),
          title: Text(
            department,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          children: exams
              .map((exam) => ListTile(
                    contentPadding: const EdgeInsets.only(left: 24, right: 16),
                    leading: const Icon(Icons.description),
                    title:
                        Text('Year ${exam['year']} - ${exam['examType']} Exam'),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => TakeExitExamPage(
                            department: department,
                            year: exam['year']!,
                            examType: exam['examType']!,
                          ),
                        ),
                      );
                    },
                  ))
              .toList(),
        );
      },
    );
  }
}
