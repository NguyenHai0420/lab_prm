import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/main.dart';
import 'package:taskly/repositories/task_repository.dart';

void main() {
  group('Full Flow Integration Test (LAB 11.4 Part A)', () {
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository();
    });

    testWidgets(
        'Full flow: Add "Original title" -> Open detail -> Edit "Updated title" -> Save -> Verify in list',
        (WidgetTester tester) async {
      // 1. Launch App
      await tester.pumpWidget(TasklyApp(repository: repository));
      expect(find.text('No tasks yet. Add one!'), findsOneWidget);

      // 2. Add "Original title"
      await tester.enterText(
          find.byKey(const Key('taskInputField')), 'Original title');
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pumpAndSettle();

      expect(find.text('Original title'), findsOneWidget);

      // 3. Tap task -> open detail
      await tester.tap(find.text('Original title'));
      await tester.pumpAndSettle();

      expect(find.text('Task Detail'), findsOneWidget);
      expect(find.byKey(const Key('detailTitleField')), findsOneWidget);

      // 4. Edit -> "Updated title"
      await tester.enterText(
          find.byKey(const Key('detailTitleField')), 'Updated title');

      // 5. Save
      await tester.tap(find.byKey(const Key('saveTaskButton')));
      await tester.pumpAndSettle();

      // 6. Verify updated title appears in list and original is replaced
      expect(find.text('Updated title'), findsOneWidget);
      expect(find.text('Original title'), findsNothing);
    });
  });
}
