import 'dart:async';
import '../models/app_user.dart';

class GoogleAuthService {
  Future<AppUser> signInWithGoogle({bool isDemo = true}) async {
    await Future.delayed(const Duration(milliseconds: 900));

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return AppUser(
      id: 'google_$timestamp',
      username: 'hai.nguyen',
      email: 'hai.nguyen@fpt.edu.vn',
      fullName: 'Nguyen Hai (PRM393)',
      photoUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
      token: 'firebase_oauth_token_$timestamp',
      authProvider: AuthProviderType.google,
      loginTime: DateTime.now(),
    );
  }
}
