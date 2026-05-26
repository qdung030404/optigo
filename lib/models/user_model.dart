enum UserRole { driver, passenger }

class UserModel {
  final String uid;
  final String userName;
  final String phoneNumber;
  final String? licensePlate;
  final UserRole? role;

  UserModel({
    required this.uid,
    required this.userName,
    required this.phoneNumber,
    this.role,
    this.licensePlate,
  });

  factory UserModel.formMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      userName: map['user_name'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      licensePlate: map['license_plate'] ?? '',
      role: map['role'] == 'driver'
          ? UserRole.driver
          : map['role'] == 'passenger'
          ? UserRole.passenger
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_name': userName,
      'phone_number': phoneNumber,
      'license_plate': licensePlate ?? '',
      'role': role?.name,
    };
  }
}
