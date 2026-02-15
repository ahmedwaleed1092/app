import 'package:app/core/common_widgets/main_elevated_button.dart';
import 'package:app/core/routes/routs.dart';
import 'package:app/core/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class PreLoginScreen extends StatelessWidget {
  const PreLoginScreen({super.key});

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
                InkWell(
                  onTap: () {},
                  child: CircleAvatar(
                    maxRadius: 80.r,

                    child: SvgPicture.asset(
                      "assets/images/servece.svg",
                      width: 100.w,
                      height: 100.h,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: CircleAvatar(
                    maxRadius: 80.r,

                    child: Image.asset(
                      "assets/images/Group.png",
                      width: 100.w,
                      height: 100.h,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 50.h),
            MainElevatedButton(
              textOnButton: "التالي",
              textColor: Colors.white,
              width: 450.w,
              height: 50.h,

              onButtonTap: () {
                GoRouter.of(context).pushNamed(Routs.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}
