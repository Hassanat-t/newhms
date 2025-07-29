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
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      username: map['username'] ?? '',
      role: map['role'] ?? '',
      isActive: map['isActive'] ?? '',
      block: map['block'],
      room: map['room'],
    );
  }
}
