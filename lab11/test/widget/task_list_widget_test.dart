import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/repositories/task_repository.dart';
import 'package:taskly/screens/task_list_screen.dart';

void main() {
  group('TaskListScreen Widget Tests (LAB 11.2)', () {
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository();
    });

    testWidgets('Empty State displays "No tasks yet. Add one!"',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: TaskListScreen(repository: repository),
        ),
      );

      // Assert
      expect(find.text('No tasks yet. Add one!'), findsOneWidget);
    });

    testWidgets('Add Task: enter text -> tap add -> verify UI updates',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: TaskListScreen(repository: repository),
        ),
      );

      // Act: enter text
      await tester.enterText(
          find.byKey(const Key('taskInputField')), 'Study Flutter Testing');
      // Act: tap add
      await tester.tap(find.byKey(const Key('addTaskButton')));
      // Act: pump UI
      await tester.pump();

      // Assert: verify newly added task title is visible
      expect(find.text('Study Flutter Testing'), findsOneWidget);
      expect(find.text('No tasks yet. Add one!'), findsNothing);
    });

    testWidgets('Multiple Tasks: add two tasks -> verify both visible',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: TaskListScreen(repository: repository),
        ),
      );

      // Act: Add Task 1
      await tester.enterText(find.byKey(const Key('taskInputField')), 'Task 1');
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();

      // Act: Add Task 2
      await tester.enterText(find.byKey(const Key('taskInputField')), 'Task 2');
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();

      // Assert: verify both visible
      expect(find.text('Task 1'), findsOneWidget);
      expect(find.text('Task 2'), findsOneWidget);
    });
  });
}
