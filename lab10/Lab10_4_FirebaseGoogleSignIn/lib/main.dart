import 'package:flutter/material.dart';
import 'screens/google_login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GoogleSignInApp());
}

class GoogleSignInApp extends StatelessWidget {
  const GoogleSignInApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 10.4 - Firebase Google Sign-In',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1976D2), // Blue
          brightness: Brightness.light,
        ),
      ),
      home: const GoogleLoginScreen(),
    );
  }
}
