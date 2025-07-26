import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class FirebaseFeeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get student fee details by email
  Future<Map<String, dynamic>?> getStudentFeeDetails(String email) async {
    try {
      // In test mode, we can fetch from a 'studentFees' collection
      // or embed fee data directly in the student document
      final studentDoc = await _firestore
          .collection('students')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (studentDoc.docs.isNotEmpty) {
        final studentData = studentDoc.docs.first.data();
        
        // Return fee data (either embedded or from a separate collection)
        return {
          'blockNumber': studentData['block'] ?? 'N/A',
          'roomNumber': studentData['roomNumber'] ?? 'N/A',
          'maintenanceCharge': studentData['maintenanceCharge']?.toString() ?? '0',
          'parkingCharge': studentData['parkingCharge']?.toString() ?? '0',
          'waterCharge': studentData['waterCharge']?.toString() ?? '0',
          'roomCharge': studentData['roomCharge']?.toString() ?? '0',
          'totalCharge': studentData['totalCharge']?.toString() ?? '0',
        };
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch student fee details: $e');
    }
  }

  // Alternative: Get fee details from a dedicated fees collection
  Future<Map<String, dynamic>?> getStudentFeeDetailsFromFeesCollection(String studentId) async {
    try {
      final feeDoc = await _firestore
          .collection('studentFees')
          .doc(studentId)
          .get();

      if (feeDoc.exists) {
        return feeDoc.data();
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch fee details: $e');
    }
  }
}