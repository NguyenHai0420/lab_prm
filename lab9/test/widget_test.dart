import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab9/main.dart';
import 'package:lab9/models/product.dart';
import 'package:lab9/models/note_item.dart';
import 'package:lab9/models/student_record.dart';

void main() {
  group('JSON Model Serialization Tests', () {
    test('Product model should correctly decode from JSON and encode to JSON', () {
      final json = {
        'id': 101,
        'name': 'Test Laptop',
        'category': 'Computers',
        'price': 1200.50,
        'rating': 4.9,
        'description': 'High performance test laptop',
        'stock': 15,
      };

      final product = Product.fromJson(json);
      expect(product.id, 101);
      expect(product.name, 'Test Laptop');
      expect(product.category, 'Computers');
      expect(product.price, 1200.50);
      expect(product.rating, 4.9);
      expect(product.stock, 15);

      final encoded = product.toJson();
      expect(encoded['id'], 101);
      expect(encoded['name'], 'Test Laptop');
    });

    test('NoteItem model should serialize and deserialize properly', () {
      final now = DateTime.now();
      final note = NoteItem(
        id: 'note_1',
        title: 'Meeting Notes',
        content: 'Discuss sprint goals',
        createdAt: now,
      );

      final json = note.toJson();
      expect(json['title'], 'Meeting Notes');
      expect(json['content'], 'Discuss sprint goals');

      final reconstructed = NoteItem.fromJson(json);
      expect(reconstructed.id, 'note_1');
      expect(reconstructed.title, 'Meeting Notes');
      expect(reconstructed.content, 'Discuss sprint goals');
    });

    test('StudentRecord model should handle CRUD modifications via copyWith', () {
      final student = StudentRecord(
        id: 1,
        studentId: 'SE170001',
        fullName: 'Le Van An',
        email: 'anlv@fpt.edu.vn',
        major: 'Software Engineering',
        gpa: 3.5,
      );

      expect(student.studentId, 'SE170001');

      final updated = student.copyWith(gpa: 3.8, major: 'Artificial Intelligence');
      expect(updated.id, 1);
      expect(updated.gpa, 3.8);
      expect(updated.major, 'Artificial Intelligence');
      expect(updated.fullName, 'Le Van An');

      final json = updated.toJson();
      expect(json['gpa'], 3.8);
      expect(json['major'], 'Artificial Intelligence');
    });
  });

  group('Asset JSON Integrity Test', () {
    test('assets/data/products.json must exist, be valid JSON, and contain at least 2 fields per item', () {
      final file = File('assets/data/products.json');
      expect(file.existsSync(), isTrue, reason: 'assets/data/products.json must exist in project');

      final content = file.readAsStringSync();
      final decoded = jsonDecode(content);
      expect(decoded, isA<List>());

      final list = decoded as List;
      expect(list.isNotEmpty, isTrue);

      for (final item in list) {
        final map = item as Map<String, dynamic>;
        expect(map.containsKey('name'), isTrue);
        expect(map.containsKey('price'), isTrue);
        expect(map.containsKey('category'), isTrue);

        // Verify that model parsing works cleanly
        final product = Product.fromJson(map);
        expect(product.name.isNotEmpty, isTrue);
        expect(product.price, greaterThanOrEqualTo(0));
      }
    });
  });

  group('CRUD Operations Logic Test', () {
    test('Simulate CRUD on in-memory student database', () {
      final students = <StudentRecord>[
        StudentRecord(
          id: 1,
          studentId: 'SE170101',
          fullName: 'Nguyen Van An',
          email: 'annv@fpt.edu.vn',
          major: 'Software Engineering',
          gpa: 3.65,
        ),
      ];

      // CREATE
      final newStudent = StudentRecord(
        id: 2,
        studentId: 'SE170202',
        fullName: 'Tran Thi Bich',
        email: 'bichtt@fpt.edu.vn',
        major: 'Artificial Intelligence',
        gpa: 3.82,
      );
      students.add(newStudent);
      expect(students.length, 2);

      // READ (Search)
      final searchResult = students.where((s) => s.fullName.toLowerCase().contains('bich')).toList();
      expect(searchResult.length, 1);
      expect(searchResult.first.studentId, 'SE170202');

      // UPDATE
      final editIndex = students.indexWhere((s) => s.id == 2);
      expect(editIndex, isNot(-1));
      students[editIndex] = students[editIndex].copyWith(gpa: 3.95);
      expect(students[editIndex].gpa, 3.95);

      // DELETE
      students.removeWhere((s) => s.id == 1);
      expect(students.length, 1);
      expect(students.first.id, 2);

      // Encode to JSON
      final jsonString = jsonEncode(students.map((e) => e.toJson()).toList());
      expect(jsonString.contains('Tran Thi Bich'), isTrue);
      expect(jsonString.contains('3.95'), isTrue);
    });
  });

  group('Widget Smoke Tests', () {
    testWidgets('Lab9App loads HomeScreen with 3 tabs', (WidgetTester tester) async {
      await tester.pumpWidget(const Lab9App());
      await tester.pump();

      // Navigation Bar items
      expect(find.text('9.1 Assets'), findsOneWidget);
      expect(find.text('9.2 Storage'), findsOneWidget);
      expect(find.text('9.3 CRUD DB'), findsOneWidget);
    });
  });
}
