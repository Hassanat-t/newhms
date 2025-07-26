import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newhms/common/app_bar.dart';
import 'package:newhms/common/constants.dart';
import 'package:newhms/common/spacing.dart';
import 'package:newhms/services/firebase_services.dart';

class StaffInfoScreen extends StatefulWidget {
  const StaffInfoScreen({super.key});

  @override
  State<StaffInfoScreen> createState() => _StaffInfoScreenState();
}

class _StaffInfoScreenState extends State<StaffInfoScreen> {
  final FirebaseServices _firebaseServices = FirebaseServices();

  Future<void> _deleteStaff(BuildContext context, String staffId) async {
    try {
      await _firebaseServices.deleteStaffTest(staffId);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Staff deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete staff: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    // Check if user has permission (assuming only admins can view staff info)
    bool hasPermission = user != null; // Add your role checking logic here

    return Scaffold(
      appBar: buildAppBar(context, 'All Staff'),
      body: !hasPermission
          ? const Center(
              child: Text("You don't have permission to view this page"),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: _firebaseServices.getAllStaffTest(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No Staff is Registered yet."),
                  );
                } else {
                  final staffDocs = snapshot.data!.docs;
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: 2 / 1.2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                      ),
                      itemCount: staffDocs.length,
                      itemBuilder: (context, index) {
                        final staffDoc = staffDocs[index];
                        final staffData = staffDoc.data() as Map<String, dynamic>;
                        return StaffCard(
                          staffDoc: staffDoc,
                          staffData: staffData,
                          onDelete: (staffId) => _deleteStaff(context, staffId),
                        );
                      },
                    ),
                  );
                }
              },
            ),
    );
  }
}

class StaffCard extends StatelessWidget {
  final QueryDocumentSnapshot staffDoc;
  final Map<String, dynamic> staffData;
  final Function(String) onDelete;

  const StaffCard({
    super.key,
    required this.staffDoc,
    required this.staffData,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Extract data with fallbacks
    final firstName = staffData['firstName'] ?? 'Unknown';
    final lastName = staffData['lastName'] ?? '';
    final email = staffData['email'] ?? 'No email';
    final phone = staffData['phoneNumber'] ?? 'No phone';
    final jobRole = staffData['jobRole'] ?? 'No role';

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 2, color: Color(0xFF007B3B)),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
            bottomLeft: Radius.circular(30),
          ),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x4C007B3B),
            blurRadius: 8,
            offset: Offset(1, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Column(
                  children: [
                    Image.asset(
                      AppConstants.person,
                      width: 90.w,
                      height: 90.h,
                    ),
                    heightSpacer(20),
                    Text(
                      jobRole,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ],
                ),
                widthSpacer(10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      heightSpacer(10.0),
                      Text(
                        'Name: $firstName',
                        style: TextStyle(
                          color: const Color(0xFF333333),
                          fontSize: 14.sp,
                        ),
                      ),
                      heightSpacer(8.0),
                      Text(
                        'Email: $email',
                        style: TextStyle(
                          color: const Color(0xFF333333),
                          fontSize: 14.sp,
                        ),
                      ),
                      heightSpacer(8.0),
                      Text('Contact: $phone'),
                      heightSpacer(8.0),
                      Text('First Name: $firstName'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              // Show confirmation dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Delete'),
                    content: const Text('Are you sure you want to delete this staff member?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onDelete(staffDoc.id);
                        },
                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              width: double.maxFinite,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: ShapeDecoration(
                color: const Color(0xFFEC6977),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Delete',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}