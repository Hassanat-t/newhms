import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newhms/common/app_bar.dart';
import 'package:newhms/common/constants.dart';
import 'package:newhms/common/spacing.dart';
import 'package:newhms/services/user_services.dart';

class StaffInfoScreen extends StatelessWidget {
  const StaffInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'All Staff'),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('staff').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No staff found.'));
            }

            final staffDocs = snapshot.data!.docs;

            return GridView.builder(
              itemCount: staffDocs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 2 / 1.2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemBuilder: (context, index) {
                final data = staffDocs[index].data() as Map<String, dynamic>;
                final docId = staffDocs[index].id;

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
                                  data['jobRole'] ?? 'No role',
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  heightSpacer(10.0),
                                  Text(
                                    'Name: ${data['firstName']} ${data['lastName']}',
                                    style: TextStyle(
                                      color: const Color(0xFF333333),
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  heightSpacer(8.0),
                                  Text(
                                    'Email: ${data['email']}',
                                    style: TextStyle(
                                      color: const Color(0xFF333333),
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  heightSpacer(8.0),
                                  Text('Contact: ${data['phoneNumber']}'),
                                  heightSpacer(8.0),
                                  Text('First Name: ${data['firstName']}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await UserService().deleteStaff(docId);
                        },
                        child: Container(
                          width: double.maxFinite,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          decoration: ShapeDecoration(
                            color: const Color(0xFFEC6977),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
