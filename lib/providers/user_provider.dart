// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../models/user_model.dart';
//
// class UserProvider with ChangeNotifier {
//   UserModel? _user;
//
//   UserModel? get user => _user;
//
//   Future<void> loadUser() async {
//     User? firebaseUser = FirebaseAuth.instance.currentUser;
//     if (firebaseUser != null) {
//       DocumentSnapshot doc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(firebaseUser.uid)
//           .get();
//       _user = UserModel.fromMap(doc.data() as Map<String, dynamic>, firebaseUser.uid);
//       notifyListeners();
//     }
//   }
//
//
//   void setUser(UserModel userModel) {
//     _user = userModel;
//     notifyListeners();
//   }
//
//   void clearUser() {
//     _user = null;
//     notifyListeners();
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  // Load current user's data from Firestore
  Future<void> loadUser() async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      _user = UserModel.fromMap(doc.data() as Map<String, dynamic>, firebaseUser.uid);
      notifyListeners();
    }
  }

  // Set user manually
  void setUser(UserModel userModel) {
    _user = userModel;
    notifyListeners();
  }

  // Clear user data (e.g. on logout)
  void clearUser() {
    _user = null;
    notifyListeners();
  }

  // Update user profile data in Firestore
  Future<void> updateUserProfile({
    required String username,
    required String phone,
    required String firstName,
    required String lastName,
  }) async {
    if (_user == null) return;

    try {
      final docRef = FirebaseFirestore.instance.collection('users').doc(_user!.uid);

      await docRef.update({
        'username': username,
        'phone': phone,
        'firstName': firstName,
        'lastName': lastName,
      });

      // Update local model
      _user = _user!.copyWith(
        username: username,
        phoneNumber: phone,
        firstName: firstName,
        lastName: lastName,
      );

      notifyListeners();
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // Logout user from Firebase and clear local data
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    clearUser();

    // Optionally: navigate to login screen
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}

