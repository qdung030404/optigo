class UserModel {
  final String id;
  final String userName;
  final String phoneNumber;
  final String? avatarUrl;

  UserModel({
    required this.id,
    required this.userName,
    required this.phoneNumber,
    this.avatarUrl,
  });

  // Example factory for Supabase or other services
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      userName: json['username'] as String? ?? 'User',
      phoneNumber: json['phone'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String?,
    );
  }
}
