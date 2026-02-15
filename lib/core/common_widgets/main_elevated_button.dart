import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainElevatedButton extends StatelessWidget {
  final String textOnButton;
  final double? textFontSize;
  final FontWeight? textFontWeight;
  final Function? onButtonTap;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Color? textColor;

  const MainElevatedButton({
    super.key,
    required this.textOnButton,
    this.textFontSize,
    this.textFontWeight,
    this.onButtonTap,
    this.width,
    this.height,
    this.borderRadius,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onButtonTap as Function()?,

      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff0064AF),

        minimumSize: Size(width ?? 212.w, height ?? 43.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 10.r),
        ),
      ),
      child: Text(
        textOnButton,
        style: TextStyle(
          color: textColor ?? Theme.of(context).colorScheme.onSurface,
          fontSize: textFontSize ?? 20.sp,
          fontWeight: textFontWeight ?? FontWeight.w600,
        ),
      ),
    );
  }
}
