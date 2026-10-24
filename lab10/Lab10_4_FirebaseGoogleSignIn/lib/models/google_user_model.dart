class GoogleUserModel {
  final String uid;
  final String displayName;
  final String email;
  final String photoUrl;
  final String providerId;
  final bool isEmailVerified;
  final bool isSimulated;

  const GoogleUserModel({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.photoUrl,
    required this.providerId,
    this.isEmailVerified = true,
    this.isSimulated = false,
  });

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'displayName': displayName,
    'email': email,
    'photoUrl': photoUrl,
    'providerId': providerId,
    'isEmailVerified': isEmailVerified,
    'isSimulated': isSimulated,
  };

  factory GoogleUserModel.fromJson(Map<String, dynamic> json) => GoogleUserModel(
    uid: json['uid'] as String? ?? '',
    displayName: json['displayName'] as String? ?? '',
    email: json['email'] as String? ?? '',
    photoUrl: json['photoUrl'] as String? ?? '',
    providerId: json['providerId'] as String? ?? 'google.com',
    isEmailVerified: json['isEmailVerified'] as bool? ?? true,
    isSimulated: json['isSimulated'] as bool? ?? false,
  );
}
