import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newhms/common/app_bar.dart';
import 'package:newhms/common/constants.dart';
import 'package:newhms/common/spacing.dart';

class StaffInfoScreen extends StatelessWidget {
  const StaffInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'All Staff'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 2 / 1.2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
            ),
            itemCount: 1, // Placeholder for now
            itemBuilder: (context, index) {
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
                              const Text(
                                'Job Role',
                                textAlign: TextAlign.center,
                                style: TextStyle(
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
                                  'Name: Firstname Lastname',
                                  style: TextStyle(
                                    color: const Color(0xFF333333),
                                    fontSize: 14.sp,
                                  ),
                                ),
                                heightSpacer(8.0),
                                Text(
                                  'Email: email@example.com',
                                  style: TextStyle(
                                    color: const Color(0xFF333333),
                                    fontSize: 14.sp,
                                  ),
                                ),
                                heightSpacer(8.0),
                                const Text('Contact: 0000000000'),
                                heightSpacer(8.0),
                                const Text('First Name: Firstname'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // Placeholder for delete logic
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
      ),
    );
  }
}
