import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newhms/common/custom_text.dart';
import 'package:newhms/features/home/widgets/home_card.dart';
import 'package:newhms/features/student/screens/hostel_fee_screen.dart';
import 'package:newhms/features/student/screens/raise_issue_screen.dart';
import 'package:newhms/features/student/screens/room_availability.dart';
import 'package:newhms/features/student/screens/profile_screen.dart';
import 'package:newhms/features/admin/screens/staff_display_screen.dart';
import 'package:newhms/features/admin/screens/create_staff_screen.dart';
import 'package:newhms/features/admin/screens/issue_details.dart';
import 'package:newhms/theme/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: const CustomText(
          text: 'Dashboard',
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        backgroundColor: primaryColor,
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('User data not found'));
          }

          final userData = snapshot.data!.data()!;
          final String firstName = userData['firstName'] ?? '';
          final String lastName = userData['lastName'] ?? '';
          final String role = userData['role'] ?? '';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Hi, $firstName $lastName',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      if (role == 'student') ...[
                        HomeCard(
                          icon: Icons.account_circle,
                          title: 'Profile',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ProfileScreen(),
                              ),
                            );
                          },
                        ),
                        HomeCard(
                          icon: Icons.info,
                          title: 'Raise Issue',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RaiseIssueScreen(),
                              ),
                            );
                          },
                        ),
                        HomeCard(
                          icon: Icons.money,
                          title: 'Hostel Fees',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HostelFeeScreen(),
                              ),
                            );
                          },
                        ),
                        HomeCard(
                          icon: Icons.bedroom_child_outlined,
                          title: 'Room Availability',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RoomAvailabilityScreen(),
                              ),
                            );
                          },
                        ),
                      ] else if (role == 'admin') ...[
                        HomeCard(
                          icon: Icons.people,
                          title: 'All Staff',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const StaffDisplayScreen(),
                              ),
                            );
                          },
                        ),
                        HomeCard(
                          icon: Icons.add,
                          title: 'Add Staff',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CreateStaffScreen(),
                              ),
                            );
                          },
                        ),
                        HomeCard(
                          icon: Icons.report,
                          title: 'All Issues',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const IssueDetailsScreen(),
                              ),
                            );
                          },
                        ),
                      ]
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
