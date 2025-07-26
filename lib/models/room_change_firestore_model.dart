import 'package:cloud_firestore/cloud_firestore.dart';

class RoomChangeFirestoreModel {
  final String requestId;
  final String studentId;
  final String currentRoomId;
  final String currentBlock;
  final String currentRoomNumber;
  final String toChangeBlock;
  final String toChangeRoomNumber;
  final String changeReason;
  final String status;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  RoomChangeFirestoreModel({
    required this.requestId,
    required this.studentId,
    required this.currentRoomId,
    required this.currentBlock,
    required this.currentRoomNumber,
    required this.toChangeBlock,
    required this.toChangeRoomNumber,
    required this.changeReason,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RoomChangeFirestoreModel.fromMap(Map<String, dynamic> data, String documentId) {
    return RoomChangeFirestoreModel(
      requestId: documentId,
      studentId: data['studentId'] ?? '',
      currentRoomId: data['currentRoomId'] ?? '',
      currentBlock: data['currentBlock'] ?? '',
      currentRoomNumber: data['currentRoomNumber'] ?? '',
      toChangeBlock: data['toChangeBlock'] ?? '',
      toChangeRoomNumber: data['toChangeRoomNumber'] ?? '',
      changeReason: data['changeReason'] ?? '',
      status: data['status'] ?? 'pending',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'currentRoomId': currentRoomId,
      'currentBlock': currentBlock,
      'currentRoomNumber': currentRoomNumber,
      'toChangeBlock': toChangeBlock,
      'toChangeRoomNumber': toChangeRoomNumber,
      'changeReason': changeReason,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}