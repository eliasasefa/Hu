import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewExamPage extends StatelessWidget {
  final String department;
  final String year;
  final String examType;
  final List<dynamic> answers;
  const ReviewExamPage({
    Key? key,
    required this.department,
    required this.year,
    required this.examType,
    required this.answers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Review Exam')),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('exit_exam_questions')
            .where('department', isEqualTo: department)
            .where('year', isEqualTo: year)
            .where('examType', isEqualTo: examType)
            .orderBy('createdAt')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No questions found.'));
          }
          final questions = snapshot.data!.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            separatorBuilder: (_, __) => const SizedBox(height: 18),
            itemCount: questions.length,
            itemBuilder: (context, i) {
              final q = questions[i];
              final userAnswer = (i < answers.length) ? answers[i] : null;
              final correctAnswer = q['correctAnswer'];
              final options = List<String>.from(q['answers'] ?? []);
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Q${i + 1}: ${q['question'] ?? ''}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 10),
                      ...List.generate(options.length, (j) {
                        final isUser = userAnswer == j;
                        final isCorrect = correctAnswer == j;
                        Color? color;
                        if (isCorrect && isUser) {
                          color = Colors.green;
                        } else if (isCorrect) {
                          color = Colors.green.withOpacity(0.2);
                        } else if (isUser) {
                          color = Colors.red.withOpacity(0.2);
                        }
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 3),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(8),
                            border: isCorrect
                                ? Border.all(color: Colors.green, width: 1.5)
                                : null,
                          ),
                          child: ListTile(
                            leading: Icon(
                              isCorrect
                                  ? Icons.check_circle
                                  : isUser
                                      ? Icons.cancel
                                      : Icons.radio_button_unchecked,
                              color: isCorrect
                                  ? Colors.green
                                  : isUser
                                      ? Colors.red
                                      : Colors.grey,
                            ),
                            title: Text(options[j]),
                            trailing: isUser
                                ? const Text('Your answer',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12))
                                : null,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
