import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lab10_3_auto_login_logout/models/session_user_model.dart';
import 'package:lab10_3_auto_login_logout/services/session_manager.dart';

void main() {
  group('Lab 10.3 Session Manager & Auto-Login Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('Initial state: isLoggedIn is false and getSession returns null', () async {
      final manager = SessionManager();
      expect(await manager.isLoggedIn(), isFalse);
      expect(await manager.getSession(), isNull);
    });

    test('Saving session persists user and isLoggedIn becomes true', () async {
      final manager = SessionManager();
      final user = SessionUserModel(
        id: 1,
        username: 'emilys',
        email: 'emilys@dummyjson.com',
        firstName: 'Emily',
        lastName: 'Johnson',
        image: 'https://example.com/emily.png',
        token: 'persisted_jwt_token_123',
        loginTime: DateTime.now(),
      );

      await manager.saveSession(user);

      expect(await manager.isLoggedIn(), isTrue);

      final retrieved = await manager.getSession();
      expect(retrieved, isNotNull);
      expect(retrieved!.username, 'emilys');
      expect(retrieved.fullName, 'Emily Johnson');
      expect(retrieved.token, 'persisted_jwt_token_123');
    });

    test('Clearing session resets isLoggedIn to false and removes session data', () async {
      final manager = SessionManager();
      final user = SessionUserModel(
        id: 2,
        username: 'michaelw',
        email: 'michaelw@dummyjson.com',
        firstName: 'Michael',
        lastName: 'Williams',
        image: '',
        token: 'token_xyz',
        loginTime: DateTime.now(),
      );

      await manager.saveSession(user);
      expect(await manager.isLoggedIn(), isTrue);

      await manager.clearSession();
      expect(await manager.isLoggedIn(), isFalse);
      expect(await manager.getSession(), isNull);
    });
  });
}
