import 'package:app/core/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyle {
  static TextStyle headerTitle22bold = AppFonts.inter.copyWith(
    fontSize: 22.sp,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );

  static TextStyle headerTitle20Regular = GoogleFonts.comfortaa(
    fontSize: 20.sp,
    fontWeight: FontWeight.w400,
    color: const Color(0xffE3DFDB),
    fontStyle: FontStyle.normal,
  );

  static TextStyle headerTitle14SimiBold = GoogleFonts.comfortaa(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static TextStyle headerTitle40Bold = GoogleFonts.comfortaa(
    fontSize: 40.sp,
    fontWeight: FontWeight.w700,
    color: const Color(0xffFAFAF9),
    fontStyle: FontStyle.normal,
  );
}
