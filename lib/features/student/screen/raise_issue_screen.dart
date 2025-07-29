import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newhms/common/app_bar.dart';
import 'package:newhms/common/spacing.dart';
import 'package:newhms/features/auth/widgets/custom_button.dart';
import 'package:newhms/features/auth/widgets/custom_text_field.dart';
import 'package:newhms/theme/text_theme.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class RaiseIssueScreen extends StatefulWidget {
  const RaiseIssueScreen({super.key});

  @override
  State<RaiseIssueScreen> createState() => _RaiseIssueScreenState();
}

class _RaiseIssueScreenState extends State<RaiseIssueScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController roomNumber = TextEditingController();
  TextEditingController block = TextEditingController();
  TextEditingController issue = TextEditingController();
  TextEditingController studentComment = TextEditingController();
  TextEditingController studentEmailId = TextEditingController();
  TextEditingController studentContactNumber = TextEditingController();

  bool isSubmitting = false;

  String? selectedIssue;
  List<String> issues = [
    'Bathroom',
    'Bedroom',
    'Water',
    'Furniture',
    'Kitchen'
  ];

  @override
  void dispose() {
    roomNumber.dispose();
    block.dispose();
    issue.dispose();
    studentComment.dispose();
    studentEmailId.dispose();
    studentContactNumber.dispose();
    super.dispose();
  }

  // utility logic to help handle and submit issue
  Future<void> submitIssue() async {
    setState(() {
      isSubmitting = true;
    });
    try {
      await FirebaseFirestore.instance.collection('issues').add({
        'roomNumber': roomNumber.text.trim(),
        'block': block.text.trim(),
        'studentEmail': studentEmailId.text.trim(),
        'contactNumber': studentContactNumber.text.trim(),
        'issueType': selectedIssue ?? '',
        'comment': studentComment.text.trim(),
        'timestamp': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Issue submitted successfully!')),
      );

      studentComment.clear();
      setState(() {
        selectedIssue = null;
      });

    } catch (e) {
      print('Error submitting issue: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit issue.')),
      );
    }finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, "Create Issue"),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                heightSpacer(15),
                Text('Room Number', style: AppTextTheme.kLabelStyle),
                // CustomTextField(
                //   validator: (value) {
                //     if (value!.isEmpty) {
                //       return 'Room Number is required';
                //     }
                //     return null;
                //   },
                //   controller: roomNumber,
                //   enabledBorder: OutlineInputBorder(
                //     borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                //     borderRadius: BorderRadius.circular(14),
                //   ),
                //   // inputHint: "",
                // ),
                heightSpacer(15),
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(12),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(width: 1, color: Color(0xFF2E8B57)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      '101',
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
                      side:
                          const BorderSide(width: 1, color: Color(0xFF2E8B57)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      'A',
                      style: TextStyle(
                        color: const Color(0xFF333333),
                        fontSize: 17.sp,
                      ),
                    ),
                  ),
                ),

                // CustomTextField(
                //   validator: (value) {
                //     if (value!.isEmpty) {
                //       return 'Block is required';
                //     }
                //     return null;
                //   },
                //   controller: block,
                //   enabledBorder: OutlineInputBorder(
                //       borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                //       borderRadius: BorderRadius.circular(14)),
                // ),
                heightSpacer(15),
                Text('Your Email ID', style: AppTextTheme.kLabelStyle),
                heightSpacer(15),
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(12),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(width: 1, color: Color(0xFF2E8B57)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      'taiwo@gmail.com',
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
                      side:
                          const BorderSide(width: 1, color: Color(0xFF2E8B57)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      '09093883',
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
                      side:
                          const BorderSide(width: 1, color: Color(0xFF2E8B57)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: DropdownButton<String>(
                    // elevation: 0,
                    underline: const SizedBox(),
                    isExpanded: true,
                    value: selectedIssue,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedIssue = newValue;
                      });
                    },
                    items: issues.map((String issue) {
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
                  controller: studentComment,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Comment is required';
                    }
                    return null;
                  },
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                      borderRadius: BorderRadius.circular(14)),
                ),
                heightSpacer(40),
                CustomButton(
                    press: isSubmitting ? (){} : submitIssue,
                    child: isSubmitting
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Text("Submit", style: TextStyle(color: Colors.white))
                ),
                heightSpacer(20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final emailRegex =
      RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)*(\.[a-z]{2,})$');
}
