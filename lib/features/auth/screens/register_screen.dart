import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newhms/common/constants.dart';
import 'package:newhms/common/spacing.dart';
import 'package:newhms/features/auth/widgets/custom_button.dart';
import 'package:newhms/features/auth/widgets/custom_text_field.dart';
//import 'package:newhms/features/home/home_screen.dart';
import 'package:newhms/theme/colors.dart';
import 'package:newhms/theme/text_theme.dart';

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

  List<String> blockOptions = ['A', 'B'];
  List<String> roomOptionsA = ['101', '102', '103'];
  List<String> roomOptionsB = ['201', '202', '203'];
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
                    "Last Naame",
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
                    controller: email,
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
                  Row(
                    children: [
                      Container(
                        height: 50.h,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: Color(0xff2e8b57),
                            ),
                            borderRadius: BorderRadius.circular(14.r),
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
                      )
                    ],
                  ),
                  heightSpacer(25),
                  CustomButton(
                    buttonText: 'Register',
                    press: () {
                      print(selectedBlock);
                      print(selectedRoom);
                      if (_formKey.currentState!.validate()) {}
                     
                    },
                  ),
                  heightSpacer(10)
                ],
              )),
        ),
      ),
    );
  }
}
