import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/session_user_model.dart';

class AuthService {
  static const String loginUrl = 'https://dummyjson.com/auth/login';

  Future<SessionUserModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'username': username.trim(),
          'password': password.trim(),
          'expiresInMins': 60,
        }),
      ).timeout(const Duration(seconds: 12));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> map = Map<String, dynamic>.from(data as Map);
        map['loginTime'] = DateTime.now().toIso8601String();
        return SessionUserModel.fromJson(map);
      } else {
        final msg = data['message'] ?? 'Authentication failed (${response.statusCode})';
        throw Exception(msg);
      }
    } catch (e) {
      if (e.toString().contains('Exception:')) rethrow;
      throw Exception('Network or server error: $e');
    }
  }
}
