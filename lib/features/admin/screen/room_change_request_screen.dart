import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newhms/common/app_bar.dart';
import 'package:newhms/common/constants.dart';
import 'package:newhms/common/spacing.dart';

class RoomChangeRequestScreen extends StatelessWidget {
  const RoomChangeRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Room change requests'),
      body: ListView.builder(
        itemCount: 3, // dummy data
        itemBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.all(10.0),
            child: RoomCard(),
          );
        },
      ),
    );
  }
}

class RoomCard extends StatelessWidget {
  const RoomCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: const ShapeDecoration(
        shape: RoundedRectangleBorder(),
      ),
      child: Column(
        children: [
          heightSpacer(20),
          Container(
            decoration: ShapeDecoration(
              gradient: LinearGradient(
                begin: const Alignment(0.00, -1.00),
                end: const Alignment(0, 1),
                colors: [
                  const Color(0xFF2E8B57).withOpacity(0.5),
                  const Color(0x002E8B57),
                ],
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    heightSpacer(20),
                    Image.asset(
                      AppConstants.person,
                      height: 70.h,
                      width: 70.w,
                    ),
                    heightSpacer(10),
                    Text(
                      'John Doe',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF333333),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    heightSpacer(20),
                  ],
                ),
                widthSpacer(20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    heightSpacer(10),
                    const Text('Username: johndoe'),
                    heightSpacer(8),
                    const Text('Current Room: 101'),
                    heightSpacer(8),
                    const Text('Current Block: A'),
                    heightSpacer(8),
                    SizedBox(
                      width: 160.w,
                      child: const Text(
                        'Email Id: johndoe@example.com',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    heightSpacer(8),
                    const Text('Phone No.: 1234567890'),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: double.maxFinite,
            height: 160.h,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        heightSpacer(12),
                        Row(
                          children: [
                            const Text(
                              'Asked For:',
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            widthSpacer(12),
                            Text(
                              'Block: B',
                              style: TextStyle(
                                color: Colors.pink,
                                fontSize: 16.sp,
                              ),
                            ),
                            widthSpacer(20),
                            Text(
                              'Room No: 202',
                              style: TextStyle(
                                color: Colors.pink,
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                        heightSpacer(12),
                        Row(
                          children: [
                            Text(
                              'Reason:',
                              style: TextStyle(
                                color: const Color(0xFF333333),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            widthSpacer(10),
                            Expanded(
                              child: Text(
                                'Need quieter room for studying',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            // Reject action placeholder
                          },
                          child: Container(
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFFED6A77),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x3F000000),
                                  blurRadius: 8,
                                  offset: Offset(1, 3),
                                )
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'Reject',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      widthSpacer(32),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            // Approve action placeholder
                          },
                          child: Container(
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2ECC71),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x3F000000),
                                  blurRadius: 8,
                                  offset: Offset(1, 3),
                                )
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'Approve',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
