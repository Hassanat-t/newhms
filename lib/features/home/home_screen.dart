import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
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
import 'package:newhms/services/firebase_home_service.dart';
import 'package:newhms/theme/colors.dart';
import 'package:newhms/theme/text_theme.dart';
import 'package:newhms/widget/Categories_card.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:newhms/providers/auth_providers.dart';
import 'package:provider/provider.dart'; // Add this import
//import 'package:newhms/providers/auth_provider.dart'; // Add this import

// ... (Keep all your existing model classes: StudentInfoModel, StudentResult, etc.)

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseHomeService _firebaseService = FirebaseHomeService();
  DocumentSnapshot? _studentDoc;
  List<ChartData>? _chartData;
  bool _isLoading = true;
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchPieChartData();
  }

  Future<void> _fetchUserData() async {
    try {
      final user = firebase_auth.FirebaseAuth.instance.currentUser;

      if (user != null) {
        _userEmail = user.email ?? '';
        final studentDoc =
            await _firebaseService.getStudentDetailsByEmail(_userEmail);
        if (studentDoc != null && studentDoc.exists) {
          setState(() {
            _studentDoc = studentDoc;
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchPieChartData() async {
    try {
      final data = await _firebaseService.getPieChartData();
      final roomChangeChart = data;
      setState(() {
        _chartData = [
          ChartData(
              label: 'Approved',
              value:
                  roomChangeChart['totalRoomChangeRequestsApproved'].toDouble(),
              color: Colors.green),
          ChartData(
              label: 'Rejected',
              value:
                  roomChangeChart['totalRoomChangeRequestsRejected'].toDouble(),
              color: Colors.red),
          ChartData(
              label: 'Pending',
              value: (roomChangeChart['totalNumberRoomChangeRequest'] -
                      roomChangeChart['totalRoomChangeRequestsApproved'] -
                      roomChangeChart['totalRoomChangeRequestsRejected'])
                  .toDouble(),
              color: Colors.grey),
        ];
      });
    } catch (e) {
      print('Error fetching chart data: $e');
      // Set default chart data on error
      setState(() {
        _chartData = [
          ChartData(label: 'Approved', value: 15.0, color: Colors.green),
          ChartData(label: 'Rejected', value: 5.0, color: Colors.red),
          ChartData(label: 'Pending', value: 5.0, color: Colors.grey),
        ];
      });
    }
  }

  String _getStudentData(String field) {
    if (_studentDoc == null || !_studentDoc!.exists) return 'No Data';
    final data = _studentDoc!.data() as Map<String, dynamic>;
    return data[field]?.toString() ?? 'No Data';
  }

  int _getRoleId() {
    if (_studentDoc == null || !_studentDoc!.exists) {
      return 3; // Default to student
    }
    final data = _studentDoc!.data() as Map<String, dynamic>;
    return data['roleId'] ?? 3;
  }

  @override
  Widget build(BuildContext context) {
    // Get the auth provider instance
    final authProvider = Provider.of<AuthProvider>(context);
    
    //final roleId = _getRoleId();
    final firstName = _getStudentData('firstName');
    final lastName = _getStudentData('lastName');
    final roomNumber = _getStudentData('roomNumber');
    final blockNumber = _getStudentData('block');
    final username = _getStudentData('username');
    final emailId = _getStudentData('email');
    final phoneNumber = _getStudentData('phoneNumber');

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Dashboard",
          style: AppTextTheme.kLabelStyle.copyWith(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white),
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
                    builder: (context) => ProfileScreen(
                      roomNumber: roomNumber,
                      blockNumber: blockNumber,
                      username: username,
                      emailId: emailId,
                      phoneNumber: phoneNumber,
                      firstName: firstName,
                      lastName: lastName,
                    ),
                  ),
                );
              },
              child: SvgPicture.asset(
                AppConstants.profile,
              ),
            ),
          ),
          // Add logout button
          Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                authProvider.logout();
              },
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15.w,
                  vertical: 10.h,
                ),
                child: Column(
                  children: [
                    heightSpacer(20),
                    _userEmail.isEmpty
                        ? const SizedBox()
                        : Container(
                            height: 140.h,
                            width: double.maxFinite,
                            decoration: const ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 2, color: Color(0xFF007B3B)),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 180.w,
                                        child: Text(
                                          '$firstName $lastName',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF333333),
                                            fontSize: 24.sp,
                                          ),
                                        ),
                                      ),
                                      heightSpacer(5),
                                      // Display user role based on auth provider
                                      Text(
                                        authProvider.isAdmin
                                            ? 'Administrator'
                                            : (authProvider.isStaff
                                                ? 'Staff'
                                                : 'Student'),
                                        style: TextStyle(
                                          color: const Color(0xFF666666),
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      heightSpacer(10),
                                      Text(
                                        "Room No. : $roomNumber",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: const Color(0xFF333333),
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                      Text(
                                        'Block No. :  $blockNumber',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: const Color(0xFF333333),
                                          fontSize: 15.sp,
                                        ),
                                      )
                                    ],
                                  ),
                                  // Show "Create issues" button for students only
                                  if (authProvider.isStudent)
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                const RaiseIssueScreen(),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          SvgPicture.asset(
                                              AppConstants.createIssue),
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
                              // Show Staff Members for staff and admin only
                              if (authProvider.isStaff || authProvider.isAdmin)
                                CategoryCard(
                                  category: 'Staff\nMembers',
                                  image: AppConstants.staffMember,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) =>
                                            const StaffInfoScreen(),
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
                              // Show Create Staff only for admin
                              if (authProvider.isAdmin)
                                CategoryCard(
                                  category: 'Create\nStaff',
                                  image: AppConstants.createStaff,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) =>
                                            const CreateStaff(),
                                      ),
                                    );
                                  },
                                ),
                              // Show Hostel Fee for students only
                              if (authProvider.isStudent)
                                CategoryCard(
                                  category: 'Hostel\nFee',
                                  image: AppConstants.hostelFee,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => HostelFee(
                                          // ---> CHANGE THESE PARAMETER NAMES <---
                                          initialBlockNumber: blockNumber, // <-- Use initialBlockNumber
                                          initialRoomNumber: roomNumber,   // <-- Use initialRoomNumber
                                          initialMaintenanceCharge: _getStudentData('maintenanceCharge'), // <-- Use initialMaintenanceCharge
                                          initialParkingCharge: _getStudentData('parkingCharge'),       // <-- Use initialParkingCharge
                                          initialWaterCharge: _getStudentData('waterCharge'),           // <-- Use initialWaterCharge
                                          initialRoomCharge: _getStudentData('roomCharge'),             // <-- Use initialRoomCharge
                                          initialTotalCharge: _getStudentData('totalCharge'),           // <-- Use initialTotalCharge
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              // Show Change Requests for staff and admin
                              if (authProvider.isStaff || authProvider.isAdmin)
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
                    // Show chart only for staff and admin
                    if ((authProvider.isStaff || authProvider.isAdmin) && _chartData != null)
                      SfCircularChart(
                        series: <CircularSeries>[
                          PieSeries<ChartData, String>(
                            dataSource: _chartData,
                            pointColorMapper: (ChartData data, _) =>
                                data.color,
                            xValueMapper: (ChartData data, _) =>
                                data.label,
                            yValueMapper: (ChartData data, _) =>
                                data.value,
                            dataLabelMapper: (ChartData data, _) =>
                                '${data.label}\n${data.value}',
                            dataLabelSettings: const DataLabelSettings(
                              isVisible: true,
                              labelPosition:
                                  ChartDataLabelPosition.outside,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
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