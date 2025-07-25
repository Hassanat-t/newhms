// lib/services/user_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register a user with email & password, and store additional details in Firestore
  Future<User?> registerUser({
    required String email,
    required String password,
    required String fullName,
    Map<String, dynamic>? additionalData, // Optional extra fields
  }) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = cred.user;

      if (user != null) {
        final data = {
          'uid': user.uid,
          'email': email,
          'fullName': fullName,
          'role': 'student', // default role
          'createdAt': FieldValue.serverTimestamp(),
          ...?additionalData, // Merge if exists
        };

        await _firestore.collection('users').doc(user.uid).set(data);
        return user;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.code}');
      return null;
    } catch (e) {
      print('Registration Error: $e');
      return null;
    }
  }

  // Login a user
  Future<Map<String, dynamic>?> loginUserWithRole({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = cred.user;

      if (user != null) {
        // Try to get user from 'users' collection
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          return {'role': 'student', ...userDoc.data() as Map<String, dynamic>};
        }

        // Try to get user from 'staff' collection
        DocumentSnapshot staffDoc =
            await _firestore.collection('staff').doc(user.uid).get();
        if (staffDoc.exists) {
          return {'role': 'staff', ...staffDoc.data() as Map<String, dynamic>};
        }

        // If user exists in Auth but not in either collection
        print('User profile not found in users or staff collection.');
        return null;
      }
    } on FirebaseAuthException catch (e) {
      print('Login Error: ${e.code}');
    } catch (e) {
      print('Login Exception: $e');
    }
    return null;
  }

  // Sign out user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Get user data from Firestore
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print('Fetch User Data Error: $e');
    }
    return null;
  }

  // Get current logged-in user's data
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      return await getUserData(user.uid);
    }
    return null;
  }
  // lib/services/user_service.dart

  Future<User?> registerStaff({
    required String email,
    required String password,
    required String userName,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String jobRole,
  }) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = cred.user;

      if (user != null) {
        await _firestore.collection('staff').doc(user.uid).set({
          'uid': user.uid,
          'userName': userName,
          'email': email,
          'firstName': firstName,
          'lastName': lastName,
          'phoneNumber': phoneNumber,
          'jobRole': jobRole,
          'role': 'staff',
          'createdAt': FieldValue.serverTimestamp(),
        });
        return user;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.code}');
      return null;
    } catch (e) {
      print('Staff Registration Error: $e');
      return null;
    }
  }
// Add this to your UserService class

  Future<void> deleteStaff(String staffId) async {
    try {
      await FirebaseFirestore.instance
          .collection('staff')
          .doc(staffId)
          .delete();
      print('Staff deleted: $staffId');
    } catch (e) {
      print('Error deleting staff: $e');
    }
  }
}
