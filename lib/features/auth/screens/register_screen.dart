
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newhms/common/spacing.dart';
import 'package:newhms/features/auth/widgets/custom_button.dart';
import 'package:newhms/features/auth/widgets/custom_text_field.dart';
import 'package:newhms/services/student_service.dart';
import 'package:newhms/theme/colors.dart';
import 'package:newhms/theme/text_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  final StudentService _studentService = StudentService();

  String? _validationMessage;
  String? _selectedBlock;
  String? _selectedRoom;

  final List<String> _blockOptions = ['A', 'B'];
  final List<String> _roomOptionsA = ['101', '102', '103'];
  final List<String> _roomOptionsB = ['201', '202', '203'];

  bool _isLoading = false;

  final emailRegex =
      RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)*(\.[a-z]{2,})$');

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _registerStudent() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedBlock == null || _selectedRoom == null) {
      setState(() {
        _validationMessage = 'Please select both block and room.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _validationMessage = null;
    });

    try {
      await _studentService.registerStudent(
        username: _userNameController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        phoneNumber: _phoneNumberController.text.trim(),
        block: _selectedBlock!,
        roomNumber: _selectedRoom!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful'),
            backgroundColor: Colors.green,
          ),
        );

        // Clear form
        _formKey.currentState?.reset();
        _clearControllers();
        setState(() {
          _selectedBlock = null;
          _selectedRoom = null;
        });

        // Optionally navigate back to login
        // Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception:', '').trim()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _clearControllers() {
    _userNameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _firstNameController.clear();
    _lastNameController.clear();
    _phoneNumberController.clear();
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username is required';
                    }
                    if (value.length < 3) {
                      return 'Username must be at least 3 characters';
                    }
                    return null;
                  },
                  controller: _userNameController,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                heightSpacer(15),
                Text('First Name', style: AppTextTheme.kLabelStyle),
                CustomTextField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'First Name is required';
                    }
                    return null;
                  },
                  controller: _firstNameController,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                heightSpacer(15),
                Text('Last Name', style: AppTextTheme.kLabelStyle),
                CustomTextField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Last Name is required';
                    }
                    return null;
                  },
                  controller: _lastNameController,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                heightSpacer(15),
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
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                heightSpacer(15),
                Text('Password', style: AppTextTheme.kLabelStyle),
                CustomTextField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  controller: _passwordController,
                  obscureText: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                heightSpacer(15),
                Text('Phone Number', style: AppTextTheme.kLabelStyle),
                CustomTextField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone Number is required';
                    }
                    // Simple phone validation
                    final phoneRegex = RegExp(r'^[0-9]{10,15}$');
                    if (!phoneRegex
                        .hasMatch(value.replaceAll(RegExp(r'[^0-9]'), ''))) {
                      return 'Enter valid phone number';
                    }
                    return null;
                  },
                  controller: _phoneNumberController,
                  inputKeyBoardType: TextInputType.phone,
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
                            value: _selectedBlock,
                            hint: const Text('Select'),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedBlock = newValue;
                                _selectedRoom = null;
                              });
                            },
                            items: _blockOptions.map((String block) {
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
                              value: _selectedRoom,
                              hint: const Text('Select'),
                              onChanged: _selectedBlock == null
                                  ? null
                                  : (String? newValue) {
                                      setState(() {
                                        _selectedRoom = newValue;
                                      });
                                    },
                              items: (_selectedBlock == 'A'
                                      ? _roomOptionsA
                                      : _selectedBlock == 'B'
                                          ? _roomOptionsB
                                          : [])
                                  .map<DropdownMenuItem<String>>((room) {
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
                if (_validationMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _validationMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                heightSpacer(40),
                CustomButton(
                  buttonText: "Register",
                  isLoading: _isLoading,
                  press: _registerStudent,
                ),
                heightSpacer(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
