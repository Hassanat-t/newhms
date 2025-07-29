import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newhms/common/app_bar.dart';
import 'package:newhms/common/spacing.dart';
import 'package:newhms/features/auth/widgets/custom_button.dart';
import 'package:newhms/features/auth/widgets/custom_text_field.dart';
import 'package:newhms/theme/colors.dart';
import 'package:newhms/theme/text_theme.dart';

import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';
import '../../../models/user_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateStaff extends StatefulWidget {
  const CreateStaff({super.key});

  @override
  State<CreateStaff> createState() => _CreateStaffState();
}

class _CreateStaffState extends State<CreateStaff> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController jobRole = TextEditingController();

  bool _isLoading = false;

  Future<void> createStaffAccount(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text.trim(),
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(credential.user!.uid)
            .set({
          'username': userName.text.trim(),
          'firstName': firstName.text.trim(),
          'lastName': lastName.text.trim(),
          'jobRole': jobRole.text.trim(),
          'email': email.text.trim(),
          'phoneNumber': phoneNumber.text.trim(),
          'role': 'staff',
          'isActive': true,
          'createdAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Staff account created successfully'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Firebase Error: ${e.message ?? "Unknown error"}'),
            backgroundColor: Colors.red,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    userName.dispose();
    email.dispose();
    firstName.dispose();
    lastName.dispose();
    jobRole.dispose();
    phoneNumber.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserProvider>(context).user;
    // Restrict access if not admin
    // inner layered security
    if (user == null || user.role != 'admin') {
      return const Scaffold(
        body: Center(
          child: Text(
            'Access Denied: Admins Only',
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildAppBar(context, "Create Staff"),
      backgroundColor: AppColors.kBackgroundColor,
      body: SingleChildScrollView(
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
                    if (value!.isEmpty) {
                      return 'Username is required';
                    }
                    return null;
                  },
                  controller: userName,
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                      borderRadius: BorderRadius.circular(14)),
                ),
                heightSpacer(15),
                Text('First Name', style: AppTextTheme.kLabelStyle),
                CustomTextField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'First Name is required';
                    }
                    return null;
                  },
                  controller: firstName,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                heightSpacer(15),
                Text('Last Name', style: AppTextTheme.kLabelStyle),
                CustomTextField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Last Name is required';
                    }
                    return null;
                  },
                  controller: lastName,
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                      borderRadius: BorderRadius.circular(14)),
                ),
                heightSpacer(15),
                Text('Job Role', style: AppTextTheme.kLabelStyle),
                CustomTextField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Job Role is required';
                    }
                    return null;
                  },
                  controller: jobRole,
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                      borderRadius: BorderRadius.circular(14)),
                ),
                heightSpacer(15),
                Text('Email', style: AppTextTheme.kLabelStyle),
                CustomTextField(
                  controller: email,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Email is required';
                    } else if (!emailRegex.hasMatch(value)) {
                      return 'Invalid email address';
                    }
                    return null;
                  },
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                      borderRadius: BorderRadius.circular(14)),
                ),
                heightSpacer(15),
                Text('Password', style: AppTextTheme.kLabelStyle),
                CustomTextField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  },
                  controller: password,
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                      borderRadius: BorderRadius.circular(14)),
                ),
                heightSpacer(15),
                Text('Phone Number', style: AppTextTheme.kLabelStyle),
                CustomTextField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Phone Number is required';
                    }
                    return null;
                  },
                  controller: phoneNumber,
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                      borderRadius: BorderRadius.circular(14)),
                ),
                heightSpacer(40),
                CustomButton(
                  press: _isLoading
                      ? (){}
                      :
                  () => createStaffAccount(context)
                  ,
                  child: _isLoading
                      ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                    ) : const Text("Create Staff")
                ),
                heightSpacer(20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final emailRegex =
      RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)*(\.[a-z]{2,})$');
}
