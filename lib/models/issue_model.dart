import 'package:cloud_firestore/cloud_firestore.dart';

class IssueModel {
  final String id;
  final String uid;
  final String studentEmail;
  final String issueType;
  final String comment;
  final String roomNumber;
  final String block;
  final String contactNumber;
  final DateTime timestamp;

  IssueModel({
    required this.id,
    required this.uid,
    required this.studentEmail,
    required this.issueType,
    required this.comment,
    required this.roomNumber,
    required this.block,
    required this.contactNumber,
    required this.timestamp,
  });

  factory IssueModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return IssueModel(
      id: doc.id,
      uid: data['uid'] ?? '',
      studentEmail: data['studentEmail'] ?? '',
      issueType: data['issueType'] ?? '',
      comment: data['comment'] ?? '',
      roomNumber: data['roomNumber'] ?? '',
      block: data['block'] ?? '',
      contactNumber: data['contactNumber'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
