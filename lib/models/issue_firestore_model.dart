import 'package:cloud_firestore/cloud_firestore.dart';

class IssueFirestoreModel {
  final String issueId;
  final String issue;
  final String studentComment;
  final String status;
  final String studentId;
  final String roomId;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  IssueFirestoreModel({
    required this.issueId,
    required this.issue,
    required this.studentComment,
    required this.status,
    required this.studentId,
    required this.roomId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory IssueFirestoreModel.fromMap(Map<String, dynamic> data, String documentId) {
    return IssueFirestoreModel(
      issueId: documentId,
      issue: data['issue'] ?? '',
      studentComment: data['studentComment'] ?? '',
      status: data['status'] ?? 'open',
      studentId: data['studentId'] ?? '',
      roomId: data['roomId'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'issue': issue,
      'studentComment': studentComment,
      'status': status,
      'studentId': studentId,
      'roomId': roomId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}