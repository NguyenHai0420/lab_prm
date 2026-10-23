import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../models/note_item.dart';

class StorageService92 {
  static const String _fileName = 'notes_storage.json';

  // In-memory fallback if on Web / DartPad where dart:io File is unsupported
  static final List<NoteItem> _webMemoryNotes = [];

  // Locate the file in the device's application documents directory
  Future<File?> _getLocalFile() async {
    if (kIsWeb) return null;
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  // Get the display path of the local JSON storage file
  Future<String> getFilePath() async {
    if (kIsWeb) return 'Web / DartPad Local Memory ($_fileName)';
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}\\$_fileName';
  }

  // Load notes from local JSON file
  Future<List<NoteItem>> loadNotes() async {
    if (kIsWeb) {
      if (_webMemoryNotes.isEmpty) {
        _webMemoryNotes.addAll(_initialDefaultNotes());
      }
      return List<NoteItem>.from(_webMemoryNotes);
    }

    try {
      final file = await _getLocalFile();
      if (file == null) return [];

      // If file doesn't exist, create it with initial default notes
      if (!await file.exists()) {
        final initialNotes = _initialDefaultNotes();
        await saveNotes(initialNotes);
        return initialNotes;
      }

      // Read existing JSON file
      final String content = await file.readAsString();
      if (content.trim().isEmpty) return [];

      // Decode JSON to List<NoteItem>
      final dynamic decoded = jsonDecode(content);
      if (decoded is List) {
        return decoded
            .map((item) => NoteItem.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error reading notes JSON: $e');
      return [];
    }
  }

  // Save notes list back to local JSON file
  Future<void> saveNotes(List<NoteItem> notes) async {
    if (kIsWeb) {
      _webMemoryNotes.clear();
      _webMemoryNotes.addAll(notes);
      return;
    }

    final file = await _getLocalFile();
    if (file == null) return;

    // Convert notes to JSON string
    final String jsonString = jsonEncode(
      notes.map((note) => note.toJson()).toList(),
    );

    // Write to device storage
    await file.writeAsString(jsonString);
  }

  // Clear all saved notes in file
  Future<void> clearNotes() async {
    if (kIsWeb) {
      _webMemoryNotes.clear();
      return;
    }
    final file = await _getLocalFile();
    if (file != null && await file.exists()) {
      await file.writeAsString(jsonEncode([]));
    }
  }

  List<NoteItem> _initialDefaultNotes() {
    return [
      NoteItem(
        id: '1',
        title: 'Welcome to Lab 9.2',
        content: 'This note was persisted into the device local storage via path_provider.',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      NoteItem(
        id: '2',
        title: 'Local JSON File Persistence',
        content: 'Any notes you add or delete will be saved to notes_storage.json.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
      ),
    ];
  }
}
