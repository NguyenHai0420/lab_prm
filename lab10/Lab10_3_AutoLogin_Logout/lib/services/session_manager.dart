import 'package:shared_preferences/shared_preferences.dart';
import '../models/session_user_model.dart';

class SessionManager {
  static const String keyToken = 'auth_token';
  static const String keyUser = 'user_data';
  static const String keyIsLoggedIn = 'is_logged_in';

  /// Saves user session details into SharedPreferences
  Future<void> saveSession(SessionUserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyToken, user.token);
    await prefs.setString(keyUser, user.serialize());
    await prefs.setBool(keyIsLoggedIn, true);
  }

  /// Retrieves the currently persisted user session, if any
  Future<SessionUserModel?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final rawUser = prefs.getString(keyUser);
    final token = prefs.getString(keyToken);

    if (token == null || token.isEmpty || rawUser == null) {
      return null;
    }

    return SessionUserModel.deserialize(rawUser);
  }

  /// Checks if a valid session exists
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(keyToken);
    final isLoggedIn = prefs.getBool(keyIsLoggedIn) ?? false;
    return isLoggedIn && token != null && token.isNotEmpty;
  }

  /// Clears the user session on logout
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyToken);
    await prefs.remove(keyUser);
    await prefs.setBool(keyIsLoggedIn, false);
  }
}
