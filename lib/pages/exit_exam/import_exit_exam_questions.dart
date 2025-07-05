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

  Future<void> _importQuestionsFromFile() async {
    setState(() {
      _isImporting = true;
      _status = null;
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
      for (final q in questions) {
        if (q['question'] != null &&
            q['answers'] != null &&
            q['correctAnswer'] != null &&
            (q['answers'] as List).length == 4) {
          await FirebaseFirestore.instance
              .collection('exit_exam_questions')
              .add({
            'question': q['question'],
            'answers': List<String>.from(q['answers']),
            'correctAnswer': q['correctAnswer'],
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
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    } finally {
      setState(() {
        _isImporting = false;
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
              if (_isImporting) const CircularProgressIndicator(),
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
