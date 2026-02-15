import 'package:app/core/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RichTextWidget extends StatelessWidget {
  final String mainText;
  final String subText;
  final Function? onTap;

  const RichTextWidget({
    super.key,
    required this.mainText,
    required this.subText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onTap as Function()?,

        child: RichText(
          text: TextSpan(
            text: mainText,
            style: AppStyle.headerTitle14SimiBold.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            children: [
              TextSpan(
                text: subText,
                style: AppStyle.headerTitle14SimiBold.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
