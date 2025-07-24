import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newhms/common/custom_text.dart';
import 'package:newhms/common/spacing.dart';
import 'package:newhms/features/auth/screens/login_screen.dart';
import 'package:newhms/features/auth/widgets/custom_button.dart';
import 'package:newhms/theme/colors.dart';

import 'package:newhms/theme/text_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController userName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();

  String? selectedBlock;
  String? selectedRoom;

  final List<String> blockOptions = ['A', 'B'];
  final List<String> roomOptionsA = ['101', '102', '103'];
  final List<String> roomOptionsB = ['201', '202', '203'];

  final emailRegex =
      RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)*(\.[a-z]{2,})$');

  @override
  void dispose() {
    userName.dispose();
    email.dispose();
    firstName.dispose();
    lastName.dispose();
    phoneNumber.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.kBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          child: Form(
            key: _formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              heightSpacer(80),
              Center(
                child: Image.asset(
                  'assets/logo.jpg',
                  width: 150.w,
                  height: 150.h,
                ),
              ),
              heightSpacer(30),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Register your account',
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              heightSpacer(25),
              Text('Username', style: AppTextTheme.kLabelStyle),
              CustomTextField(
                validator: (value) =>
                    value!.isEmpty ? 'Username is required' : null,
                controller: userName,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              heightSpacer(15),
              Text('First Name', style: AppTextTheme.kLabelStyle),
              CustomTextField(
                validator: (value) =>
                    value!.isEmpty ? 'First Name is required' : null,
                controller: firstName,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              heightSpacer(15),
              Text('Last Name', style: AppTextTheme.kLabelStyle),
              CustomTextField(
                validator: (value) =>
                    value!.isEmpty ? 'Last Name is required' : null,
                controller: lastName,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              heightSpacer(15),
              Text('Email', style: AppTextTheme.kLabelStyle),
              CustomTextField(
                controller: email,
                validator: (value) {
                  if (value!.isEmpty) return 'Email is required';
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
                validator: (value) =>
                    value!.isEmpty ? 'Password is required' : null,
                controller: password,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              heightSpacer(15),
              Text('Phone Number', style: AppTextTheme.kLabelStyle),
              CustomTextField(
                validator: (value) =>
                    value!.isEmpty ? 'Phone Number is required' : null,
                controller: phoneNumber,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              heightSpacer(15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 50.h,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            width: 1, color: Color(0xFF2E8B57)),
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        widthSpacer(20),
                        Text(
                          'Block No.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF333333),
                            fontSize: 17.sp,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        DropdownButton<String>(
                          value: selectedBlock,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedBlock = newValue;
                              selectedRoom = null;
                            });
                          },
                          items: blockOptions.map((String block) {
                            return DropdownMenuItem<String>(
                              value: block,
                              child: Text(block),
                            );
                          }).toList(),
                        ),
                        widthSpacer(20),
                      ],
                    ),
                  ),
                  widthSpacer(20),
                  Expanded(
                    child: Container(
                      height: 50.h,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              width: 1, color: Color(0xFF2E8B57)),
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Room No.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF333333),
                              fontSize: 17.sp,
                            ),
                          ),
                          const SizedBox(width: 8),
                          DropdownButton<String>(
                            value: selectedRoom,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedRoom = newValue;
                              });
                            },
                            items: (selectedBlock == 'A'
                                    ? roomOptionsA
                                    : roomOptionsB)
                                .map((String room) {
                              return DropdownMenuItem<String>(
                                value: room,
                                child: Text(room),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              heightSpacer(40),
              CustomButton(
                  buttonText: "Register",
                  press: () async {
                    if (_formKey.currentState!.validate()) {
                      if (selectedBlock == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Please select a block and room number')),
                        );
                        return;
                      }
                      try {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) =>
                              const Center(child: CircularProgressIndicator()),
                        );
                        // Register user in Firebase Auth
                        final authResult = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: email.text.trim(),
                          password: password.text.trim(),
                        );

                        // Save user info in Firestore
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(authResult.user!.uid)
                            .set({
                          'uid': authResult.user!.uid,
                          'userName': userName.text.trim(),
                          'email': email.text.trim(),
                          'firstName': firstName.text.trim(),
                          'lastName': lastName.text.trim(),
                          'phoneNumber': phoneNumber.text.trim(),
                          'block': selectedBlock,
                          'roomNumber': selectedRoom,
                          'role': 'student',
                          'createdAt': Timestamp.now(),
                        });

                        Navigator.of(context).pop(); // Close loading dialog

                        // Navigate or show success
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Registration successful')),
                        );
                        // ✅ Navigate to Login Screen
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      } on FirebaseAuthException catch (e) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text(e.message ?? 'Registration failed')),
                        );
                      } catch (e) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('An error occurred')),
                        );
                        debugPrint(e.toString());
                      }
                    }
                  }),
            ]),
          ),
        ),
      ),
    );
  }
}
