// lib/services/firebase_auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register user with email and password
  Future<UserCredential?> registerUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // NEW: Sign in user with email and password (This was missing or named differently)
  Future<UserCredential?> signInUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }


  // Check if email already exists
  Future<bool> checkEmailExists(String email) async {
    try {
      final result = await _auth.fetchSignInMethodsForEmail(email);
      return result.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // NEW: Get user role from Firestore (This was missing or named differently)
  Future<String?> getUserRole(String uid) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('staff').doc(uid).get(); // Or 'students' depending on your structure
      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        // Assuming the role is stored as a string like 'admin', 'staff', 'student'
        // Or as an ID like 1, 2, 3. Adjust based on your data structure.
        return data['roleId']?.toString() ?? '3'; // Default to student role '3' or 'student'
      }
      // If not found in 'staff', check 'students' collection
      DocumentSnapshot studentDoc = await _firestore.collection('students').doc(uid).get();
      if (studentDoc.exists) {
        Map<String, dynamic> data = studentDoc.data() as Map<String, dynamic>;
        return data['roleId']?.toString() ?? '2'; // Default to student role '2'
      }
      return '3'; // Default role if not found
    } catch (e) {
      print('Error getting user role: $e');
      return '3'; // Default role on error
    }
  }

  // Optional: Sign out user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }
}
