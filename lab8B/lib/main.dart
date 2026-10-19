import 'package:flutter/material.dart';
import 'screens/weather_home_screen.dart';

void main() {
  runApp(const WeatherCompanionApp());
}

class WeatherCompanionApp extends StatelessWidget {
  const WeatherCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Companion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF1F5F9),
      ),
      home: const WeatherHomeScreen(),
    );
  }
}
