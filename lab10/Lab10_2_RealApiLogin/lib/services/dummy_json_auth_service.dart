import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_user_model.dart';

class DummyJsonAuthService {
  static const String loginUrl = 'https://dummyjson.com/auth/login';

  final http.Client _client;

  DummyJsonAuthService({http.Client? client}) : _client = client ?? http.Client();

  /// Authenticates user against DummyJSON REST API endpoint
  Future<ApiUserModel> login({
    required String username,
    required String password,
    int expiresInMins = 30,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse(loginUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'username': username.trim(),
          'password': password.trim(),
          'expiresInMins': expiresInMins,
        }),
      ).timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ApiUserModel.fromJson(data as Map<String, dynamic>);
      } else {
        final message = data['message'] ?? 'Authentication failed (${response.statusCode})';
        throw Exception(message);
      }
    } on http.ClientException catch (e) {
      throw Exception('Network connection error: $e');
    } catch (e) {
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
