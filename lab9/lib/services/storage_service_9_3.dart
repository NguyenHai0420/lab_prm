import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../models/student_record.dart';

class StorageService93 {
  static const String _fileName = 'students_database.json';

  // In-memory fallback if running on Web / DartPad
  static final List<StudentRecord> _webMemoryStudents = [];

  Future<File?> _getLocalFile() async {
    if (kIsWeb) return null;
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  Future<String> getFilePath() async {
    if (kIsWeb) return 'Web / DartPad Local Memory ($_fileName)';
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}\\$_fileName';
  }

  /// Load all students from local JSON mini-database
  Future<List<StudentRecord>> loadStudents() async {
    if (kIsWeb) {
      if (_webMemoryStudents.isEmpty) {
        _webMemoryStudents.addAll(_seedData());
      }
      return List<StudentRecord>.from(_webMemoryStudents);
    }

    try {
      final file = await _getLocalFile();
      if (file == null) return [];

      if (!await file.exists()) {
        final defaultList = _seedData();
        await saveStudents(defaultList);
        return defaultList;
      }

      final String content = await file.readAsString();
      if (content.trim().isEmpty) return [];

      final dynamic decoded = jsonDecode(content);
      if (decoded is List) {
        return decoded
            .map((item) => StudentRecord.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error loading student database: $e');
      return [];
    }
  }

  /// Persist the student list into the local JSON mini-database
  Future<void> saveStudents(List<StudentRecord> students) async {
    if (kIsWeb) {
      _webMemoryStudents.clear();
      _webMemoryStudents.addAll(students);
      return;
    }

    final file = await _getLocalFile();
    if (file == null) return;

    final String jsonString = const JsonEncoder.withIndent('  ').convert(
      students.map((s) => s.toJson()).toList(),
    );
    await file.writeAsString(jsonString);
  }

  /// Read raw JSON string from file for viewing/debugging
  Future<String> getRawJson() async {
    if (kIsWeb) {
      return const JsonEncoder.withIndent('  ').convert(
        _webMemoryStudents.map((s) => s.toJson()).toList(),
      );
    }

    final file = await _getLocalFile();
    if (file != null && await file.exists()) {
      return await file.readAsString();
    }
    return '[]';
  }

  /// Reset to seed data
  Future<List<StudentRecord>> resetDatabase() async {
    final seed = _seedData();
    await saveStudents(seed);
    return seed;
  }

  List<StudentRecord> _seedData() {
    return [
      StudentRecord(
        id: 1,
        studentId: 'SE170101',
        fullName: 'Nguyen Van An',
        email: 'annv.se170101@fpt.edu.vn',
        major: 'Software Engineering',
        gpa: 3.65,
      ),
      StudentRecord(
        id: 2,
        studentId: 'SE170202',
        fullName: 'Tran Thi Bich',
        email: 'bichtt.se170202@fpt.edu.vn',
        major: 'Artificial Intelligence',
        gpa: 3.82,
      ),
      StudentRecord(
        id: 3,
        studentId: 'SE170303',
        fullName: 'Le Hoang Cuong',
        email: 'cuonglh.se170303@fpt.edu.vn',
        major: 'Information Assurance',
        gpa: 3.25,
      ),
      StudentRecord(
        id: 4,
        studentId: 'SE170404',
        fullName: 'Pham Minh Duc',
        email: 'ducpm.se170404@fpt.edu.vn',
        major: 'Software Engineering',
        gpa: 3.90,
      ),
    ];
  }
}
