import 'package:flutter_test/flutter_test.dart';
import 'package:lab10_4_firebase_google_sign_in/models/google_user_model.dart';
import 'package:lab10_4_firebase_google_sign_in/services/google_auth_service.dart';

void main() {
  group('Lab 10.4 Firebase Google Sign-In Tests', () {
    test('GoogleUserModel serialization and deserialization', () {
      final user = GoogleUserModel(
        uid: 'user_123',
        displayName: 'John Doe',
        email: 'john@gmail.com',
        photoUrl: 'https://example.com/photo.jpg',
        providerId: 'google.com',
        isEmailVerified: true,
      );

      final json = user.toJson();
      expect(json['uid'], 'user_123');
      expect(json['displayName'], 'John Doe');
      expect(json['email'], 'john@gmail.com');

      final reconstructed = GoogleUserModel.fromJson(json);
      expect(reconstructed.uid, 'user_123');
      expect(reconstructed.displayName, 'John Doe');
      expect(reconstructed.isEmailVerified, isTrue);
    });

    test('GoogleAuthService signInWithGoogle returns user and updates state', () async {
      final authService = GoogleAuthService();
      expect(authService.isAuthenticated, isFalse);

      final user = await authService.signInWithGoogle(useTestAccount: true);
      expect(authService.isAuthenticated, isTrue);
      expect(user.displayName, 'Google Test Student');
      expect(user.email, 'student.fpt@gmail.com');

      await authService.signOut();
      expect(authService.isAuthenticated, isFalse);
      expect(authService.currentUser, isNull);
    });
  });
}
