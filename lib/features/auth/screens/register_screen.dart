import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newhms/common/constants.dart';
import 'package:newhms/common/spacing.dart';
import 'package:newhms/features/auth/widgets/custom_button.dart';
import 'package:newhms/features/auth/widgets/custom_text_field.dart';
import 'package:newhms/features/home/home_screen.dart';
//import 'package:newhms/features/home/home_screen.dart';
import 'package:newhms/theme/colors.dart';
import 'package:newhms/theme/text_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';
import '../../../models/user_model.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

  String? selectedBlock;
  String? selectedRoom;
  bool _isLoading = false;

  List<String> blockOptions = ['Bowlsant1', 'Bowlsant2'];
  List<String> roomOptionsA = ['101', '102', '103'];
  List<String> roomOptionsB = ['201', '202', '203'];


  // Utility method to generate rooms options
  List<String> _generateRooms(int count, String prefix) {
    return List.generate(count, (i) => '$prefix${(i + 1).toString().padLeft(2, '0')}');
  }

  List<String> get roomOptions {
    if (selectedBlock == 'Bowlsant1') {
      return _generateRooms(33, 'B1-'); // B1-01 to B1-33
    } else if (selectedBlock == 'Bowlsant2') {
      return _generateRooms(30, 'B2-'); // B2-01 to B2-30
    }
    return [];
  }


  @override
  void dispose() {
    // TODO: implement dispose
    email.dispose();
    password.dispose();
    username.dispose();
    firstName.dispose();
    lastName.dispose();
    phoneNumber.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      if (selectedBlock == null || selectedRoom == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please select both block and room")),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text.trim(),
        );

        User? user = userCredential.user;

        if (user != null) {
          try {
            await FirebaseFirestore.instance.collection('users')
                .doc(user.uid)
                .set({
              'uid': user.uid,
              'username': username.text.trim(),
              'firstName': firstName.text.trim(),
              'lastName': lastName.text.trim(),
              'email': email.text.trim(),
              'phone': phoneNumber.text.trim(),
              'role': 'student',
              'isActive': true,
              'block': selectedBlock,
              'room': selectedRoom,
              'createdAt': FieldValue.serverTimestamp(),
            });

            UserModel userModel = UserModel(
              uid: user.uid,
              username: username.text.trim(),
              firstName: firstName.text.trim(),
              lastName: lastName.text.trim(),
              email: email.text.trim(),
              role: 'student',
              isActive: true,
              block: selectedBlock,
              room: selectedRoom,
            );

            Provider.of<UserProvider>(context, listen: false).setUser(userModel);

            // Navigate or show success
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Registration successful!")),
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomeScreen()),
            );
          } catch (firestoreError) {
            // Firestore write failed: delete auth user to rollback
            await user.delete();
            throw Exception("Failed to store user data. Please try again.");
          }
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "Registration failed")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Something went wrong")),
        );
      }
      finally{
        setState(() {
          _isLoading = false;
        });
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      AppConstants.logo,
                      height: 150.h,
                      width: 150.w,
                    ),
                  ),
                  heightSpacer(20),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Register your account',
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Color(0xff333333),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  heightSpacer(25),
                  Text(
                    "Username",
                    style: AppTextTheme.kLabelStyle,
                  ),
                  CustomTextField(
                    controller: username,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffd1d8ff),
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    inputHint: "Enter your Username ",
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Username is required";
                      }
                      return null;
                    },
                  ),
                  heightSpacer(15),
                  Text(
                    "First Name",
                    style: AppTextTheme.kLabelStyle,
                  ),
                  CustomTextField(
                    controller: firstName,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffd1d8ff),
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    inputHint: "Enter your First Name ",
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "First Name is required";
                      }
                      return null;
                    },
                  ),
                  heightSpacer(15),
                  Text(
                    "Last Name",
                    style: AppTextTheme.kLabelStyle,
                  ),
                  CustomTextField(
                    controller: lastName,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffd1d8ff),
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    inputHint: "Enter your Last Name ",
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Last Name is required";
                      }
                      return null;
                    },
                  ),
                  heightSpacer(15),
                  Text(
                    "Email",
                    style: AppTextTheme.kLabelStyle,
                  ),
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
                  heightSpacer(15),
                  Text(
                    "Password",
                    style: AppTextTheme.kLabelStyle,
                  ),
                  CustomTextField(
                    obscureText: true,
                    controller: password,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffd1d8ff),
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    inputHint: "Enter your Password ",
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Password is required";
                      }
                      return null;
                    },
                  ),
                  heightSpacer(15),
                  Text(
                    "Phone Number",
                    style: AppTextTheme.kLabelStyle,
                  ),
                  CustomTextField(
                    controller: phoneNumber,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffd1d8ff),
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    inputHint: "Enter your Phone Number ",
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Phone Number is required";
                      }
                      return null;
                    },
                  ),
                  heightSpacer(15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 50.h,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: const Color(0xff2e8b57),
                            ),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            widthSpacer(20),
                            Text(
                              'Bowlsant -',
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
                      if (selectedBlock != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            selectedBlock == 'Bowlsant1'
                                ? 'Each room accommodates 3 people'
                                : 'Each room accommodates 2 people',
                            style: TextStyle(fontSize: 14.sp, color: Colors.green[700]),
                          ),
                        ),
                      heightSpacer(10),
                      Container(
                        height: 50.h,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(width: 1, color: Color(0xFF2E8B57)),
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
                              items: roomOptions.map((String room) {
                                return DropdownMenuItem<String>(
                                  value: room,
                                  child: Text(room),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  heightSpacer(25),

                  CustomButton(
                    press: _isLoading ? (){} : _registerUser,
                    child: _isLoading
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Text("Register", style: TextStyle(color: Colors.white))
                  ),
                  heightSpacer(10)
                ],
              )),
        ),
      ),
    );
  }
}
