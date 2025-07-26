import 'package:firebase_auth/firebase_auth.dart';
import 'package:newhms/services/firebase_auth_service.dart';
import 'package:newhms/services/firestore_service.dart';

class StaffService {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirestoreService _firestoreService = FirestoreService();

  Future<void> createStaff({
    required String username,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNumber,
    required String jobRole,
  }) async {
    try {
      // Check if email already exists
      bool emailExists = await _authService.checkEmailExists(email);
      if (emailExists) {
        throw Exception('Email already exists');
      }

      // Register user with Firebase Auth
      final userCredential = await _authService.registerUser(
        email: email,
        password: password,
      );

      if (userCredential?.user == null) {
        throw Exception('Failed to create user account');
      }

      final uid = userCredential!.user!.uid;

      // Save staff data to Firestore
      await _firestoreService.saveStaffData(
        uid: uid,
        username: username,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
        jobRole: jobRole,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception('Authentication error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}