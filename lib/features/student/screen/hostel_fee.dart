import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newhms/common/app_bar.dart'; // Adjust import if needed
import 'package:newhms/common/constants.dart'; // Adjust import if needed
import 'package:newhms/common/spacing.dart'; // Adjust import if needed
import 'package:newhms/services/firebase_fee_service.dart'; // Adjust import if needed

class HostelFee extends StatefulWidget {
  // If this screen is ONLY called from HomeScreen with pre-fetched data,
  // consider making these required and removing the Firebase fetching logic.
  // However, keeping the Firebase logic allows this screen to be standalone too.
  final String? initialBlockNumber;
  final String? initialRoomNumber;
  final String? initialMaintenanceCharge;
  final String? initialParkingCharge;
  final String? initialWaterCharge;
  final String? initialRoomCharge;
  final String? initialTotalCharge;

  const HostelFee({
    Key? key,
    // Allow initialization with data passed from HomeScreen
    this.initialBlockNumber,
    this.initialRoomNumber,
    this.initialMaintenanceCharge,
    this.initialParkingCharge,
    this.initialWaterCharge,
    this.initialRoomCharge,
    this.initialTotalCharge,
  }) : super(key: key);

  @override
  State<HostelFee> createState() => _HostelFeeState();
}

class _HostelFeeState extends State<HostelFee> {
  final FirebaseFeeService _feeService = FirebaseFeeService();
  Map<String, dynamic>? _feeData;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    // If data is passed from HomeScreen, use it directly.
    // Otherwise, fetch from Firebase.
    if (widget.initialBlockNumber != null) {
      // Simulate data being loaded from passed parameters
      WidgetsBinding.instance.addPostFrameCallback((_) {
         setState(() {
          _feeData = {
            'blockNumber': widget.initialBlockNumber ?? 'N/A',
            'roomNumber': widget.initialRoomNumber ?? 'N/A',
            'maintenanceCharge': widget.initialMaintenanceCharge ?? '0',
            'parkingCharge': widget.initialParkingCharge ?? '0',
            'waterCharge': widget.initialWaterCharge ?? '0',
            'roomCharge': widget.initialRoomCharge ?? '0',
            'totalCharge': widget.initialTotalCharge ?? '0',
          };
          _isLoading = false;
        });
      });
    } else {
      // Fallback to fetching data if not passed (e.g., if screen is accessed directly)
      _fetchFeeDetails();
    }
  }

  Future<void> _fetchFeeDetails() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final feeData = await _feeService.getStudentFeeDetails(user.email ?? '');
        if (feeData != null) {
          setState(() {
            _feeData = feeData;
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = 'No fee data found for this student';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'User not authenticated';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load fee details: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  // Helper method to safely display data or a default value
  String _getDisplayText(String? value, {String defaultValue = 'N/A'}) {
    if (value == null || value.isEmpty) {
      return defaultValue;
    }
    return value;
  }

  // Helper method to safely display charge values with a currency sign
  String _getChargeText(String? value) {
    final displayValue = _getDisplayText(value, defaultValue: '0');
    // Basic check to ensure it looks like a number before adding $
    if (double.tryParse(displayValue) != null) {
      // Format with 2 decimal places for currency
      return '\$ ${double.parse(displayValue).toStringAsFixed(2)}';
    } else {
      // If it's not a valid number, default to \$ 0.00
      return '\$ 0.00';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar( // Make sure this function exists or adjust
        context,
        'Hostel Fees',
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_errorMessage),
                      TextButton(
                        onPressed: _fetchFeeDetails, // Retry fetching
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        heightSpacer(20),
                        // Make sure this asset exists or adjust
                        SvgPicture.asset(
                          AppConstants.hostel, // Adjust import/path if needed
                          height: 200.h,
                        ),
                        heightSpacer(40),
                        Container(
                          width: double.maxFinite,
                          decoration: ShapeDecoration(
                            color: const Color(0x4C2E8B57), // Light green background
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                width: 4,
                                strokeAlign: BorderSide.strokeAlignOutside,
                                color: Color(0xFF2E8B57), // Dark green border
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            shadows: const [
                              BoxShadow(
                                color: Color(0x332E8B57), // Shadow color
                                blurRadius: 8,
                                offset: Offset(1, 4),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                heightSpacer(20),
                                Text(
                                  'Hostel details',
                                  style: TextStyle(
                                    color: const Color(0xFF333333), // Dark grey text
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                heightSpacer(20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Block no.',
                                          style: TextStyle(
                                            color: const Color(0xFF464646), // Medium grey text
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          // Use helper for safe display
                                          '- ${_getDisplayText(_feeData?['blockNumber'])}',
                                          style: const TextStyle(
                                            color: Color(0xFF464646),
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Room no.',
                                          style: TextStyle(
                                            color: const Color(0xFF464646),
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          // Use helper for safe display
                                          '- ${_getDisplayText(_feeData?['roomNumber'])}',
                                          style: const TextStyle(
                                            color: Color(0xFF464646),
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                heightSpacer(20),
                                const Text(
                                  'Payment details ',
                                  style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                heightSpacer(20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Maintenance charge - ',
                                      style: TextStyle(
                                        color: const Color(0xFF464646),
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      // Use helper for safe charge display
                                      _getChargeText(_feeData?['maintenanceCharge']),
                                      style: TextStyle(
                                        color: const Color(0xFF464646),
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                heightSpacer(20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Parking charge - ',
                                      style: TextStyle(
                                        color: const Color(0xFF464646),
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      // Use helper for safe charge display
                                      _getChargeText(_feeData?['parkingCharge']),
                                      style: TextStyle(
                                        color: const Color(0xFF464646),
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                heightSpacer(20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Room water charge - ',
                                      style: TextStyle(
                                        color: const Color(0xFF464646),
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      // Use helper for safe charge display
                                      _getChargeText(_feeData?['waterCharge']),
                                      style: TextStyle(
                                        color: const Color(0xFF464646),
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                heightSpacer(20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Room charge - ',
                                      style: TextStyle(
                                        color: const Color(0xFF464646),
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      // Use helper for safe charge display
                                      _getChargeText(_feeData?['roomCharge']),
                                      style: TextStyle(
                                        color: const Color(0xFF464646),
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                heightSpacer(20),
                                const Divider(
                                  color: Colors.black,
                                ),
                                heightSpacer(20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total Amount - ',
                                      style: TextStyle(
                                        color: const Color(0xFF464646),
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      // Use helper for safe charge display
                                      _getChargeText(_feeData?['totalCharge']),
                                      style: TextStyle(
                                        color: const Color(0xFF464646),
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold, // Make total stand out
                                      ),
                                    ),
                                  ],
                                ),
                                heightSpacer(30),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}