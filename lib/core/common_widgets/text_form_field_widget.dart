import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFormFieldWidget extends StatelessWidget {
  final String hintText;
  final double? width;
  final double? height;

  final TextEditingController? controller;
  final FormFieldValidator? validator;

  final double? fontSize;
  final FontWeight? fontWeight;

  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType? textInputType;
  final bool? isObscureText;

  const TextFormFieldWidget({
    super.key,
    required this.hintText,
    this.width,
    this.height,
    this.controller,
    this.validator,
    this.fontSize,
    this.fontWeight,
    this.suffixIcon,
    this.prefixIcon,
    this.textInputType,
    this.isObscureText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        style: GoogleFonts.comfortaa(color: Colors.black, fontSize: 14.sp),
        keyboardType: textInputType,
        controller: controller,
        validator: validator,
        autofocus: false,
        cursorColor: Colors.black,
        obscureText: isObscureText ?? false,

        decoration: InputDecoration(
          fillColor: Colors.white,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 14.h,
          ),

          labelText: hintText,
          labelStyle: GoogleFonts.comfortaa(
            color: Colors.black,
            fontSize: fontSize ?? 12.sp,
            fontWeight: fontWeight ?? FontWeight.w400,
          ),

          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: Color(0xffBBB7B5), width: 1.w),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: Colors.black, width: 1.w),
          ),

          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: Colors.red, width: 1.w),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: Colors.red, width: 1.w),
          ),
        ),
      ),
    );
  }
}
