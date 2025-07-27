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

class ProfileScreen extends StatefulWidget {
  // Make the constructor parameterless
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Dummy values for user details
  final String _dummyRoomNumber = "A101";
  final String _dummyBlockNumber = "Block A";
  final String _dummyUsername = "johndoe";
  final String _dummyEmailId = "johndoe@example.com";
  final String _dummyPhoneNumber = "123-456-7890";
  final String _dummyFirstName = "John";
  final String _dummyLastName = "Doe";

  // Controllers for the editable text fields
  late TextEditingController usernameController;
  late TextEditingController phoneNumberController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the dummy values
    usernameController = TextEditingController(text: _dummyUsername);
    phoneNumberController = TextEditingController(text: _dummyPhoneNumber);
    firstNameController = TextEditingController(text: _dummyFirstName);
    lastNameController = TextEditingController(text: _dummyLastName);
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

  @override
  Widget build(BuildContext context) {
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
                '$_dummyFirstName $_dummyLastName',
                style: const TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              heightSpacer(30),
              // --- Room and Block Info (Read-only using dummy values) ---
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
                        'Room No - $_dummyRoomNumber',
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
                        'Block No - $_dummyBlockNumber',
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
                        _dummyEmailId,
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
                inputHint: _dummyUsername,
                prefixIcon: const Icon(Icons.person_2_outlined),
              ),
              heightSpacer(20),
              CustomTextField(
                controller: phoneNumberController,
                inputHint: _dummyPhoneNumber,
                prefixIcon: const Icon(Icons.phone_outlined),
              ),
              heightSpacer(20),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: firstNameController,
                      inputHint: _dummyFirstName,
                    ),
                  ),
                  widthSpacer(20),
                  Expanded(
                    child: CustomTextField(
                      controller: lastNameController,
                      inputHint: _dummyLastName,
                    ),
                  ),
                ],
              ),
              heightSpacer(40),
              // --- Save Button ---
              CustomButton(
                press: () {
                  // Placeholder action - show a SnackBar with current field values
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Profile save simulated.\n'
                          'Username: ${usernameController.text}\n'
                          'First: ${firstNameController.text}, Last: ${lastNameController.text}\n'
                          'Phone: ${phoneNumberController.text}',
                        ),
                      ),
                    );
                  }
                  // TODO: Implement actual profile saving logic (e.g., API call) here
                },
                buttonText: 'Save',
              )
            ],
          ),
        ),
      ),
    );
  }
}
