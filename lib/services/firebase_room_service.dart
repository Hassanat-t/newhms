import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class FirebaseRoomService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //final FirebaseAuth _auth = FirebaseAuth.instance;

  // Submit room change request
  Future<void> submitRoomChangeRequest({
    required String currentRoomNumber,
    required String currentBlock,
    required String toChangeRoomNumber,
    required String toChangeBlock,
    required String changeReason,
    required String studentId,
    required String studentEmail,
  }) async {
    try {
      await _firestore.collection('roomChangeRequests').add({
        'studentId': studentId,
        'studentEmail': studentEmail,
        'currentRoomNumber': currentRoomNumber,
        'currentBlock': currentBlock,
        'toChangeRoomNumber': toChangeRoomNumber,
        'toChangeBlock': toChangeBlock,
        'changeReason': changeReason,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to submit room change request: $e');
    }
  }
}