import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newhms/theme/colors.dart';
import 'package:newhms/theme/text_theme.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.buttonText,
    this.buttonTextColor,
    required this.press,
    this.size,
    this.isLoading = false,
    this.backgroundColor,
  });

  final String? buttonText;
  final Color? buttonTextColor;
  final Function()? press;
  final double? size;
  final bool isLoading;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : press, // Disable tap when loading
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: isLoading
              ? (backgroundColor ?? const Color(0xFF2E8B57)).withOpacity(0.5) // Dim color when loading
              : (backgroundColor ?? const Color(0xFF2E8B57)),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  height: 20.h,
                  width: 20.w,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      buttonTextColor ?? AppColors.kLight,
                    ),
                    strokeWidth: 2.0,
                  ),
                )
              : Text(
                  buttonText ?? " ",
                  style: AppTextTheme.kLabelStyle.copyWith(
                    color: buttonTextColor ?? AppColors.kLight,
                    fontSize: size ?? 16.sp, // Ensure fontSize is responsive
                    fontWeight: FontWeight.bold, // Make text bold
                  ),
                ),
        ),
      ),
    );
  }
}