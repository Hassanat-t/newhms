import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newhms/features/auth/screens/login_screen.dart';
import 'package:newhms/features/home/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<String?> _getUserRole(String uid) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (doc.exists && doc.data() != null) {
        return doc.get('role') as String?;
      }
    } catch (e) {
      debugPrint("Error fetching role: $e");
    }
    return null;
  }

  @override
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (!snapshot.hasData) {
          return const LoginScreen(); // Not logged in
        }

        // Logged in – now load user from Firestore into Provider
        return FutureBuilder(
          future: Provider.of<UserProvider>(context, listen: false).loadUser(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            // Still return login if somehow user data wasn't set
            final userProvider = Provider.of<UserProvider>(context, listen: false);
            if (userProvider.user == null) {
              FirebaseAuth.instance.signOut(); // Optional: clean up session
              return const LoginScreen();
            }

            // Now fully authenticated and user model is loaded
            return const HomeScreen();
          },
        );
      },
    );
  }
}
