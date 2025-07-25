import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  static Future<void> saveStaffData({
    required String uid,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String jobRole,
    required String roomNumber,
    required String block,
  }) async {
    await FirebaseFirestore.instance.collection('staff').doc(uid).set({
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'jobRole': jobRole,
      'roomNumber': roomNumber,
      'block': block,
      'createdAt': Timestamp.now(),
    });
  }
}
