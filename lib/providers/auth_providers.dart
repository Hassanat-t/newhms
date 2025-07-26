// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newhms/services/firebase_auth_service.dart'; // Make sure this path is correct

class AuthProvider extends ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  String? _role;
  Map<String, dynamic>? _userData;
  bool _isLoading = false;

  User? get user => _user;
  String? get role => _role;
  Map<String, dynamic>? get userData => _userData;
  bool get isLoading => _isLoading;

  bool get isAuthenticated => _user != null;
  bool get isStudent => _role == 'student';
  bool get isStaff => _role == 'staff';
  bool get isAdmin => _role == 'admin';

  // Login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userCredential = await _authService.signInUser(
        email: email,
        password: password,
      );

      if (userCredential?.user == null) {
        _isLoading = false;
        notifyListeners();
        return {'success': false, 'message': 'Failed to sign in'};
      }

      _user = userCredential!.user;

      // Get user role and data
      final userRole = await _authService.getUserRole(_user!.uid);
      final userData = await _authService.getUserData(_user!.uid);

      _role = userRole;
      _userData = userData;

      _isLoading = false;
      notifyListeners();

      return {
        'success': true,
        'user': _user,
        'role': _role,
        'userData': _userData
      };
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Login failed";
      switch (e.code) {
        case 'user-not-found':
          errorMessage = "No user found with this email";
          break;
        case 'wrong-password':
          errorMessage = "Incorrect password";
          break;
        case 'invalid-email':
          errorMessage = "Invalid email address";
          break;
        case 'user-disabled':
          errorMessage = "This account has been disabled";
          break;
        default:
          errorMessage = e.message ?? "An unknown error occurred";
      }

      _isLoading = false;
      notifyListeners();

      return {'success': false, 'message': errorMessage};
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return {
        'success': false,
        'message': e.toString().replaceAll('Exception:', '').trim()
      };
    }
  }

  // Register student
  Future<Map<String, dynamic>> registerStudent({
    required String email,
    required String password,
    required String name,
    required String studentId,
    required String roomNumber,
    required String phoneNumber,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // First check if email already exists
      bool emailExists = await _authService.checkEmailExists(email);
      if (emailExists) {
        _isLoading = false;
        notifyListeners();
        return {'success': false, 'message': 'Email already exists'};
      }

      // Register with Firebase Auth
      final userCredential = await _authService.registerUser(
        email: email,
        password: password,
      );

      if (userCredential?.user == null) {
        _isLoading = false;
        notifyListeners();
        return {'success': false, 'message': 'Failed to create user account'};
      }

      final uid = userCredential!.user!.uid;

      // Save student data to Firestore
      await _firestore.collection('students').doc(uid).set({
        'uid': uid,
        'email': email,
        'name': name,
        'studentId': studentId,
        'roomNumber': roomNumber,
        'phoneNumber': phoneNumber,
        'role': 'student',
        'createdAt': FieldValue.serverTimestamp(),
      });

      _isLoading = false;
      notifyListeners();

      return {'success': true, 'user': userCredential.user, 'role': 'student'};
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Registration failed";
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = "This email is already registered";
          break;
        case 'invalid-email':
          errorMessage = "Invalid email address";
          break;
        case 'weak-password':
          errorMessage = "Password is too weak";
          break;
        default:
          errorMessage = e.message ?? "An unknown error occurred";
      }

      _isLoading = false;
      notifyListeners();

      return {'success': false, 'message': errorMessage};
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return {
        'success': false,
        'message': e.toString().replaceAll('Exception:', '').trim()
      };
    }
  }

  // Register staff (admin only)
  Future<Map<String, dynamic>> registerStaff({
    required String email,
    required String password,
    required String name,
    required String staffId,
    required String position,
    required String phoneNumber,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // First check if email already exists
      bool emailExists = await _authService.checkEmailExists(email);
      if (emailExists) {
        _isLoading = false;
        notifyListeners();
        return {'success': false, 'message': 'Email already exists'};
      }

      // Register with Firebase Auth
      final userCredential = await _authService.registerUser(
        email: email,
        password: password,
      );

      if (userCredential?.user == null) {
        _isLoading = false;
        notifyListeners();
        return {'success': false, 'message': 'Failed to create user account'};
      }

      final uid = userCredential!.user!.uid;

      // Save staff data to Firestore
      await _firestore.collection('staff').doc(uid).set({
        'uid': uid,
        'email': email,
        'name': name,
        'staffId': staffId,
        'position': position,
        'phoneNumber': phoneNumber,
        'role': 'staff',
        'createdAt': FieldValue.serverTimestamp(),
      });

      _isLoading = false;
      notifyListeners();

      return {'success': true, 'user': userCredential.user, 'role': 'staff'};
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Registration failed";
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = "This email is already registered";
          break;
        case 'invalid-email':
          errorMessage = "Invalid email address";
          break;
        case 'weak-password':
          errorMessage = "Password is too weak";
          break;
        default:
          errorMessage = e.message ?? "An unknown error occurred";
      }

      _isLoading = false;
      notifyListeners();

      return {'success': false, 'message': errorMessage};
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return {
        'success': false,
        'message': e.toString().replaceAll('Exception:', '').trim()
      };
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _authService.signOut();
      _user = null;
      _role = null;
      _userData = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Logout error: $e'); // Okay for test mode
      // Still clear local state even if Firebase sign out fails
      _user = null;
      _role = null;
      _userData = null;
      notifyListeners();
    }
  }

  // Check if user is authenticated (for app startup)
  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = _auth.currentUser;

      if (_user != null) {
        // Get user role and data
        final userRole = await _authService.getUserRole(_user!.uid);
        final userData = await _authService.getUserData(_user!.uid);

        _role = userRole;
        _userData = userData;
      }
    } catch (e) {
      debugPrint('Error checking auth status: $e'); // Okay for test mode
      _user = null;
      _role = null;
      _userData = null;
    }

    _isLoading = false;
    notifyListeners();
  }
}
