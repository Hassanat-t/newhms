import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save student data to Firestore
  Future<void> saveStudentData({
    required String uid,
    required String username,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String block,
    required String roomNumber,
  }) async {
    try {
      await _firestore.collection('students').doc(uid).set({
        'uid': uid,
        'username': username,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'block': block,
        'roomNumber': roomNumber,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isActive': true,
        'roleId': 2, // Assuming 2 is for student role
      });
    } catch (e) {
      throw Exception('Failed to save student data: $e');
    }
  }

  Future<void> saveStaffData({
    required String uid,
    required String username,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String jobRole,
  }) async {
    try {
      await _firestore.collection('staff').doc(uid).set({
        'uid': uid,
        'username': username,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'jobRole': jobRole,
        // --- Add Role ID ---
        // It's crucial to assign a role ID to staff members.
        // Assuming 3 is the ID for 'Staff' role. Adjust if yours is different.
        'roleId': 3, // <-- Add this line
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isActive': true,
      });
    } catch (e) {
      // Improve error message
      throw Exception('Failed to save staff data to Firestore: $e');
    }
  }

  // Get staff by UID
  Future<DocumentSnapshot> getStaffByUid(String uid) async {
    try {
      return await _firestore.collection('staff').doc(uid).get();
    } catch (e) {
      throw Exception('Failed to fetch staff data: $e');
    }
  }

  // Get all staff members
  Stream<QuerySnapshot> getAllStaff() {
    try {
      return _firestore.collection('staff').snapshots();
    } catch (e) {
      throw Exception('Failed to fetch staff list: $e');
    }
  }
}
