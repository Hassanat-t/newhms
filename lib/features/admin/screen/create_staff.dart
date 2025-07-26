// lib/features/admin/screen/create_staff.dart
//import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Remove the old staff service import
// import 'package:newhms/services/staff_services.dart';
import 'package:newhms/common/app_bar.dart'; // Assuming this file exists
import 'package:newhms/common/spacing.dart';
import 'package:newhms/features/auth/widgets/custom_button.dart';
import 'package:newhms/features/auth/widgets/custom_text_field.dart';
import 'package:newhms/providers/auth_providers.dart';
import 'package:newhms/theme/colors.dart';
import 'package:newhms/theme/text_theme.dart';
import 'package:provider/provider.dart'; // Import provider
//import 'package:newhms/providers/auth_provider.dart'; // Import your AuthProvider

class CreateStaff extends StatefulWidget {
  const CreateStaff({super.key});

  @override
  State<CreateStaff> createState() => _CreateStaffState();
}

class _CreateStaffState extends State<CreateStaff> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Remove the old staff service instance
  // final StaffService _staffService = StaffService();
  // Controllers
  final TextEditingController _userNameController =
      TextEditingController(); // Can be used as staffId
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _jobRoleController =
      TextEditingController(); // Can be used as position
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
      // Use AuthProvider to register the staff member
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final result = await authProvider.registerStaff(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        name:
            '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}',
        staffId: _userNameController.text.trim(), // Map username to staffId
        position: _jobRoleController.text.trim(), // Map jobRole to position
        phoneNumber: _phoneNumberController.text.trim(),
      );

      if (result['success']) {
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
          // Optionally navigate back or show success message
          // Navigator.pop(context); // Or stay on page
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Failed to create staff'),
              backgroundColor: Colors.red,
            ),
          );
        }
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
    // Get the AuthProvider instance to check user role
    final authProvider = Provider.of<AuthProvider>(context);

    // Check if the current user is an Admin
    // This replaces the simple FirebaseAuth check
    bool hasPermission = authProvider.isAdmin;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar:
          buildAppBar(context, "Create Staff"), // Assuming buildAppBar exists
      backgroundColor: AppColors.kBackgroundColor,
      body: !hasPermission
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Access Denied: Only administrators can create staff members.",
                  style: TextStyle(fontSize: 18, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Username (Staff ID)',
                          style: AppTextTheme
                              .kLabelStyle), // Clarify field purpose
                      CustomTextField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Username/Staff ID is required';
                          }
                          if (value.length < 3) {
                            return 'Username must be at least 3 characters';
                          }
                          return null;
                        },
                        controller: _userNameController,
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFFD1D8FF)),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        inputHint: "Enter unique staff ID",
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
                          borderSide:
                              const BorderSide(color: Color(0xFFD1D8FF)),
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
                          borderSide:
                              const BorderSide(color: Color(0xFFD1D8FF)),
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      heightSpacer(15),
                      Text('Job Role/Position',
                          style: AppTextTheme
                              .kLabelStyle), // Clarify field purpose
                      CustomTextField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Job Role/Position is required';
                          }
                          return null;
                        },
                        controller: _jobRoleController,
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFFD1D8FF)),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        inputHint: "e.g., Warden, Cleaner, Security",
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
                          final emailRegex =
                              RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Invalid email address';
                          }
                          return null;
                        },
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFFD1D8FF)),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        inputHint: "staff@example.com",
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
                          borderSide:
                              const BorderSide(color: Color(0xFFD1D8FF)),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        inputHint: "Minimum 6 characters",
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
                          if (!phoneRegex.hasMatch(
                              value.replaceAll(RegExp(r'[^0-9]'), ''))) {
                            return 'Enter valid phone number (10-15 digits)';
                          }
                          return null;
                        },
                        controller: _phoneNumberController,
                        inputKeyBoardType: TextInputType.phone,
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFFD1D8FF)),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        inputHint: "e.g., 1234567890",
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
