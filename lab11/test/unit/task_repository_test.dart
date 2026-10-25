import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/models/task.dart';
import 'package:taskly/repositories/task_repository.dart';

void main() {
  group('TaskRepository Unit Tests (AAA Pattern - LAB 11.1)', () {
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository();
    });

    test('addTask() adds a task and increases task count', () {
      // Arrange
      final task = Task(id: '1', title: 'Task 1');

      // Act
      repository.addTask(task);

      // Assert
      expect(repository.taskCount, 1);
      expect(repository.tasks.first.title, 'Task 1');
      expect(repository.getTaskById('1'), equals(task));
    });

    test('deleteTask() removes task by id and returns true', () {
      // Arrange
      final task = Task(id: '2', title: 'Task 2');
      repository.addTask(task);
      expect(repository.taskCount, 1);

      // Act
      final deleted = repository.deleteTask('2');

      // Assert
      expect(deleted, isTrue);
      expect(repository.taskCount, 0);
      expect(repository.getTaskById('2'), isNull);
    });

    test('deleteTask() returns false when id does not exist', () {
      // Arrange
      const nonExistentId = '999';

      // Act
      final deleted = repository.deleteTask(nonExistentId);

      // Assert
      expect(deleted, isFalse);
    });

    test('updateTask() modifies task fields successfully', () {
      // Arrange
      final task = Task(id: '3', title: 'Original Title', completed: false);
      repository.addTask(task);

      final updatedTask = task.copyWith(title: 'Updated Title', completed: true);

      // Act
      final success = repository.updateTask(updatedTask);

      // Assert
      expect(success, isTrue);
      final retrieved = repository.getTaskById('3');
      expect(retrieved?.title, 'Updated Title');
      expect(retrieved?.completed, isTrue);
    });

    test('toggleTask() flips completed state of existing task', () {
      // Arrange
      final task = Task(id: '4', title: 'Toggle Task', completed: false);
      repository.addTask(task);

      // Act
      repository.toggleTask('4');

      // Assert
      expect(repository.getTaskById('4')?.completed, isTrue);
    });

    test('clear() removes all tasks and notifies listeners', () {
      // Arrange
      repository.addTask(Task(id: '1', title: 'Task A'));
      repository.addTask(Task(id: '2', title: 'Task B'));
      expect(repository.taskCount, 2);

      // Act
      repository.clear();

      // Assert
      expect(repository.taskCount, 0);
      expect(repository.tasks.isEmpty, isTrue);
    });
  });
}
