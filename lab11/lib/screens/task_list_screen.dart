import 'package:flutter/material.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  final TaskRepository repository;

  const TaskListScreen({
    super.key,
    required this.repository,
  });

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _taskInputController = TextEditingController();

  @override
  void dispose() {
    _taskInputController.dispose();
    super.dispose();
  }

  void _addTask() {
    final title = _taskInputController.text.trim();
    if (title.isEmpty) return;

    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
    );
    widget.repository.addTask(newTask);
    _taskInputController.clear();
  }

  void _navigateToDetail(Task task) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TaskDetailScreen(
          task: task,
          repository: widget.repository,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Taskly'),
        elevation: 2,
      ),
      body: ListenableBuilder(
        listenable: widget.repository,
        builder: (context, _) {
          final tasks = widget.repository.tasks;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        key: const Key('taskInputField'),
                        controller: _taskInputController,
                        decoration: const InputDecoration(
                          hintText: 'Enter task title...',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        onSubmitted: (_) => _addTask(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      key: const Key('addTaskButton'),
                      icon: const Icon(Icons.add),
                      onPressed: _addTask,
                      tooltip: 'Add Task',
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: tasks.isEmpty
                    ? const Center(
                        child: Text(
                          'No tasks yet. Add one!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return ListTile(
                            key: Key('taskItem_${task.id}'),
                            leading: Checkbox(
                              key: Key('taskCheckbox_${task.id}'),
                              value: task.completed,
                              onChanged: (_) {
                                widget.repository.toggleTask(task.id);
                              },
                            ),
                            title: Text(
                              task.title,
                              style: TextStyle(
                                decoration: task.completed
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: task.completed
                                    ? Colors.grey
                                    : Colors.black87,
                              ),
                            ),
                            subtitle: task.description != null &&
                                    task.description!.isNotEmpty
                                ? Text(task.description!)
                                : null,
                            trailing: IconButton(
                              key: Key('deleteTaskButton_${task.id}'),
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red),
                              onPressed: () {
                                widget.repository.deleteTask(task.id);
                              },
                            ),
                            onTap: () => _navigateToDetail(task),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
