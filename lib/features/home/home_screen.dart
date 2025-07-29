import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newhms/common/constants.dart';
import 'package:newhms/common/spacing.dart';
import 'package:newhms/features/admin/screen/create_staff.dart';
import 'package:newhms/features/admin/screen/issue_details_screen.dart';
import 'package:newhms/features/admin/screen/room_change_request_screen.dart';
import 'package:newhms/features/admin/screen/staff_display_screen.dart';
import 'package:newhms/features/student/screen/hostel_fee.dart';
import 'package:newhms/features/student/screen/profile_screen.dart';
import 'package:newhms/features/student/screen/raise_issue_screen.dart';
import 'package:newhms/features/student/screen/room_availability.dart';
import 'package:newhms/theme/colors.dart';
import 'package:newhms/theme/text_theme.dart';
import 'package:newhms/widgets/category_card.dart';

class HomeScreen extends StatefulWidget {
  final String role;
  const HomeScreen({super.key, required this.role});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // utility function to handle access restrictions
  // and authorization
  void _handleRestrictedAccess({
    required List<String> allowedRoles,
    required VoidCallback onAccessGranted,
  }) {
    if (allowedRoles.contains(widget.role)) {
      onAccessGranted();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You do not have access to this feature'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kGreenColor,
        centerTitle: false,
        title: Text(
          "Dashboard",
          style: AppTextTheme.kLabelStyle.copyWith(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: InkWell(
              onTap: () {
                Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>  ProfileScreen(),
                              ),
                            );
              },
              child: SvgPicture.asset(
                AppConstants.profile,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15.w,
            vertical: 10.h,
          ),
          child: Column(
            children: [
              heightSpacer(20),
              Container(
                height: 160.h,
                width: double.maxFinite,
                decoration: const ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 2, color: Color(0xFF007B3B)),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(2),
                    ),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x332E8B57),
                      blurRadius: 8,
                      offset: Offset(2, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 180.w,
                            child: Text(
                              'Anidu Hassanat',
                              // maxLines: 1,
                              // overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF333333),
                                fontSize: 24.sp,
                              ),
                            ),
                          ),
                          heightSpacer(15),
                          Text(
                            "Room No. : 101",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF333333),
                              fontSize: 15.sp,
                            ),
                          ),
                          Text(
                            'Block No. :  A',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF333333),
                              fontSize: 15.sp,
                            ),
                          )
                        ],
                      ),
                      widthSpacer(10),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const RaiseIssueScreen(),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            SvgPicture.asset(AppConstants.createIssue),
                            Text(
                              'Create issues',
                              style: TextStyle(
                                color: const Color(0xFF153434),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              heightSpacer(30),
              Container(
                width: double.maxFinite,
                color: const Color(0x262E8B57),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    heightSpacer(20),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        'Categories',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF333333),
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    heightSpacer(15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CategoryCard(
                          category: 'Room\nAvailability',
                          image: AppConstants.roomAvailability,
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    const RoomAvailabilityScreen(),
                              ),
                            );
                          },
                        ),
                        CategoryCard(
                          category: 'All\nIssues',
                          image: AppConstants.allIssues,
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const IssueScreen(),
                              ),
                            );
                          },
                        ),
                        CategoryCard(
                          category: 'Staff\nMembers',
                          image: AppConstants.staffMember,
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const StaffInfoScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    heightSpacer(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CategoryCard(
                          category: 'Create\nStaff',
                          image: AppConstants.createStaff,
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const CreateStaff(),
                              ),
                            );
                          },
                        ),
                        CategoryCard(
                          category: 'Hostel\nFee',
                          image: AppConstants.hostelFee,
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => HostelFee(),
                              ),
                            );
                          },
                        ),
                        CategoryCard(
                          category: 'Change\nRequests',
                          image: AppConstants.roomChange,
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    const RoomChangeRequestScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    heightSpacer(20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
