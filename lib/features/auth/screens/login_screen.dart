//import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:newhms/common/app_bar.dart';
import 'package:newhms/common/constants.dart';
import 'package:newhms/common/spacing.dart';
import 'package:newhms/features/auth/screens/register_screen.dart';
import 'package:newhms/features/auth/widgets/custom_button.dart';
import 'package:newhms/features/auth/widgets/custom_text_field.dart';
import 'package:newhms/features/home/home_screen.dart';
import 'package:newhms/theme/colors.dart';
import 'package:newhms/theme/text_theme.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';
import '../../../models/user_model.dart';


//import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool _isLoggingIn = false;

  Future<void> loginUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoggingIn = true;
      });

      try {
        // Sign in with Firebase Auth
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: email.text.trim(), password: password.text.trim());

        User? user = userCredential.user;


        if (user != null) {
          // Get user role from Firestore
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          if (userDoc.exists) {
            String role = userDoc.get('role');

            // Get the data
            var data = userDoc.data() as Map<String, dynamic>;
            // set the model
            UserModel userModel = UserModel.fromMap(data, user.uid);

            // Set Provider
            Provider.of<UserProvider>(context, listen: false).setUser(userModel);

            // Clear the form fields
            email.clear();
            password.clear();

            // Navigate with role
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("User record not found in Firestore")),
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "Login failed")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Something went wrong")),
        );
      } finally {
        setState(() {
          _isLoggingIn = false;
        });
      }
    }
  }


  @override
  void dispose() {
    // TODO: implement dispose
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      AppConstants.logo,
                      height: 250.h,
                    ),
                  ),
                  heightSpacer(20),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Login to your account",
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Color(0xff333333),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  heightSpacer(25),
                  Text(
                    "Email",
                    style: AppTextTheme.kLabelStyle,
                  ),
                  heightSpacer(15),
                  CustomTextField(
                    controller: email,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffd1d8ff),
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    inputHint: "Enter your Email ",
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Email is required";
                      }
                      return null;
                    },
                  ),
                  heightSpacer(20),
                  Text(
                    "Password",
                    style: AppTextTheme.kLabelStyle,
                  ),
                  heightSpacer(15),
                  CustomTextField(
                    controller: password,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffd1d8ff)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    inputHint: "Enter your password ",
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Passwordid required";
                      }
                      return null;
                    },
                  ),
                  heightSpacer(30),
                  CustomButton(
                    buttonTextColor: Colors.white,
                    size: 16,
                      press: _isLoggingIn
                          ? (){}
                          :
                        loginUser
                      ,
                      child: _isLoggingIn
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Text("Login")
                  ),
                  heightSpacer(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Didn't have an account?"),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Register",
                          style: AppTextTheme.kLabelStyle.copyWith(
                            fontSize: 14.sp,
                            color: AppColors.kGreenColor,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}
