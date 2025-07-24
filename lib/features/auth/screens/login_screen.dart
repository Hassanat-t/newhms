import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newhms/common/custom_text.dart';
import 'package:newhms/common/spacing.dart';
import 'package:newhms/features/auth/screens/register_screen.dart';
import 'package:newhms/features/auth/widgets/custom_button.dart';
import 'package:newhms/features/home/home_screen.dart';
import 'package:newhms/theme/colors.dart';
import 'package:newhms/theme/text_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Center(child: LoginBody()),
    );
  }
}

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  static final _formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/logo.jpg',
                  height: 250.h,
                ),
              ),
              heightSpacer(30.h),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Login to your account',
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              heightSpacer(25.h),
              Text('Email', style: AppTextTheme.kLabelStyle),
              CustomTextField(
                controller: email,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Email is required';
                  }
                  return null;
                },
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                  borderRadius: BorderRadius.circular(14),
                ),
                inputHint: "Enter your email",
              ),
              heightSpacer(30),
              Text('Password', style: AppTextTheme.kLabelStyle),
              CustomTextField(
                controller: password,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Password is required';
                  }
                  return null;
                },
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                  borderRadius: BorderRadius.circular(14),
                ),
                inputHint: "Password",
              ),
              heightSpacer(30),
              CustomButton(
                buttonText: "Login",
                press: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) =>
                            const Center(child: CircularProgressIndicator()),
                      );

                      final authResult = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                        email: email.text.trim(),
                        password: password.text.trim(),
                      );

                      final uid = authResult.user!.uid;
                      final userDoc = await FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .get();

                      Navigator.of(context).pop(); // close loading

                      if (!userDoc.exists) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('User data not found')),
                        );
                        return;
                      }

                      // Navigate to dashboard
                      Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );

                    } on FirebaseAuthException catch (e) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.message ?? 'Login failed')),
                      );
                    } catch (e) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('An error occurred')),
                      );
                    }
                  }
                },
              ),
              heightSpacer(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn’t have an account?",
                    style: AppTextTheme.kLabelStyle.copyWith(
                      color: AppColors.kGreyDk,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: Text(
                      " Register",
                      style: AppTextTheme.kLabelStyle.copyWith(
                        color: AppColors.kGreenColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
