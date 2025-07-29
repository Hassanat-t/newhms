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
    this.child,
  });
  final String? buttonText;
  final Color? buttonTextColor;
  final Function() press;
  final double? size;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFF2E8B57),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Center(
          child: child ?? Text(
            buttonText ?? " ",
            style: AppTextTheme.kLabelStyle.copyWith(
                color: buttonTextColor ?? AppColors.kLight,
                fontSize: size ?? 16),
          ),
        ),
      ),
    );
  }
}
