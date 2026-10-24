import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lab10_full/models/app_user.dart';
import 'package:lab10_full/services/session_manager.dart';
import 'package:lab10_full/services/notification_service.dart';

void main() {
  group('Lab 10 Full Integrated Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('AppUser model handles serialization and deserialization', () {
      final user = AppUser(
        id: '1',
        username: 'emilys',
        email: 'emilys@dummyjson.com',
        fullName: 'Emily Johnson',
        photoUrl: 'https://dummyjson.com/icon/emilys/128',
        token: 'token_123',
        authProvider: AuthProviderType.api,
        loginTime: DateTime.now(),
      );

      final json = user.toJson();
      expect(json['username'], 'emilys');
      expect(json['authProvider'], 'api');

      final reconstructed = AppUser.fromJson(json);
      expect(reconstructed.fullName, 'Emily Johnson');
      expect(reconstructed.authProvider, AuthProviderType.api);
    });

    test('SessionManager persists AppUser across auto-login check', () async {
      final manager = SessionManager();
      expect(await manager.isLoggedIn(), isFalse);

      final user = AppUser(
        id: '2',
        username: 'michaelw',
        email: 'michaelw@dummyjson.com',
        fullName: 'Michael Williams',
        photoUrl: '',
        token: 'token_abc',
        authProvider: AuthProviderType.google,
        loginTime: DateTime.now(),
      );

      await manager.saveSession(user);
      expect(await manager.isLoggedIn(), isTrue);

      final retrieved = await manager.getSession();
      expect(retrieved, isNotNull);
      expect(retrieved!.username, 'michaelw');
      expect(retrieved.authProvider, AuthProviderType.google);

      await manager.clearSession();
      expect(await manager.isLoggedIn(), isFalse);
    });

    test('NotificationService singleton configuration check', () {
      expect(NotificationService(), isNotNull);
      expect(NotificationService.channelId, 'lab10_full_channel');
      expect(NotificationService.channelName, 'Lab 10 Full Notifications');
    });
  });
}
