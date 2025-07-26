import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newhms/common/app_bar.dart';
import 'package:newhms/common/spacing.dart';
import 'package:newhms/features/auth/widgets/custom_button.dart';
import 'package:newhms/features/auth/widgets/custom_text_field.dart';
import 'package:newhms/services/firebase_issue_service.dart';
import 'package:newhms/theme/text_theme.dart';

class RaiseIssueScreen extends StatefulWidget {
  const RaiseIssueScreen({super.key});

  @override
  State<RaiseIssueScreen> createState() => _RaiseIssueScreenState();
}

class _RaiseIssueScreenState extends State<RaiseIssueScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseIssueService _issueService = FirebaseIssueService();
  
  final TextEditingController _studentCommentController = TextEditingController();
  
  String? _selectedIssue;
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
    _fetchStudentDetails();
  }

  Future<void> _fetchStudentDetails() async {
    try {
      final studentData = await _issueService.getCurrentStudentDetails();
      setState(() {
        _studentData = studentData;
        _isLoading = false;
      });
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

  String _getStudentData(String field) {
    if (_studentData == null) return 'Loading...';
    return _studentData![field]?.toString() ?? 'N/A';
  }

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
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      await _issueService.submitIssue(
        roomNumber: _getStudentData('roomNumber'),
        blockNumber: _getStudentData('block'),
        issueType: _selectedIssue!,
        studentComment: _studentCommentController.text.trim(),
        studentEmail: user.email ?? _getStudentData('email'),
        studentPhone: _getStudentData('phoneNumber'),
        studentId: user.uid,
      );

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
            content: Text('Failed to submit issue: ${e.toString().replaceAll('Exception:', '').trim()}'),
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
    return Scaffold(
      appBar: buildAppBar(context, "Create Issue"),
      body: _isLoading
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
                            side: const BorderSide(width: 1, color: Color(0xFF2E8B57)),
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            _getStudentData('roomNumber'),
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
                            side: const BorderSide(width: 1, color: Color(0xFF2E8B57)),
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            _getStudentData('block'),
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
                            side: const BorderSide(width: 1, color: Color(0xFF2E8B57)),
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            _getStudentData('email') ?? FirebaseAuth.instance.currentUser?.email ?? 'N/A',
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
                            side: const BorderSide(width: 1, color: Color(0xFF2E8B57)),
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            _getStudentData('phoneNumber'),
                            style: TextStyle(
                              color: const Color(0xFF333333),
                              fontSize: 17.sp,
                            ),
                          ),
                        ),
                      ),
                      heightSpacer(15),
                      Text('Issue you are facing?', style: AppTextTheme.kLabelStyle),
                      heightSpacer(15),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        width: double.maxFinite,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(width: 1, color: Color(0xFF2E8B57)),
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
                            borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                            borderRadius: BorderRadius.circular(14)),
                        maxLines: 3,
                        inputHint: 'Describe your issue in detail',
                      ),
                      heightSpacer(40),
                      CustomButton(
                        buttonText: "Submit",
                        press: _submitIssue,
                        isLoading: _isSubmitting,
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