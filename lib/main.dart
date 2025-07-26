// lib/main.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth; // Keep alias if preferred
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newhms/features/auth/screens/login_screen.dart';
import 'package:newhms/features/home/home_screen.dart';
import 'package:newhms/firebase_options.dart';
import 'package:newhms/providers/auth_providers.dart';
import 'package:provider/provider.dart';
// ✅ Correct the import path to match the filename (singular 'provider')
//import 'package:newhms/providers/auth_provider.dart'; // Make sure this file exists

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Create default admin account (optional, for testing)
  _createDefaultAdminAccount();

  runApp(
    // ✅ Specify the type for clarity
    ChangeNotifierProvider<AuthProvider>(
      // Create the AuthProvider instance and immediately check auth status
      create: (context) => AuthProvider()..checkAuthStatus(),
      child: const MyApp(),
    ),
  );
}

// Function to create a default admin user for testing
Future<void> _createDefaultAdminAccount() async {
  try {
    final firebase_auth.FirebaseAuth auth = firebase_auth.FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Check if admin already exists by trying to sign in
    try {
      await auth.signInWithEmailAndPassword(
        email: 'admin@hostel.com',
        password: 'admin123',
      );
      // If successful, admin exists. Sign out.
      print("Admin user already exists.");
      await auth.signOut();
    } catch (signInError) {
      // If sign-in fails, assume admin doesn't exist. Try to create it.
      print("Admin user does not exist. Attempting to create...");
      try {
        final userCredential = await auth.createUserWithEmailAndPassword(
          email: 'admin@hostel.com',
          password: 'admin123',
        );

        // Save admin data to Firestore 'admins' collection
        await firestore.collection('admins').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': 'admin@hostel.com',
          'name': 'Administrator',
          'role': 'admin',
          'createdAt': FieldValue.serverTimestamp(),
        });

        print("Admin user created successfully.");
        // Sign out after creation
        await auth.signOut();
      } catch (createError) {
        // This might happen if the user already exists in Auth but not in Firestore,
        // or due to other Firebase errors.
        print('Admin creation error: $createError');
      }
    }
  } catch (e) {
    print('Error checking/creating default admin: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      designSize: const Size(375, 825),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        // The MaterialApp's home is now determined by AuthWrapper
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Hostel Management System',
          home: AuthWrapper(), // ✅ Use the wrapper for auth-based navigation
        );
      },
    );
  }
}

// Widget to handle navigation based on authentication state
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the AuthProvider instance from the Provider tree
    final authProvider = Provider.of<AuthProvider>(context);

    // Show a loading indicator while the auth status is being checked
    if (authProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Navigate to LoginScreen if the user is not authenticated
    if (!authProvider.isAuthenticated) {
      return const LoginScreen();
    }

    // Navigate to HomeScreen if the user is authenticated
    // The HomeScreen will then use authProvider.isAdmin/isStaff/isStudent
    // to customize its content.
    return const HomeScreen();
  }
}