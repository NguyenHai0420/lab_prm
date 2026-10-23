class StudentRecord {
  final int id;
  final String studentId;
  final String fullName;
  final String email;
  final String major;
  final double gpa;

  StudentRecord({
    required this.id,
    required this.studentId,
    required this.fullName,
    required this.email,
    required this.major,
    required this.gpa,
  });

  factory StudentRecord.fromJson(Map<String, dynamic> json) {
    return StudentRecord(
      id: json['id'] as int? ?? 0,
      studentId: json['studentId'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      major: json['major'] as String? ?? 'Software Engineering',
      gpa: (json['gpa'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'fullName': fullName,
      'email': email,
      'major': major,
      'gpa': gpa,
    };
  }

  StudentRecord copyWith({
    int? id,
    String? studentId,
    String? fullName,
    String? email,
    String? major,
    double? gpa,
  }) {
    return StudentRecord(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      major: major ?? this.major,
      gpa: gpa ?? this.gpa,
    );
  }
}
