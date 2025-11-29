class User {
  final int id;
  final String roleId;
  final String role;
  final String firstName;
  final String? lastName;
  final String profileImageUrl;
  User({
    required this.id,
    required this.roleId,
    required this.role,
    required this.firstName,
    this.lastName,
    required this.profileImageUrl,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      roleId: json['role_id'] as String,
      role: json['role'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String?,
      profileImageUrl: json['profile_image_url'] as String,
    );
  }
}
