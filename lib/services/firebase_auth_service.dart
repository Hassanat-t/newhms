// lib/services/firebase_auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

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

  // Sign in user with email and password
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
    await _auth.signInWithEmailAndPassword(email: email, password: 'dummyPassword');
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      return false;
    } else {
      return true;
    }
  }
}


  // Get user role from Firestore
  Future<String?> getUserRole(String uid) async {
    try {
      // Check if user is admin first (using default admin credentials)
      User? currentUser = _auth.currentUser;
      if (currentUser != null && 
          currentUser.email == 'admin@hostel.com') {
        return 'admin';
      }

      // Check if user is staff
      DocumentSnapshot staffDoc = await _firestore.collection('staff').doc(uid).get();
      if (staffDoc.exists) {
        return 'staff';
      }

      // Check if user is student
      DocumentSnapshot studentDoc = await _firestore.collection('students').doc(uid).get();
      if (studentDoc.exists) {
        return 'student';
      }

      return 'student'; // Default to student if not found
    } catch (e) {
      debugPrint('Error getting user role: $e');
      return 'student'; // Default to student on error
    }
  }

  // Get user data from Firestore
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      // Check staff collection
      DocumentSnapshot staffDoc = await _firestore.collection('staff').doc(uid).get();
      if (staffDoc.exists) {
        return staffDoc.data() as Map<String, dynamic>;
      }

      // Check students collection
      DocumentSnapshot studentDoc = await _firestore.collection('students').doc(uid).get();
      if (studentDoc.exists) {
        return studentDoc.data() as Map<String, dynamic>;
      }

      return null;
    } catch (e) {
      debugPrint('Error getting user data: $e');
      return null;
    }
  }

  // Sign out user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }
}