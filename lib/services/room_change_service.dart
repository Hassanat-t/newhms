import 'package:cloud_firestore/cloud_firestore.dart';

class RoomChangeServiceTest {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all pending room change requests with embedded data (test mode)
  Stream<QuerySnapshot> getPendingRoomChangeRequestsTest() {
    try {
      return _firestore
          .collection('roomChangeRequests')
          .where('status', isEqualTo: 'pending')
          .orderBy('createdAt', descending: true)
          .snapshots();
    } catch (e) {
      throw Exception('Failed to fetch room change requests: $e');
    }
  }

  // Update room change request status
  Future<void> updateRoomChangeRequestStatus(String requestId, String status) async {
    try {
      await _firestore.collection('roomChangeRequests').doc(requestId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update room change request: $e');
    }
  }
}