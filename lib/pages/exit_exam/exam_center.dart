import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'take_exit_exam_page.dart';

class ExamCenterPage extends StatelessWidget {
  const ExamCenterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Center'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('exit_exam_questions')
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                      'No departments found. Import questions to get started.'),
                  const SizedBox(height: 24),
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
            // Extract unique departments
            final departments = snapshot.data!.docs
                .where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return data.containsKey('department') &&
                      data['department'] != null &&
                      data['department'].toString().isNotEmpty;
                })
                .map((doc) => doc['department'] as String)
                .toSet()
                .toList();
            departments.sort();
            return ListView.separated(
              itemCount: departments.length,
              separatorBuilder: (_, __) => const SizedBox(height: 18),
              itemBuilder: (context, i) {
                final department = departments[i]!;
                return ExamCenterCard(
                  icon: Icons.school,
                  title: department,
                  description: 'View and manage exams for $department.',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            DepartmentExamPage(department: department),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.upload_file),
        label: Text('Import Exam'),
        onPressed: () {
          Navigator.of(context).pushNamed('/import-exit-exam-questions');
        },
      ),
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
