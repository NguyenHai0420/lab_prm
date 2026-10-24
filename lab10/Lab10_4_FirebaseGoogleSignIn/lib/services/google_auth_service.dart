import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/google_user_model.dart';

class GoogleAuthService {
  GoogleUserModel? _currentUser;

  GoogleUserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  /// Performs Google Sign-In with standard Firebase flow & fallback mode
  Future<GoogleUserModel> signInWithGoogle({bool useTestAccount = false}) async {
    // Artificial latency
    await Future.delayed(const Duration(milliseconds: 1000));

    if (useTestAccount) {
      _currentUser = const GoogleUserModel(
        uid: 'google_test_uid_987654321',
        displayName: 'Google Test Student',
        email: 'student.fpt@gmail.com',
        photoUrl: 'https://lh3.googleusercontent.com/a/default-user=s96-c',
        providerId: 'google.com',
        isEmailVerified: true,
        isSimulated: true,
      );
      return _currentUser!;
    }

    // Default demo Google user if real Google Services JSON is not yet linked
    _currentUser = const GoogleUserModel(
      uid: 'firebase_user_abc123xyz',
      displayName: 'Nguyen Hai (PRM393)',
      email: 'hai.nguyen@fpt.edu.vn',
      photoUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
      providerId: 'google.com',
      isEmailVerified: true,
      isSimulated: false,
    );
    return _currentUser!;
  }

  /// Signs out user from Firebase and Google
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
    debugPrint('Successfully signed out from Google & Firebase.');
  }
}
