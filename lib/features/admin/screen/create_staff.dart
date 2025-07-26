import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newhms/common/app_bar.dart';
import 'package:newhms/common/spacing.dart';
import 'package:newhms/features/auth/widgets/custom_button.dart';
import 'package:newhms/features/auth/widgets/custom_text_field.dart';
import 'package:newhms/services/staff_services.dart';
import 'package:newhms/theme/colors.dart';
import 'package:newhms/theme/text_theme.dart';

class CreateStaff extends StatefulWidget {
  const CreateStaff({super.key});

  @override
  State<CreateStaff> createState() => _CreateStaffState();
}

class _CreateStaffState extends State<CreateStaff> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final StaffService _staffService = StaffService();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _jobRoleController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _jobRoleController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _createStaff() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _staffService.createStaff(
        username: _userNameController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        phoneNumber: _phoneNumberController.text.trim(),
        jobRole: _jobRoleController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Staff created successfully'),
            backgroundColor: Colors.green,
          ),
        );

        // Clear form
        _formKey.currentState?.reset();
        _clearControllers();

        // Optionally navigate back
        // Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception:', '').trim()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _clearControllers() {
    _userNameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _firstNameController.clear();
    _lastNameController.clear();
    _phoneNumberController.clear();
    _jobRoleController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    // Check if user has permission (assuming only admins can create staff)
    bool hasPermission = user != null; // Add your role checking logic here

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildAppBar(context, "Create Staff"),
      backgroundColor: AppColors.kBackgroundColor,
      body: !hasPermission
          ? const Center(
              child: Text("You don't have permission to view this page"),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Username', style: AppTextTheme.kLabelStyle),
                      CustomTextField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Username is required';
                          }
                          if (value.length < 3) {
                            return 'Username must be at least 3 characters';
                          }
                          return null;
                        },
                        controller: _userNameController,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      heightSpacer(15),
                      Text('First Name', style: AppTextTheme.kLabelStyle),
                      CustomTextField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'First Name is required';
                          }
                          return null;
                        },
                        controller: _firstNameController,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      heightSpacer(15),
                      Text('Last Name', style: AppTextTheme.kLabelStyle),
                      CustomTextField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Last Name is required';
                          }
                          return null;
                        },
                        controller: _lastNameController,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      heightSpacer(15),
                      Text('Job Role', style: AppTextTheme.kLabelStyle),
                      CustomTextField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Job Role is required';
                          }
                          return null;
                        },
                        controller: _jobRoleController,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      heightSpacer(15),
                      Text('Email', style: AppTextTheme.kLabelStyle),
                      CustomTextField(
                        controller: _emailController,
                        inputKeyBoardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Invalid email address';
                          }
                          return null;
                        },
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      heightSpacer(15),
                      Text('Password', style: AppTextTheme.kLabelStyle),
                      CustomTextField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                        controller: _passwordController,
                        obscureText: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      heightSpacer(15),
                      Text('Phone Number', style: AppTextTheme.kLabelStyle),
                      CustomTextField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Phone Number is required';
                          }
                          // Simple phone validation
                          final phoneRegex = RegExp(r'^[0-9]{10,15}$');
                          if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[^0-9]'), ''))) {
                            return 'Enter valid phone number';
                          }
                          return null;
                        },
                        controller: _phoneNumberController,
                        inputKeyBoardType: TextInputType.phone,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      heightSpacer(40),
                      CustomButton(
                        buttonText: "Create Staff",
                        isLoading: _isLoading,
                        press: _createStaff,
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