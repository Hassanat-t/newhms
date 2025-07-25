import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newhms/common/custom_text.dart';
import 'package:newhms/common/spacing.dart';
import 'package:newhms/features/auth/screens/login_screen.dart';
import 'package:newhms/features/auth/widgets/custom_button.dart';
import 'package:newhms/features/home/home_screen.dart';
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

  bool _isLoading = false;

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

  Future<void> registerUser() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedBlock == null || selectedRoom == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a block and room number')),
      );
      return;
    }

    try {
      setState(() => _isLoading = true);

      // Register user with FirebaseAuth
      final authResult =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      // Save extra user data in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user!.uid)
          .set({
        'uid': authResult.user!.uid,
        'userName': userName.text.trim(),
        'firstName': firstName.text.trim(),
        'lastName': lastName.text.trim(),
        'email': email.text.trim(),
        'phoneNumber': phoneNumber.text.trim(),
        'block': selectedBlock,
        'roomNumber': selectedRoom,
        'role': 'student', // default role
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful')),
      );

      // Navigate to login screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    } catch (e) {
      debugPrint('Registration error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  controller: userName,
                  validator: (value) =>
                      value!.isEmpty ? 'Username is required' : null,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                heightSpacer(15),
                Text('First Name', style: AppTextTheme.kLabelStyle),
                CustomTextField(
                  controller: firstName,
                  validator: (value) =>
                      value!.isEmpty ? 'First Name is required' : null,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                heightSpacer(15),
                Text('Last Name', style: AppTextTheme.kLabelStyle),
                CustomTextField(
                  controller: lastName,
                  validator: (value) =>
                      value!.isEmpty ? 'Last Name is required' : null,
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
                  controller: password,
                  validator: (value) =>
                      value!.isEmpty ? 'Password is required' : null,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  obscureText: true,
                ),
                heightSpacer(15),
                Text('Phone Number', style: AppTextTheme.kLabelStyle),
                CustomTextField(
                  controller: phoneNumber,
                  validator: (value) =>
                      value!.isEmpty ? 'Phone Number is required' : null,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                heightSpacer(15),

                /// Block and Room Dropdown
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
                          Text('Block No.', style: TextStyle(fontSize: 17.sp)),
                          SizedBox(width: 8.w),
                          DropdownButton<String>(
                            value: selectedBlock,
                            hint: const Text('Select'),
                            onChanged: (val) {
                              setState(() {
                                selectedBlock = val;
                                selectedRoom = null;
                              });
                            },
                            items: blockOptions.map((block) {
                              return DropdownMenuItem(
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
                            Text('Room No.', style: TextStyle(fontSize: 17.sp)),
                            const SizedBox(width: 8),
                            DropdownButton<String>(
                              value: selectedRoom,
                              hint: const Text('Select'),
                              onChanged: (val) {
                                setState(() {
                                  selectedRoom = val;
                                });
                              },
                              items: (selectedBlock == 'A'
                                      ? roomOptionsA
                                      : roomOptionsB)
                                  .map((room) {
                                return DropdownMenuItem(
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
                  buttonText: _isLoading ? "Registering..." : "Register",
                  press: _isLoading ? null : () => const HomeScreen(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
