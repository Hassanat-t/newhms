// lib/features/student/screen/raise_issue_screen.dart
//import 'package:firebase_auth/firebase_auth.dart'as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newhms/common/app_bar.dart'; // Assuming this file exists
import 'package:newhms/common/spacing.dart';
import 'package:newhms/features/auth/widgets/custom_button.dart';
import 'package:newhms/features/auth/widgets/custom_text_field.dart';
import 'package:newhms/providers/auth_providers.dart';
// import 'package:newhms/services/firebase_issue_service.dart'; // We'll fetch data differently
import 'package:newhms/theme/text_theme.dart';
import 'package:provider/provider.dart'; // Import provider
//import 'package:newhms/providers/auth_provider.dart'; // Import your AuthProvider
import 'package:cloud_firestore/cloud_firestore.dart'; // To fetch data directly

class RaiseIssueScreen extends StatefulWidget {
  const RaiseIssueScreen({super.key});

  @override
  State<RaiseIssueScreen> createState() => _RaiseIssueScreenState();
}

class _RaiseIssueScreenState extends State<RaiseIssueScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Remove the old service instance as we'll fetch data directly or via updated service
  // final FirebaseIssueService _issueService = FirebaseIssueService();
  final TextEditingController _studentCommentController =
      TextEditingController();
  String? _selectedIssue;
  // Store student data fetched from Firestore/AuthProvider
  Map<String, dynamic>? _studentData;
  bool _isLoading = true;
  bool _isSubmitting = false;
  final List<String> _issues = [
    'Bathroom',
    'Bedroom',
    'Water',
    'Furniture',
    'Kitchen',
    'Electrical',
    'Internet',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _fetchStudentDetails(); // Fetch details using the new method
  }

  // Updated method to fetch student details using AuthProvider and Firestore
  Future<void> _fetchStudentDetails() async {
    try {
      setState(() {
        _isLoading = true; // Ensure loading state is set at the start
      });

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.user; // Get user from AuthProvider

      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Fetch student data directly from Firestore using the UID
      final studentDoc = await FirebaseFirestore.instance
          .collection('students')
          .doc(user.uid)
          .get();

      if (studentDoc.exists) {
        setState(() {
          _studentData =
              studentDoc.data() as Map<String, dynamic>; // Store the data
          _isLoading = false;
        });
      } else {
        throw Exception('Student data not found for UID: ${user.uid}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load student details: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _studentCommentController.dispose();
    super.dispose();
  }

  // Helper to get data from _studentData map
  String _getStudentData(String field) {
    if (_isLoading)
      return 'Loading...'; // Show loading while data is being fetched
    if (_studentData == null) return 'Error loading data';
    return _studentData![field]?.toString() ?? 'N/A';
  }

  // Updated method to submit the issue
  Future<void> _submitIssue() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedIssue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an issue type.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.user; // Get user from AuthProvider

      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Prepare data for Firestore
      final issueData = {
        'studentUid': user.uid, // Use UID from AuthProvider
        'studentName':
            '${_getStudentData('firstName')} ${_getStudentData('lastName')}'
                .trim(),
        'studentRoom': _getStudentData('roomNumber'),
        'studentBlock':
            _getStudentData('block'), // Assuming 'block' field exists
        'studentEmail': user.email ??
            _getStudentData('email'), // Prefer Firebase Auth email
        'studentPhone': _getStudentData('phoneNumber'),
        'issueType': _selectedIssue,
        'description': _studentCommentController.text.trim(),
        'status': 'open', // Default status
        'priority': 'medium', // Default priority, could be dynamic
        'createdAt': FieldValue.serverTimestamp(),
        // Add other fields as needed, like assignedTo, resolvedAt, etc.
      };

      // Submit issue to Firestore
      await FirebaseFirestore.instance.collection('issues').add(issueData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Issue submitted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        // Clear form
        setState(() {
          _selectedIssue = null;
          _studentCommentController.clear();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to submit issue: ${e.toString().replaceAll('Exception:', '').trim()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get AuthProvider to potentially check role if needed (though this screen is likely student-only)
    // final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar:
          buildAppBar(context, "Create Issue"), // Assuming buildAppBar exists
      body: _isLoading // Show loading indicator while fetching data
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      heightSpacer(15),
                      Text('Room Number', style: AppTextTheme.kLabelStyle),
                      heightSpacer(15),
                      Container(
                        width: double.maxFinite,
                        padding: const EdgeInsets.all(12),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 1, color: Color(0xFF2E8B57)),
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            _getStudentData(
                                'roomNumber'), // Fetched from Firestore
                            style: TextStyle(
                              color: const Color(0xFF333333),
                              fontSize: 17.sp,
                            ),
                          ),
                        ),
                      ),
                      heightSpacer(15),
                      Text('Block Number', style: AppTextTheme.kLabelStyle),
                      heightSpacer(15),
                      Container(
                        width: double.maxFinite,
                        padding: const EdgeInsets.all(12),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 1, color: Color(0xFF2E8B57)),
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            _getStudentData('block'), // Fetched from Firestore
                            style: TextStyle(
                              color: const Color(0xFF333333),
                              fontSize: 17.sp,
                            ),
                          ),
                        ),
                      ),
                      heightSpacer(15),
                      Text('Your Email ID', style: AppTextTheme.kLabelStyle),
                      heightSpacer(15),
                      Container(
                        width: double.maxFinite,
                        padding: const EdgeInsets.all(12),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 1, color: Color(0xFF2E8B57)),
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            // Prefer email from Firebase Auth user object
                            Provider.of<AuthProvider>(context, listen: false)
                                    .user
                                    ?.email ??
                                _getStudentData('email') ??
                                'N/A',
                            style: TextStyle(
                              color: const Color(0xFF333333),
                              fontSize: 17.sp,
                            ),
                          ),
                        ),
                      ),
                      heightSpacer(15),
                      Text('Phone Number', style: AppTextTheme.kLabelStyle),
                      heightSpacer(15),
                      Container(
                        width: double.maxFinite,
                        padding: const EdgeInsets.all(12),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 1, color: Color(0xFF2E8B57)),
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            _getStudentData(
                                'phoneNumber'), // Fetched from Firestore
                            style: TextStyle(
                              color: const Color(0xFF333333),
                              fontSize: 17.sp,
                            ),
                          ),
                        ),
                      ),
                      heightSpacer(15),
                      Text('Issue you are facing?',
                          style: AppTextTheme.kLabelStyle),
                      heightSpacer(15),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        width: double.maxFinite,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 1, color: Color(0xFF2E8B57)),
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: DropdownButton<String>(
                          underline: const SizedBox(),
                          isExpanded: true,
                          value: _selectedIssue,
                          hint: const Text('Select Issue Type'),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedIssue = newValue;
                            });
                          },
                          items: _issues.map((String issue) {
                            return DropdownMenuItem<String>(
                              value: issue,
                              child: Text(issue),
                            );
                          }).toList(),
                        ),
                      ),
                      heightSpacer(15),
                      Text('Comment', style: AppTextTheme.kLabelStyle),
                      heightSpacer(15),
                      CustomTextField(
                        controller: _studentCommentController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Comment is required';
                          }
                          if (value.length < 10) {
                            return 'Comment should be at least 10 characters';
                          }
                          return null;
                        },
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Color(0xFFD1D8FF)),
                            borderRadius: BorderRadius.circular(14)),
                        maxLines: 3,
                        inputHint: 'Describe your issue in detail',
                      ),
                      heightSpacer(40),
                      CustomButton(
                        buttonText: "Submit",
                        press: _submitIssue,
                        isLoading:
                            _isSubmitting, // Show loading on button during submission
                      ),
                      heightSpacer(20),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
