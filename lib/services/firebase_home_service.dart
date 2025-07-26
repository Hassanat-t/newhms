import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class FirebaseHomeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get student details by email
  Future<DocumentSnapshot?> getStudentDetailsByEmail(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection('students')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first;
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch student details: $e');
    }
  }

  // Get pie chart data (simplified for test mode)
  Future<Map<String, dynamic>> getPieChartData() async {
    try {
      // In test mode, we'll return mock data or fetch from a settings document
      final settingsDoc = await _firestore.collection('settings').doc('chartData').get();
      
      if (settingsDoc.exists) {
        return settingsDoc.data() as Map<String, dynamic>;
      } else {
        // Return default mock data
        return {
          'totalRoomChangeRequestsApproved': 15,
          'totalRoomChangeRequestsRejected': 5,
          'totalNumberRoomChangeRequest': 25,
        };
      }
    } catch (e) {
      // Return default mock data on error
      return {
        'totalRoomChangeRequestsApproved': 15,
        'totalRoomChangeRequestsRejected': 5,
        'totalNumberRoomChangeRequest': 25,
      };
    }
  }
}