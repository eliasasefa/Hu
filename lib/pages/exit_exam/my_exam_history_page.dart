import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'take_exit_exam_page.dart';
import 'review_exam_page.dart';

class MyExamHistoryPage extends StatelessWidget {
  const MyExamHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Exam History')),
        body: const Center(child: Text('You must be logged in.')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('My Exam History')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user_exam_attempts')
            .where('userId', isEqualTo: user.uid)
            .orderBy('startedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No exam attempts found.'));
          }
          final attempts = snapshot.data!.docs;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemCount: attempts.length,
            itemBuilder: (context, i) {
              final data = attempts[i].data() as Map<String, dynamic>;
              final status = data['status'] ?? 'completed';
              final score = data['score'];
              final total = data['total'];
              final timeTaken = data['timeTaken'];
              final answers = data['answers'] as List<dynamic>?;
              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  if (status == 'in-progress') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TakeExitExamPage(
                          department: data['department'],
                          year: data['year'],
                          examType: data['examType'],
                          attemptDocId: attempts[i].id,
                          selectedAnswers: answers?.cast<int?>() ?? [],
                        ),
                      ),
                    );
                  } else if (status == 'completed') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReviewExamPage(
                          department: data['department'],
                          year: data['year'],
                          examType: data['examType'],
                          answers: answers ?? [],
                        ),
                      ),
                    );
                  }
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color:
                          status == 'completed' ? Colors.green : Colors.orange,
                      width: 2,
                    ),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: status == 'completed'
                                    ? Colors.green.withOpacity(0.13)
                                    : Colors.orange.withOpacity(0.13),
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Icon(
                                status == 'completed'
                                    ? Icons.check_circle
                                    : Icons.timelapse,
                                color: status == 'completed'
                                    ? Colors.green
                                    : Colors.orange,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${data['department'] ?? ''} | Year: ${data['year'] ?? ''} | ${data['examType'] ?? ''}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  if (data['startedAt'] != null)
                                    Text(
                                      _formatDate(data['startedAt']),
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.6),
                                        fontSize: 13,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: status == 'completed'
                                    ? Theme.of(context).colorScheme.secondary
                                    : Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                status == 'completed'
                                    ? 'Completed'
                                    : 'In Progress',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            if (status == 'completed' &&
                                score != null &&
                                total != null)
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text('Score: $score/$total',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onTertiary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12)),
                              ),
                            if (timeTaken != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text('Time: ${_formatTime(timeTaken)}',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12)),
                              ),
                          ],
                        ),
                        // Always show progress for in-progress exams with a known total > 0
                        if (status == 'in-progress' &&
                            total != null &&
                            total > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Progress: ${(answers != null ? answers.where((a) => a != null).length : 0)}/$total answered',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Expanded(
                                      child: LinearProgressIndicator(
                                        value: (answers != null
                                                ? answers
                                                    .where((a) => a != null)
                                                    .length
                                                : 0) /
                                            total,
                                        minHeight: 8,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      '${(((answers != null ? answers.where((a) => a != null).length : 0) / total) * 100).toStringAsFixed(0)}% done',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(Timestamp ts) {
    final dt = ts.toDate();
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  String _formatTime(dynamic seconds) {
    if (seconds is int) {
      final min = seconds ~/ 60;
      final sec = seconds % 60;
      return '${min}m ${sec}s';
    }
    return seconds.toString();
  }
}
