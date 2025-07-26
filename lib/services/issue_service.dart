import 'package:cloud_firestore/cloud_firestore.dart';

class IssueServiceTest {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all open issues with embedded student/room data (test mode)
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
}