import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Registers a new user with email and password.
  /// Returns the Firebase [User] if successful, otherwise null.
  Future<User?> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      debugPrint("AuthService Register Error [${e.code}]: ${e.message}");
      return null;
    } catch (e) {
      debugPrint("AuthService Register Unknown Error: $e");
      return null;
    }
  }

  /// Logs in an existing user with email and password.
  /// Returns the Firebase [User] if successful, otherwise null.
  Future<User?> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      debugPrint("AuthService Login Error [${e.code}]: ${e.message}");
      return null;
    } catch (e) {
      debugPrint("AuthService Login Unknown Error: $e");
      return null;
    }
  }

  /// Signs out the currently logged-in user.
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint("AuthService SignOut Error: $e");
    }
  }

  /// Returns the currently authenticated user, if any.
  User? get currentUser => _auth.currentUser;

  /// Checks whether a user is currently signed in.
  bool get isLoggedIn => _auth.currentUser != null;
}
