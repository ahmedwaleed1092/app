import 'package:app/core/common_widgets/main_elevated_button.dart';
import 'package:app/core/common_widgets/rich_text_widget.dart';
import 'package:app/core/common_widgets/text_form_field_widget.dart';
import 'package:app/core/routes/routs.dart';
import 'package:app/core/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();

  bool isObscurePassword = true;
  bool isObscureConfirmPassword = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
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

            SizedBox(height: 50.h),

            // welcome text
            Align(
              alignment: Alignment.center,
              child: Text(
                "إنشاء حساب جديد",
                style: AppFonts.inter.copyWith(
                  color: Colors.black,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Name text field
            TextFormFieldWidget(
              hintText: "الاسم الوظيفه",
              controller: nameController,
              prefixIcon: const Icon(Icons.person_outline, color: Colors.black),
              suffixIcon: IconButton(
                icon: const Icon(Icons.mic, color: Colors.black),
                onPressed: () {
                  // وظيفة الميكروفون
                },
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "الرجاء إدخال الاسم";
                }
                return null;
              },
            ),

            SizedBox(height: 32.h),

            // Name text field
            TextFormFieldWidget(
              hintText: "الاسم كامل",
              controller: nameController,
              prefixIcon: const Icon(Icons.room_service, color: Colors.black),
              suffixIcon: IconButton(
                icon: const Icon(Icons.mic, color: Colors.black),
                onPressed: () {
                  // وظيفة الميكروفون
                },
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "الرجاء إدخال الاسم";
                }
                return null;
              },
            ),

            SizedBox(height: 32.h),

            // Email text field
            TextFormFieldWidget(
              hintText: "البريد الإلكتروني",
              textInputType: TextInputType.emailAddress,
              controller: emailController,
              prefixIcon: const Icon(Icons.email_outlined, color: Colors.black),
              suffixIcon: IconButton(
                icon: const Icon(Icons.mic, color: Colors.black),
                onPressed: () {
                  // وظيفة الميكروفون
                },
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "الرجاء إدخال البريد الإلكتروني";
                } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return "الرجاء إدخال بريد إلكتروني صحيح";
                }
                return null;
              },
            ),

            SizedBox(height: 32.h),

            // Password text field
            TextFormFieldWidget(
              hintText: "كلمة المرور",
              controller: passwordController,
              isObscureText: isObscurePassword,
              prefixIcon: const Icon(Icons.lock_outline, color: Colors.black),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.mic, color: Colors.black),
                    onPressed: () {
                      // وظيفة الميكروفون
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      isObscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        isObscurePassword = !isObscurePassword;
                      });
                    },
                  ),
                ],
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال كلمة المرور';
                } else if (value.length < 8) {
                  return "كلمة المرور يجب أن تكون 8 أحرف على الأقل";
                }
                return null;
              },
            ),

            SizedBox(height: 32.h),

            // Confirm Password text field
            TextFormFieldWidget(
              hintText: "تأكيد كلمة المرور",
              controller: confirmPasswordController,
              isObscureText: isObscureConfirmPassword,
              prefixIcon: const Icon(Icons.lock_outline, color: Colors.black),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.mic, color: Colors.black),
                    onPressed: () {
                      // وظيفة الميكروفون
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      isObscureConfirmPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Color(0xff5F5E5D),
                    ),
                    onPressed: () {
                      setState(() {
                        isObscureConfirmPassword = !isObscureConfirmPassword;
                      });
                    },
                  ),
                ],
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء تأكيد كلمة المرور';
                } else if (value != passwordController.text) {
                  return "كلمات المرور غير متطابقة";
                }
                return null;
              },
            ),

            SizedBox(height: 32.h),

            // Register Button
            MainElevatedButton(
              textOnButton: "انشاء حساب جديد",
              onButtonTap: () {
                GoRouter.of(context).pushReplacement(Routs.category);
              },
            ),

            if (isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Center(
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                ),
              ),

            SizedBox(height: 32.h),

            // Already have account? Login
            RichTextWidget(
              mainText: "لديك حساب بالفعل؟ ",
              subText: "تسجيل الدخول",
              onTap: () {
                // الانتقال لصفحة تسجيل الدخول
              },
            ),

            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
