class UserProfile {
  final String id;
  final String fullName;
  final String username;
  final String email;
  final String avatar;
  final DateTime? birthDate;
  final String? gender;
  final String? maritalStatus;
  final String? livingStatus;
  final String? educationLevel;
  final String? employmentStatus;

  const UserProfile({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.avatar,
    this.birthDate,
    this.gender,
    this.maritalStatus,
    this.livingStatus,
    this.educationLevel,
    this.employmentStatus,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      avatar: json['avatar']?.toString() ?? '',
      birthDate: json['birth_date'] != null
          ? DateTime.tryParse(json['birth_date'].toString())
          : null,
      gender: json['gender']?.toString(),
      maritalStatus: json['marital_status']?.toString(),
      livingStatus: json['living_status']?.toString(),
      educationLevel: json['education_level']?.toString(),
      employmentStatus: json['employment_status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'username': username,
      'email': email,
      'avatar': avatar,
      'birth_date': birthDate?.toIso8601String(),
      'gender': gender,
      'marital_status': maritalStatus,
      'living_status': livingStatus,
      'education_level': educationLevel,
      'employment_status': employmentStatus,
    };
  }
}