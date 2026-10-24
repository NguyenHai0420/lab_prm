import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lab10_2_real_api_login/models/api_user_model.dart';
import 'package:lab10_2_real_api_login/services/dummy_json_auth_service.dart';

void main() {
  group('Lab 10.2 Real API Auth Service Tests', () {
    test('ApiUserModel parses valid DummyJSON response', () {
      final sampleJson = {
        'id': 1,
        'username': 'emilys',
        'email': 'emily.johnson@x.dummyjson.com',
        'firstName': 'Emily',
        'lastName': 'Johnson',
        'gender': 'female',
        'image': 'https://dummyjson.com/icon/emilys/128',
        'accessToken': 'dummy-jwt-access-token-12345',
        'refreshToken': 'dummy-jwt-refresh-token-67890',
      };

      final user = ApiUserModel.fromJson(sampleJson);
      expect(user.id, 1);
      expect(user.username, 'emilys');
      expect(user.fullName, 'Emily Johnson');
      expect(user.accessToken, 'dummy-jwt-access-token-12345');
    });

    test('Successful 200 HTTP response returns ApiUserModel', () async {
      final mockClient = MockClient((request) async {
        if (request.url.toString() == 'https://dummyjson.com/auth/login') {
          return http.Response(
            jsonEncode({
              'id': 15,
              'username': 'michaelw',
              'email': 'michael.williams@x.dummyjson.com',
              'firstName': 'Michael',
              'lastName': 'Williams',
              'gender': 'male',
              'image': 'https://dummyjson.com/icon/michaelw/128',
              'accessToken': 'valid_token_xyz',
              'refreshToken': 'refresh_token_xyz',
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response('Not Found', 404);
      });

      final authService = DummyJsonAuthService(client: mockClient);
      final user = await authService.login(
        username: 'michaelw',
        password: 'michaelwpassword',
      );

      expect(user.username, 'michaelw');
      expect(user.fullName, 'Michael Williams');
      expect(user.accessToken, 'valid_token_xyz');
    });

    test('400 HTTP response throws Exception with backend message', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({'message': 'Invalid credentials'}),
          400,
          headers: {'content-type': 'application/json'},
        );
      });

      final authService = DummyJsonAuthService(client: mockClient);
      expect(
        () async => await authService.login(
          username: 'wrong_user',
          password: 'wrong_password',
        ),
        throwsA(predicate((e) => e.toString().contains('Invalid credentials'))),
      );
    });
  });
}
