import 'package:flutter/foundation.dart';
import '../models/task.dart';

class TaskRepository extends ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);

  int get taskCount => _tasks.length;

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  bool deleteTask(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks.removeAt(index);
      notifyListeners();
      return true;
    }
    return false;
  }

  bool updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
      return true;
    }
    return false;
  }

  Task? getTaskById(String id) {
    final matches = _tasks.where((t) => t.id == id);
    return matches.isNotEmpty ? matches.first : null;
  }

  void toggleTask(String id) {
    final task = getTaskById(id);
    if (task != null) {
      task.toggle();
      notifyListeners();
    }
  }

  void clear() {
    _tasks.clear();
    notifyListeners();
  }
}
