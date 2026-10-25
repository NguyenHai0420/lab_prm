import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/models/task.dart';

void main() {
  group('Task Model Unit Tests (AAA Pattern - LAB 11.1)', () {
    test('Default completed value should be false', () {
      // Arrange
      final task = Task(id: 'task-1', title: 'Buy groceries');

      // Act
      final isCompleted = task.completed;

      // Assert
      expect(isCompleted, isFalse);
    });

    test('toggle() switches completed between true and false', () {
      // Arrange
      final task = Task(id: 'task-2', title: 'Complete Lab 11', completed: false);

      // Act 1: false -> true
      task.toggle();

      // Assert 1
      expect(task.completed, isTrue);

      // Act 2: true -> false
      task.toggle();

      // Assert 2
      expect(task.completed, isFalse);
    });

    test('copyWith updates specified fields correctly', () {
      // Arrange
      final initial = Task(id: 'task-3', title: 'Initial Title', completed: false);

      // Act
      final updated = initial.copyWith(title: 'Updated Title', completed: true);

      // Assert
      expect(updated.id, 'task-3');
      expect(updated.title, 'Updated Title');
      expect(updated.completed, isTrue);
    });

    test('toJson and fromJson serialize and deserialize correctly', () {
      // Arrange
      final original = Task(
        id: 'task-4',
        title: 'Serialization Test',
        description: 'Test description',
        completed: true,
      );

      // Act
      final json = original.toJson();
      final reconstructed = Task.fromJson(json);

      // Assert
      expect(reconstructed.id, original.id);
      expect(reconstructed.title, original.title);
      expect(reconstructed.description, original.description);
      expect(reconstructed.completed, original.completed);
    });
  });
}
