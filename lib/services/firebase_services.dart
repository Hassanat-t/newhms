import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //final FirebaseAuth _auth = FirebaseAuth.instance;

  // ISSUE SERVICES
  // Get all open issues stream (test mode - all data embedded)
  Stream<QuerySnapshot> getOpenIssuesTest() {
    try {
      return _firestore
          .collection('issues')
          .where('status', isEqualTo: 'open')
          .orderBy('createdAt', descending: true)
          .snapshots();
    } catch (e) {
      throw Exception('Failed to fetch issues: $e');
    }
  }

  // Update issue status
  Future<void> updateIssueStatus(String issueId, String status) async {
    try {
      await _firestore.collection('issues').doc(issueId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update issue: $e');
    }
  }

  // ROOM CHANGE REQUEST SERVICES
  // Get all pending room change requests stream (test mode)
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

  // STAFF SERVICES
  // Get all staff members stream (test mode)
  Stream<QuerySnapshot> getAllStaffTest() {
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
  Future<void> deleteStaffTest(String staffId) async {
    try {
      await _firestore.collection('staff').doc(staffId).delete();
    } catch (e) {
      throw Exception('Failed to delete staff: $e');
    }
  }
}