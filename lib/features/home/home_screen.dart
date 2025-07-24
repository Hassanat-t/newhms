import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newhms/features/admin/screen/create_staff.dart';
import 'package:newhms/features/admin/screen/issue_details_screen.dart';
import 'package:newhms/features/admin/screen/room_change_request_screen.dart';
import 'package:newhms/features/admin/screen/staff_display_screen.dart';
import 'package:newhms/features/student/screen/hostel_fee.dart';
import 'package:newhms/features/student/screen/profile_screen.dart';
import 'package:newhms/features/student/screen/raise_issue_screen.dart';
import 'package:newhms/features/student/screen/room_availability.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newhms/theme/colors.dart';
import 'package:newhms/widget/Categories_card.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../common/constants.dart';
import '../../../common/spacing.dart';
import '../../../theme/text_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chartData = [
      ChartData(label: 'Approved', value: 60, color: Colors.green),
      ChartData(label: 'Rejected', value: 20, color: Colors.red),
      ChartData(label: 'Pending', value: 20, color: Colors.grey),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Dashboard",
          style: AppTextTheme.kLabelStyle.copyWith(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.kGreenColor,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const ProfileScreen(
                      roomNumber: "A1",
                      blockNumber: "B1",
                      username: "student123",
                      emailId: "student@example.com",
                      phoneNumber: "1234567890",
                      firstName: "John",
                      lastName: "Doe",
                    ),
                  ),
                );
              },
              child: SvgPicture.asset(AppConstants.profile),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        child: Column(
          children: [
            heightSpacer(20),
            Container(
              height: 140.h,
              width: double.infinity,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 180.w,
                          child: Text(
                            'John Doe',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF333333),
                              fontSize: 24.sp,
                            ),
                          ),
                        ),
                        heightSpacer(15),
                        Text("Room No. : A1", style: TextStyle(fontSize: 15.sp)),
                        Text("Block No. : B1", style: TextStyle(fontSize: 15.sp)),
                      ],
                    ),
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
              width: double.infinity,
              color: const Color(0x262E8B57),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  heightSpacer(20),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      'Categories',
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
                              builder: (context) => const RoomAvailabilityScreen(),
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
                              builder: (context) =>  const HostelFee(
                                blockNumber: 'B1',
                                roomNumber: 'A1',
                                maintenanceCharge: '1000',
                                parkingCharge: '200',
                                waterCharge: '150',
                                roomCharge: '5000',
                                totalCharge: '6350',
                              ),
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
                              builder: (context) => const RoomChangeRequestScreen(),
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
            SfCircularChart(
              series: <CircularSeries>[
                PieSeries<ChartData, String>(
                  dataSource: chartData,
                  pointColorMapper: (ChartData data, _) => data.color,
                  xValueMapper: (ChartData data, _) => data.label,
                  yValueMapper: (ChartData data, _) => data.value,
                  dataLabelMapper: (ChartData data, _) => '${data.label}\n${data.value}',
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  final String label;
  final double value;
  final Color color;

  ChartData({required this.label, required this.value, required this.color});
}
