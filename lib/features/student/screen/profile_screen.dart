import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newhms/common/constants.dart';
import 'package:newhms/common/spacing.dart';
import 'package:newhms/features/auth/screens/login_screen.dart';
import 'package:newhms/features/auth/widgets/custom_button.dart';
import 'package:newhms/features/auth/widgets/custom_text_field.dart';
import 'package:newhms/services/firebase_profile_service.dart';
import 'package:newhms/theme/colors.dart';
import 'package:newhms/theme/text_theme.dart';

class ProfileScreen extends StatefulWidget {
  final String roomNumber;
  final String blockNumber;
  final String username;
  final String emailId;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  
  const ProfileScreen({
    super.key,
    required this.roomNumber,
    required this.blockNumber,
    required this.username,
    required this.emailId,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseProfileService _profileService = FirebaseProfileService();
  
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with widget values
    _usernameController.text = widget.username;
    _phoneNumberController.text = widget.phoneNumber;
    _firstNameController.text = widget.firstName;
    _lastNameController.text = widget.lastName;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneNumberController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      await _profileService.updateStudentProfile(
        userId: user.uid,
        username: _usernameController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phoneNumber: _phoneNumberController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: ${e.toString().replaceAll('Exception:', '').trim()}'),
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

  Future<void> _signOut() async {
    try {
      await _profileService.signOut();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to sign out: ${e.toString().replaceAll('Exception:', '').trim()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get user role (simplified - in a real app you'd fetch this from Firestore)
    final user = FirebaseAuth.instance.currentUser;
    final roleId = user != null ? 2 : 3; // Simplified role assignment

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kGreenColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            CupertinoIcons.back,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Profile",
          style: AppTextTheme.kLabelStyle.copyWith(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: InkWell(
              onTap: _signOut,
              child: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: roleId == 1 // Admin
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        AppConstants.profile,
                        height: 180.h,
                        width: 180.w,
                      ),
                    ),
                    heightSpacer(20),
                    const Text(
                      'You are an Admin',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppConstants.profile,
                      height: 180.h,
                      width: 180.w,
                    ),
                    heightSpacer(10),
                    Text(
                      '${widget.firstName} ${widget.lastName}',
                      style: const TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    heightSpacer(30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 1, color: Color(0xFF2E8B57)),
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              'Room No - ${widget.roomNumber}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFF333333),
                                fontSize: 17.sp,
                              ),
                            ),
                          ),
                        ),
                        widthSpacer(30),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 1, color: Color(0xFF2E8B57)),
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              'Block No - ${widget.blockNumber}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFF333333),
                                fontSize: 17.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    heightSpacer(20),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 1, color: Color(0xFF2E8B57)),
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              widget.emailId,
                              style: TextStyle(
                                color: AppColors.kSecondaryColor,
                                fontSize: 17.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    heightSpacer(20),
                    CustomTextField(
                      controller: _usernameController,
                      inputHint: widget.username,
                      prefixIcon: const Icon(Icons.person_2_outlined),
                    ),
                    heightSpacer(20),
                    CustomTextField(
                      controller: _phoneNumberController,
                      inputHint: widget.phoneNumber,
                      prefixIcon: const Icon(Icons.phone_outlined),
                      inputKeyBoardType: TextInputType.phone,
                    ),
                    heightSpacer(20),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _firstNameController,
                            inputHint: widget.firstName,
                          ),
                        ),
                        widthSpacer(20),
                        Expanded(
                          child: CustomTextField(
                            controller: _lastNameController,
                            inputHint: widget.lastName,
                          ),
                        ),
                      ],
                    ),
                    heightSpacer(40),
                    CustomButton(
                      press: _updateProfile,
                      buttonText: 'Save',
                      isLoading: _isLoading,
                    )
                  ],
                ),
        ),
      ),
    );
  }
}