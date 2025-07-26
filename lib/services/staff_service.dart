import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StaffService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get all staff members stream
  Stream<QuerySnapshot> getAllStaff() {
    try {
      return _firestore
          .collection('staff')
          .orderBy('createdAt', descending: true)
          .snapshots();
    } catch (e) {
      throw Exception('Failed to fetch staff: $e');
    }
  }

  // Delete staff member
  Future<void> deleteStaff(String emailId) async {
    try {
      // First, find the staff document by email
      final staffQuery = await _firestore
          .collection('staff')
          .where('email', isEqualTo: emailId)
          .limit(1)
          .get();

      if (staffQuery.docs.isNotEmpty) {
        final staffDoc = staffQuery.docs.first;
        final staffUid = staffDoc.id;

        // Delete from Firestore
        await _firestore.collection('staff').doc(staffUid).delete();

        // Delete from Firebase Auth
        final authUser = _auth.currentUser;
        if (authUser != null) {
          // Note: You might need admin privileges to delete other users
          // This is a simplified version - in production, you'd need cloud functions
          // or admin SDK for full user deletion
          // For now, we'll just delete from Firestore
        }
      }
    } catch (e) {
      throw Exception('Failed to delete staff: $e');
    }
  }
}