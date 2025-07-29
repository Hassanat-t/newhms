import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newhms/common/app_bar.dart';
import 'package:newhms/common/constants.dart';
import 'package:newhms/common/spacing.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newhms/models/user_model.dart';

import 'package:newhms/utils/string_extensions.dart';

class StaffInfoScreen extends StatefulWidget {
  const StaffInfoScreen({super.key});

  @override
  State<StaffInfoScreen> createState() => _StaffInfoScreenState();
}

class _StaffInfoScreenState extends State<StaffInfoScreen> {

  List<UserModel> staffList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStaff();
  }

  Future<void> fetchStaff() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'staff')
          .orderBy('createdAt', descending: true)
          .get();

      setState(() {
        staffList = querySnapshot.docs
            .map((doc) => UserModel.fromMap(doc.data(), doc.id))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching staff: $e');
      setState(() => isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'All Staff'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
      : staffList.isEmpty ? const Center(child: Text('No staff found.'))
      :
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 2 / 1.2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: staffList.length,
          itemBuilder: (context, index) {
            final staff = staffList[index];

            return Container(
              key: ValueKey(staff.uid),
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
                              staff.role.capitalize(),
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
                                'Name: ${staff.firstName} ${staff.lastName}'.toTitleCase(),
                                style: TextStyle(
                                  color: const Color(0xFF333333),
                                  fontSize: 14.sp,
                                ),
                              ),
                              heightSpacer(8.0),
                              Text(
                                'Email: staff@gmail.com',
                                style: TextStyle(
                                  color: const Color(0xFF333333),
                                  fontSize: 14.sp,
                                ),
                              ),
                              heightSpacer(8.0),
                              Text('Contact: ${staff.phoneNumber}'),
                              heightSpacer(8.0),
                           
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {});
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
          },
        ),
      ),
    );
  }
}
