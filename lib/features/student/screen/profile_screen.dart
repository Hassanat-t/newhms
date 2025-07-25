import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newhms/common/custom_text.dart';
import 'package:newhms/features/auth/screens/login_screen.dart';
import 'package:newhms/theme/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      if (snapshot.exists) {
        setState(() {
          userData = snapshot.data();
          isLoading = false;
        });
      }
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: const CustomText(text: 'Profile', fontSize: 20, fontWeight: FontWeight.bold),
        backgroundColor: primaryColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userData == null
              ? const Center(child: Text('User data not found'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: userData!['photoUrl'] != null
                            ? NetworkImage(userData!['photoUrl'])
                            : const AssetImage('assets/images/profile_placeholder.png')
                                as ImageProvider,
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: Text('${userData!['firstName']} ${userData!['lastName']}'),
                        subtitle: const Text('Full Name'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.email),
                        title: Text(userData!['email'] ?? ''),
                        subtitle: const Text('Email'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.phone),
                        title: Text(userData!['phoneNumber'] ?? 'N/A'),
                        subtitle: const Text('Phone Number'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.person_pin),
                        title: Text(userData!['role'] ?? 'N/A'),
                        subtitle: const Text('Role'),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: _logout,
                        icon: const Icon(Icons.logout),
                        label: const Text('Logout'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      )
                    ],
                  ),
                ),
    );
  }
}
