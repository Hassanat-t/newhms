import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseIssueService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Submit issue
  Future<void> submitIssue({
    required String roomNumber,
    required String blockNumber,
    required String issueType,
    required String studentComment,
    required String studentEmail,
    required String studentPhone,
    required String studentId,
  }) async {
    try {
      await _firestore.collection('issues').add({
        'roomId': '$blockNumber-$roomNumber', // Simple room ID
        'roomNumber': roomNumber,
        'block': blockNumber,
        'issue': issueType,
        'studentComment': studentComment,
        'studentId': studentId,
        'studentEmail': studentEmail,
        'studentPhone': studentPhone,
        'status': 'open',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        // Embedded student details for easier display (test mode)
        'studentFirstName': '', // Will be fetched or passed
        'studentLastName': '', // Will be fetched or passed
      });
    } catch (e) {
      throw Exception('Failed to submit issue: $e');
    }
  }

  // Get current student details
  Future<Map<String, dynamic>?> getCurrentStudentDetails() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final studentDoc = await _firestore
            .collection('students')
            .where('email', isEqualTo: user.email)
            .limit(1)
            .get();

        if (studentDoc.docs.isNotEmpty) {
          return studentDoc.docs.first.data();
        }
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch student details: $e');
    }
  }
}