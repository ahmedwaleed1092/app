import 'package:app/core/common_widgets/main_elevated_button.dart';
import 'package:app/core/routes/routs.dart';
import 'package:app/core/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class PreLoginScreen extends StatefulWidget {
  const PreLoginScreen({super.key});

  @override
  State<PreLoginScreen> createState() => _PreLoginScreenState();
}

class _PreLoginScreenState extends State<PreLoginScreen> {
  String role1 = 'مقدم خدمة';
  String role2 = 'مشتري';
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height: 100.h),
            Text(
              "انشاء حساب جديد ",
              style: AppStyle.headerTitle22bold.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
              "انشاء حساب جديد باختيار  احد الطرق التالية",
              style: AppStyle.headerTitle22bold.copyWith(
                fontSize: 14.sp,

                color: Colors.grey,
              ),
            ),
            SizedBox(height: 50.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Service Provider Button
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedRole = role1;
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selectedRole == role1
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: CircleAvatar(
                          maxRadius: 80.r,
                          child: SvgPicture.asset(
                            "assets/images/servece.svg",
                            width: 100.w,
                            height: 100.h,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        role1,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: selectedRole == role1
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: selectedRole == role1
                              ? Theme.of(context).colorScheme.primary
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                // Buyer Button
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedRole = role2;
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selectedRole == role2
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: CircleAvatar(
                          maxRadius: 80.r,
                          child: Image.asset(
                            "assets/images/Group.png",
                            width: 100.w,
                            height: 100.h,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        role2,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: selectedRole == role2
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: selectedRole == role2
                              ? Theme.of(context).colorScheme.primary
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 50.h),
            selectedRole != null
                ? Center(
                    child: Text(
                      'تم اختيار: $selectedRole',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      'يرجى اختيار دور',
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                    ),
                  ),
            SizedBox(height: 50.h),

            MainElevatedButton(
              textOnButton: "التالي",
              textColor: Colors.white,
              width: 450.w,
              height: 50.h,
              onButtonTap: selectedRole != null
                  ? () {
                      if (selectedRole == role1) {
                        context.pushNamed(Routs.login);
                      } else if (selectedRole == role2) {
                        context.go(Routs.category);
                      }
                    }
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('يرجى اختيار دور أولاً'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
            ),
          ],
        ),
      ),
    );
  }
}
