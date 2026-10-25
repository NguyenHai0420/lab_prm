import 'package:flutter/material.dart';
import 'repositories/task_repository.dart';
import 'screens/task_list_screen.dart';

void main() {
  runApp(const TasklyApp());
}

class TasklyApp extends StatefulWidget {
  final TaskRepository? repository;

  const TasklyApp({super.key, this.repository});

  @override
  State<TasklyApp> createState() => _TasklyAppState();
}

class _TasklyAppState extends State<TasklyApp> {
  late final TaskRepository _repository;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? TaskRepository();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskly',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: TaskListScreen(repository: _repository),
    );
  }
}
