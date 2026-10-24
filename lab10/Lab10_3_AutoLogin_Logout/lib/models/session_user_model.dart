import 'dart:convert';

class SessionUserModel {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String image;
  final String token;
  final DateTime loginTime;

  const SessionUserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.image,
    required this.token,
    required this.loginTime,
  });

  String get fullName => '$firstName $lastName';

  factory SessionUserModel.fromJson(Map<String, dynamic> json) {
    return SessionUserModel(
      id: json['id'] as int? ?? 0,
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      image: json['image'] as String? ?? '',
      token: (json['accessToken'] ?? json['token']) as String? ?? '',
      loginTime: json['loginTime'] != null
          ? DateTime.tryParse(json['loginTime'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'firstName': firstName,
    'lastName': lastName,
    'image': image,
    'token': token,
    'loginTime': loginTime.toIso8601String(),
  };

  String serialize() => jsonEncode(toJson());

  static SessionUserModel? deserialize(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return SessionUserModel.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }
}
