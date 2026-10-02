import 'package:flutter/material.dart';
import 'package:lab5/home_screen.dart';

void main() {
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Detail App',

      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF101010),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF101010),
          elevation: 0,
        ),

        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          brightness: Brightness.dark,
        ),
      ),

      home: const HomeScreen(),
    );
  }
}