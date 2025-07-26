import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseRoomAvailabilityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all room availability data
  Stream<QuerySnapshot> getRoomAvailabilityStream() {
    try {
      return _firestore
          .collection('rooms')
          .orderBy('block')
          .orderBy('roomNumber')
          .snapshots();
    } catch (e) {
      throw Exception('Failed to fetch room availability: $e');
    }
  }

  // Get room details by ID
  Future<DocumentSnapshot> getRoomById(String roomId) async {
    try {
      return await _firestore.collection('rooms').doc(roomId).get();
    } catch (e) {
      throw Exception('Failed to fetch room details: $e');
    }
  }
}