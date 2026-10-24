import 'package:flutter_test/flutter_test.dart';
import 'package:lab10_1_mock_login/models/user_model.dart';
import 'package:lab10_1_mock_login/services/mock_auth_service.dart';

void main() {
  group('Lab 10.1 Mock Auth Service Tests', () {
    final authService = MockAuthService();

    test('Valid credentials return UserModel with token', () async {
      final user = await authService.login(
        email: 'student@fpt.edu.vn',
        password: 'password123',
      );

      expect(user.email, 'student@fpt.edu.vn');
      expect(user.fullName, 'Nguyen Van A');
      expect(user.token.isNotEmpty, isTrue);
      expect(user.role, 'Student');
    });

    test('Invalid password throws Exception', () async {
      expect(
        () async => await authService.login(
          email: 'student@fpt.edu.vn',
          password: 'wrong_password',
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('Non-existing email throws Exception', () async {
      expect(
        () async => await authService.login(
          email: 'unknown@fpt.edu.vn',
          password: 'password123',
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('UserModel JSON serialization', () {
      final user = UserModel(
        email: 'test@fpt.edu.vn',
        fullName: 'Test User',
        token: 'token123',
        role: 'Admin',
      );

      final json = user.toJson();
      expect(json['email'], 'test@fpt.edu.vn');
      expect(json['role'], 'Admin');

      final reconstructed = UserModel.fromJson(json);
      expect(reconstructed.fullName, 'Test User');
    });
  });
}
