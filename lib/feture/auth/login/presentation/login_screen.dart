import 'package:app/core/common_widgets/main_elevated_button.dart';
import 'package:app/core/common_widgets/text_form_field_widget.dart';
import 'package:app/core/routes/routs.dart';
import 'package:app/core/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool? isRemumberd = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول'), centerTitle: true),
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  width: 123.w,
                  height: 100.h,

                  "assets/images/photo_2021.png",
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormFieldWidget(
                hintText: "ادخل البريد الالكتروني",
                prefixIcon: const Icon(Icons.email, color: Color(0xff5F5E5D)),
              ),
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormFieldWidget(
                suffixIcon: const Icon(
                  Icons.remove_red_eye,
                  color: Color(0xff5F5E5D),
                ),
                hintText: "ادخل كلمة المرور",
                prefixIcon: const Icon(Icons.lock, color: Color(0xff5F5E5D)),
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    GoRouter.of(context).pushNamed(Routs.forgetPassword);
                  },
                  child: Text(
                    "نسيت كلمة المرور؟",
                    style: AppStyle.headerTitle14SimiBold.copyWith(),
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: isRemumberd,
                      onChanged: (value) {
                        isRemumberd = value;
                        setState(() {});
                      },
                      side: BorderSide(
                        color: Color(0xff786454),
                        width: 1.2,
                        style: BorderStyle.solid,
                      ),
                      fillColor: WidgetStateProperty.resolveWith<Color>((
                        states,
                      ) {
                        if (states.contains(WidgetState.selected)) {
                          return Colors.white;
                        }
                        return Colors.transparent;
                      }),
                      activeColor: Colors.black,
                      checkColor: Color(0xff786454),
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      visualDensity: VisualDensity.comfortable,
                    ),
                    Text("تذكرني", style: AppStyle.headerTitle14SimiBold),
                  ],
                ),
              ],
            ),
            SizedBox(height: 15.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.sp),
              child: MainElevatedButton(
                textColor: Colors.white,
                borderRadius: 14.r,
                textOnButton: "تسجيل الدخول",
                onButtonTap: () {
                  GoRouter.of(context).pushNamed(Routs.home);
                },
                height: 55.h,
                width: double.infinity,
              ),
            ),
            SizedBox(height: 15.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.sp),
              child: MainElevatedButton(
                textColor: Colors.white,
                borderRadius: 14.r,
                textOnButton: "الاستمرار ضيف جديد",
                onButtonTap: () {
                  GoRouter.of(context).pushNamed(Routs.home);
                },
                height: 55.h,
                width: double.infinity,
              ),
            ),
            SizedBox(height: 30.h),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Color(0xffBBB7B5),
                    thickness: 2,
                    endIndent: 10,
                    indent: 20,
                  ),
                ),
                Text(
                  "او التسجيل بطريقه اخري",
                  style: AppStyle.headerTitle14SimiBold,
                ),
                Expanded(
                  child: Divider(
                    color: Color(0xffBBB7B5),
                    thickness: 2,
                    indent: 10,
                    endIndent: 20,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    "assets/images/google.svg",
                    height: 40.h,
                    width: 40.w,
                  ),
                ),
                SizedBox(width: 20.w),
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    "assets/images/facebook.svg",
                    height: 40.h,
                    width: 40.w,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("ليس لديك حساب؟", style: AppStyle.headerTitle14SimiBold),
                TextButton(
                  onPressed: () {
                    GoRouter.of(context).pushNamed(Routs.signUp);
                  },
                  child: Text(
                    "انشاء حساب",
                    style: AppStyle.headerTitle14SimiBold.copyWith(
                      color: Color(0xff786454),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
