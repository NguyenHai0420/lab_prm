import 'dart:async';
import '../models/user_model.dart';

class MockAuthService {
  static final Map<String, Map<String, String>> _mockDatabase = {
    'admin@fpt.edu.vn': {
      'password': 'password123',
      'fullName': 'System Administrator',
      'role': 'Admin',
    },
    'student@fpt.edu.vn': {
      'password': 'password123',
      'fullName': 'Nguyen Van A',
      'role': 'Student',
    },
    'teacher@fpt.edu.vn': {
      'password': 'password123',
      'fullName': 'Dr. Le Van C',
      'role': 'Lecturer',
    },
  };

  Future<UserModel> login({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 1200));

    final normalizedEmail = email.trim().toLowerCase();
    final userRecord = _mockDatabase[normalizedEmail];

    if (userRecord == null || userRecord['password'] != password) {
      throw Exception('Invalid email or password. Please verify your credentials.');
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final mockToken = 'mock_jwt_token_${normalizedEmail}_$timestamp';

    return UserModel(
      email: normalizedEmail,
      fullName: userRecord['fullName']!,
      token: mockToken,
      role: userRecord['role']!,
    );
  }
}
