import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newhms/common/constants.dart';
import 'package:newhms/common/spacing.dart';
import 'package:newhms/features/auth/screens/login_screen.dart';
import 'package:newhms/features/auth/widgets/custom_button.dart';
import 'package:newhms/features/auth/widgets/custom_text_field.dart';
import 'package:newhms/theme/colors.dart';
import 'package:newhms/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:newhms/models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  // Make the constructor parameterless
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Controllers for the editable text fields
  late TextEditingController usernameController;
  late TextEditingController phoneNumberController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;

  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();

    // Delay to allow context to be ready for Provider
    Future.delayed(Duration.zero, () {
      final user = Provider.of<UserProvider>(context, listen: false).user;

      setState(() {
        usernameController = TextEditingController(text: user?.username ?? '');
        phoneNumberController = TextEditingController(text: user?.phoneNumber ?? '');
        firstNameController = TextEditingController(text: user?.firstName ?? '');
        lastNameController = TextEditingController(text: user?.lastName ?? '');
      });
    });
  }


  @override
  void dispose() {
    // Dispose of the controllers to prevent memory leaks
    usernameController.dispose();
    phoneNumberController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdateProfile(BuildContext context) async {
    setState(() {
      _isUpdating = true;
    });
    try {
      final provider = Provider.of<UserProvider>(context, listen: false);
      final user = provider.user!;

      await provider.updateUserProfile(
        username: usernameController.text.trim(),
        phone: phoneNumberController.text.trim(),
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final isStudent = user.role.toLowerCase() == 'student';

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
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppConstants.profile,
                height: 180.h,
                width: 180.w,
              ),
              heightSpacer(10),
              // Use dummy first and last name for display
              Text(
                '${user.firstName} ${user.lastName}',
                style: const TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              heightSpacer(30),
              if (isStudent)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1,
                            color: Color(0xFF2E8B57),
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Room No - {user.room}',
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
                            width: 1,
                            color: Color(0xFF2E8B57),
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Block No - ${user.block}',
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
              if (isStudent) heightSpacer(20),
              // --- Email Info (Read-only using dummy value) ---
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1,
                            color: Color(0xFF2E8B57),
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        user.email,
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
              // --- Editable Fields (initialized with dummy values) ---
              CustomTextField(
                controller: usernameController,
                inputHint: user.username,
                prefixIcon: const Icon(Icons.person_2_outlined),
              ),
              heightSpacer(20),
              CustomTextField(
                controller: phoneNumberController,
                inputHint: user.phoneNumber,
                prefixIcon: const Icon(Icons.phone_outlined),
              ),
              heightSpacer(20),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: firstNameController,
                      inputHint: user.firstName,
                    ),
                  ),
                  widthSpacer(20),
                  Expanded(
                    child: CustomTextField(
                      controller: lastNameController,
                      inputHint: user.lastName,
                    ),
                  ),
                ],
              ),
              heightSpacer(40),
              // --- Save Button ---
              CustomButton(
                press:_isUpdating ? (){} : () => _handleUpdateProfile(context),
                child: _isUpdating
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Text('Update Profile')
              )
            ],
          ),
        ),
      ),
    );
  }
}
