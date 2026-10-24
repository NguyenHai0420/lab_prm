class UserModel {
  final String email;
  final String fullName;
  final String token;
  final String role;

  const UserModel({
    required this.email,
    required this.fullName,
    required this.token,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'fullName': fullName,
    'token': token,
    'role': role,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    email: json['email'] as String? ?? '',
    fullName: json['fullName'] as String? ?? '',
    token: json['token'] as String? ?? '',
    role: json['role'] as String? ?? 'Student',
  );
}
