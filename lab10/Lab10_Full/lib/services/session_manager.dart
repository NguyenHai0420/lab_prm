import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_user.dart';

class SessionManager {
  static const String keyToken = 'lab10_full_token';
  static const String keyUser = 'lab10_full_user';
  static const String keyIsLoggedIn = 'lab10_full_logged_in';

  Future<void> saveSession(AppUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyToken, user.token);
    await prefs.setString(keyUser, user.serialize());
    await prefs.setBool(keyIsLoggedIn, true);
  }

  Future<AppUser?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(keyToken);
    final rawUser = prefs.getString(keyUser);

    if (token == null || token.isEmpty || rawUser == null) {
      return null;
    }
    return AppUser.deserialize(rawUser);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(keyToken);
    final isLogged = prefs.getBool(keyIsLoggedIn) ?? false;
    return isLogged && token != null && token.isNotEmpty;
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyToken);
    await prefs.remove(keyUser);
    await prefs.setBool(keyIsLoggedIn, false);
  }
}
