// lib/features/auth/screens/login_screen.dart
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newhms/common/spacing.dart';
import 'package:newhms/features/auth/screens/register_screen.dart';
import 'package:newhms/features/auth/widgets/custom_button.dart';
import 'package:newhms/features/auth/widgets/custom_text_field.dart';
import 'package:newhms/providers/auth_providers.dart';
// import 'package:newhms/features/home/home_screen.dart'; // Remove direct navigation import
import 'package:newhms/theme/colors.dart';
import 'package:newhms/theme/text_theme.dart';
import 'package:provider/provider.dart'; // Add provider import
//import 'package:newhms/providers/auth_provider.dart'; // Add your auth provider import

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
  const LoginBody({
    super.key,
  });

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  static final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // final FirebaseAuthService _authService = FirebaseAuthService(); // Remove this line
  // We will use the AuthProvider instead

  bool _isLoading = false;
  final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)*(\.[a-z]{2,})$');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Inside _LoginBodyState in login_screen.dart
Future<void> _handleLogin() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isLoading = true);

  try {
    // Use the AuthProvider for login
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final result = await authProvider.login( // <-- This 'login' method must exist in AuthProvider
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (result['success']) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login successful"),
            backgroundColor: Colors.green,
          ),
        );
        // Navigation is now handled by main.dart's Consumer/Wrapper based on authProvider.isAuthenticated
      }
    } else {
      _showError(result['message'] ?? "Login failed");
    }
  } on firebase_auth.FirebaseAuthException catch (e)  {
    // ... (your existing error handling)
  } catch (e) {
    // ... (your existing error handling)
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                controller: _emailController,
                inputKeyBoardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  } else if (!emailRegex.hasMatch(value)) {
                    return 'Invalid email address';
                  }
                  return null;
                },
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                    borderRadius: BorderRadius.circular(14)),
                inputHint: "Enter your email",
              ),
              heightSpacer(30),
              Text('Password', style: AppTextTheme.kLabelStyle),
              CustomTextField(
                controller: _passwordController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                    borderRadius: BorderRadius.circular(14)),
                inputHint: "Password",
              ),
              heightSpacer(30),
              CustomButton(
                buttonText: "Login",
                isLoading: _isLoading,
                press: _handleLogin,
              ),
              heightSpacer(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't have an account?",
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