import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/models/task.dart';
import 'package:taskly/repositories/task_repository.dart';
import 'package:taskly/screens/task_list_screen.dart';

void main() {
  group('Task Navigation Tests (LAB 11.3)', () {
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository();
    });

    testWidgets(
        'Tap seeded task navigates to TaskDetailScreen with expected title and TextField key',
        (WidgetTester tester) async {
      // Step 1: Seed repository with at least one task
      final seededTask = Task(id: 'seed-1', title: 'Seeded Navigation Task');
      repository.addTask(seededTask);

      // Step 2: Pump TaskListScreen
      await tester.pumpWidget(
        MaterialApp(
          home: TaskListScreen(repository: repository),
        ),
      );

      expect(find.text('Seeded Navigation Task'), findsOneWidget);

      // Step 3: Tap seeded task -> call pumpAndSettle()
      await tester.tap(find.text('Seeded Navigation Task'));
      await tester.pumpAndSettle();

      // Step 4: Validate:
      // - AppBar title: “Task Detail”
      expect(find.text('Task Detail'), findsOneWidget);

      // - TextField key: detailTitleField
      expect(find.byKey(const Key('detailTitleField')), findsOneWidget);
    });
  });
}
