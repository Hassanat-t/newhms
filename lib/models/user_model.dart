class UserModel {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String username;
  final String role;
  final bool isActive;
  final String? block;
  final String? room;
  final String? phoneNumber;

  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.role,
    required this.isActive,
    this.block,
    this.room,
    this.phoneNumber,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      username: map['username'] ?? '',
      role: map['role'] ?? '',
      isActive: map['isActive'] ?? true,
      block: map['block'],
      room: map['room'],
      phoneNumber: map['phoneNumber']
    );
  }
}
