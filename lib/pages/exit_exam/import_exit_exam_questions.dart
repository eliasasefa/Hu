import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class ImportExitExamQuestionsPage extends StatefulWidget {
  const ImportExitExamQuestionsPage({Key? key}) : super(key: key);

  @override
  State<ImportExitExamQuestionsPage> createState() =>
      _ImportExitExamQuestionsPageState();
}

class _ImportExitExamQuestionsPageState
    extends State<ImportExitExamQuestionsPage> {
  bool _isImporting = false;
  String? _status;
  int _currentImport = 0;
  int _totalToImport = 0;

  Future<void> _importQuestionsFromFile() async {
    setState(() {
      _isImporting = true;
      _status = null;
      _currentImport = 0;
      _totalToImport = 0;
    });
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (result == null || result.files.single.path == null) {
        setState(() {
          _status = 'No file selected.';
          _isImporting = false;
        });
        return;
      }
      final file = File(result.files.single.path!);
      final String jsonString = await file.readAsString();
      final Map<String, dynamic> data = json.decode(jsonString);
      final String? department = data['department'];
      final String? year = data['year'];
      final String? examType = data['examType'];
      final List<dynamic>? questions = data['questions'];
      if (department == null ||
          year == null ||
          examType == null ||
          questions == null) {
        setState(() {
          _status =
              'Invalid JSON: department, year, examType, or questions missing.';
          _isImporting = false;
        });
        return;
      }
      int imported = 0;
      setState(() {
        _totalToImport = questions.length;
      });
      for (int i = 0; i < questions.length; i++) {
        final q = questions[i] as Map<String, dynamic>;
        setState(() {
          _currentImport = i + 1;
        });
        final question = q['question']?.toString();
        final answers =
            q['answers'] is List ? List<String>.from(q['answers']) : null;
        final correctAnswer = q['correctAnswer'] is int
            ? q['correctAnswer']
            : int.tryParse(q['correctAnswer']?.toString() ?? '');
        final explanation = q['explanation']?.toString() ?? '';
        if (question != null &&
            answers != null &&
            correctAnswer != null &&
            answers.length == 4) {
          await FirebaseFirestore.instance
              .collection('exit_exam_questions')
              .add({
            'question': question,
            'answers': answers,
            'correctAnswer': correctAnswer,
            'explanation': explanation,
            'department': department,
            'year': year,
            'examType': examType,
            'createdAt': FieldValue.serverTimestamp(),
          });
          imported++;
        }
      }
      setState(() {
        _status = 'Imported $imported questions successfully!';
      });
      if (imported > 0 && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Imported $imported questions successfully!')),
        );
        await Future.delayed(const Duration(milliseconds: 1500));
        if (mounted) Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    } finally {
      setState(() {
        _isImporting = false;
        _currentImport = 0;
        _totalToImport = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Import Exit Exam Questions')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.upload_file),
                label: const Text('Import from JSON file'),
                onPressed: _isImporting ? null : _importQuestionsFromFile,
              ),
              const SizedBox(height: 24),
              if (_isImporting) ...[
                if (_totalToImport > 0)
                  Column(
                    children: [
                      Text(
                          'Importing question $_currentImport of $_totalToImport...'),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: _currentImport / _totalToImport,
                        minHeight: 8,
                      ),
                    ],
                  )
                else
                  const CircularProgressIndicator(),
              ],
              if (_status != null) ...[
                const SizedBox(height: 16),
                Text(_status!,
                    style: TextStyle(
                        color: _status!.startsWith('Error')
                            ? Colors.red
                            : Colors.green)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
