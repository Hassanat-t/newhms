import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newhms/common/app_bar.dart';
import 'package:newhms/common/custom_text.dart';
import 'package:newhms/common/spacing.dart';
import 'package:newhms/features/auth/widgets/custom_button.dart';
import 'package:newhms/theme/text_theme.dart';

class RaiseIssueScreen extends StatefulWidget {
  const RaiseIssueScreen({super.key});

  @override
  State<RaiseIssueScreen> createState() => _RaiseIssueScreenState();
}

class _RaiseIssueScreenState extends State<RaiseIssueScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController studentComment = TextEditingController();

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
    studentComment.dispose();
    super.dispose();
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
                heightSpacer(15),
                _buildStaticInput("Room 101"),

                heightSpacer(15),
                Text('Block Number', style: AppTextTheme.kLabelStyle),
                heightSpacer(15),
                _buildStaticInput("Block A"),

                heightSpacer(15),
                Text('Your Email ID', style: AppTextTheme.kLabelStyle),
                heightSpacer(15),
                _buildStaticInput("example@email.com"),

                heightSpacer(15),
                Text('Phone Number', style: AppTextTheme.kLabelStyle),
                heightSpacer(15),
                _buildStaticInput("08012345678"),

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
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),

                heightSpacer(40),
                CustomButton(
                  buttonText: "Submit",
                  press: () {
                    if (_formKey.currentState!.validate()) {
                      // Placeholder: Replace with Firebase logic later
                      print("Issue submitted");
                    }
                  },
                ),
                heightSpacer(20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStaticInput(String value) {
    return Container(
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
          value,
          style: TextStyle(
            color: const Color(0xFF333333),
            fontSize: 17.sp,
          ),
        ),
      ),
    );
  }
}
