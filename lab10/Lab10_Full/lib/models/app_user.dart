import 'dart:convert';

enum AuthProviderType { api, google }

class AppUser {
  final String id;
  final String username;
  final String email;
  final String fullName;
  final String photoUrl;
  final String token;
  final AuthProviderType authProvider;
  final DateTime loginTime;

  const AppUser({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    required this.photoUrl,
    required this.token,
    required this.authProvider,
    required this.loginTime,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'fullName': fullName,
    'photoUrl': photoUrl,
    'token': token,
    'authProvider': authProvider.name,
    'loginTime': loginTime.toIso8601String(),
  };

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id']?.toString() ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      photoUrl: json['photoUrl'] as String? ?? '',
      token: (json['accessToken'] ?? json['token']) as String? ?? '',
      authProvider: json['authProvider'] == 'google'
          ? AuthProviderType.google
          : AuthProviderType.api,
      loginTime: json['loginTime'] != null
          ? DateTime.tryParse(json['loginTime'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  String serialize() => jsonEncode(toJson());

  static AppUser? deserialize(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return AppUser.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }
}
