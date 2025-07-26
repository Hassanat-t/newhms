import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Update student profile
  Future<void> updateStudentProfile({
    required String userId,
    required String username,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    try {
      await _firestore.collection('students').doc(userId).update({
        'username': username,
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // Get student profile data
  Future<Map<String, dynamic>?> getStudentProfile(String email) async {
    try {
      final studentDoc = await _firestore
          .collection('students')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (studentDoc.docs.isNotEmpty) {
        return studentDoc.docs.first.data();
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch profile: $e');
    }
  }

  // Sign out user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }
}