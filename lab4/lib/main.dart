import 'package:flutter/material.dart';

import 'ex1_core_widgets_demo.dart';
import 'ex2_Input_Controls_Demo.dart';
import 'ex3_layout_demo.dart';
import 'ex4_scaffold_demo.dart';
import 'ex5_common_ui.dart';

void main() {
  runApp(const Lab4App());
}

class Lab4App extends StatefulWidget {
  const Lab4App({super.key});

  @override
  State<Lab4App> createState() => _Lab4AppState();
}

class _Lab4AppState extends State<Lab4App> {
  // Theme hiện tại của ứng dụng
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Lab 4 - Flutter UI Fundamentals',

      // Chọn Light hoặc Dark Theme
      themeMode: _themeMode,

      // Light Theme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),

      // Dark Theme
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),

      home: HomeScreen(
        isDarkMode: _themeMode == ThemeMode.dark,
        onThemeChanged: (_) => _toggleTheme(),
      ),
    );
  }
}

// Màn hình chính của Lab
class HomeScreen extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Danh sách 5 Exercise
    final exercises = [
      (
        'Exercise 1 - Core Widgets Demo',
        Icons.widgets_outlined,
        const Ex1CoreWidgetsDemo(),
      ),
      ('Exercise 2 - Input Controls Demo', Icons.tune, const Ex2InputControlsDemo()),
      (
        'Exercise 3 - Layout Demo',
        Icons.dashboard_outlined,
        const Ex3LayoutDemo(),
      ),
      (
        'Exercise 4 - App Structure & Theme',
        Icons.phone_android,
        const Ex4ScaffoldDemo(),
      ),
      (
        'Exercise 5 - Common UI Fixes',
        Icons.build_outlined,
        const Ex5CommonUi(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 4 - Flutter UI Fundamentals'),

        // Dark Mode switch
        actions: [Switch(value: isDarkMode, onChanged: onThemeChanged)],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 12),

          // Hiển thị 5 Exercise
          ...exercises.map(
            (item) => Card(
              child: ListTile(
                title: Text(item.$1),
                trailing: const Icon(Icons.chevron_right),

                // Chuyển sang Exercise tương ứng
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => item.$3),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
