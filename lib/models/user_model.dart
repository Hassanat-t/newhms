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
      phoneNumber: map['phone'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'role': role,
      'isActive': isActive,
      'block': block,
      'room': room,
      'phone': phoneNumber,
    };
  }

  UserModel copyWith({
    String? email,
    String? firstName,
    String? lastName,
    String? username,
    String? role,
    bool? isActive,
    String? block,
    String? room,
    String? phoneNumber,
  }) {
    return UserModel(
      uid: uid,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      block: block ?? this.block,
      room: room ?? this.room,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
