import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/app_user.dart';

class ApiAuthService {
  static const String loginUrl = 'https://dummyjson.com/auth/login';

  Future<AppUser> login({
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
        return AppUser(
          id: data['id']?.toString() ?? '1',
          username: data['username'] as String? ?? username,
          email: data['email'] as String? ?? '',
          fullName: '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}'.trim(),
          photoUrl: data['image'] as String? ?? '',
          token: (data['accessToken'] ?? data['token']) as String? ?? '',
          authProvider: AuthProviderType.api,
          loginTime: DateTime.now(),
        );
      } else {
        final message = data['message'] ?? 'Authentication failed (${response.statusCode})';
        throw Exception(message);
      }
    } catch (e) {
      if (e.toString().contains('Exception:')) rethrow;
      throw Exception('Network error connecting to DummyJSON: $e');
    }
  }
}
