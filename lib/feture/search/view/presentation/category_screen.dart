import 'dart:io';
// تأكد من مسار DioHelper الصحيح في مشروعك
import 'package:app/core/apis/api_functions.dart';
import 'package:app/core/routes/routs.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  // --- متغيرات المسجل ---
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecorderReady = false;
  bool _isRecording = false;
  bool _isLoading = false; // للتحميل أثناء الرفع
  String? _recordedFilePath;

  // --- قائمة الأقسام (تأكد أن الأسماء تطابق ما يأتي من الـ API) ---
  final List<Map<String, dynamic>> _categories = [
    {'name': 'نجار', 'icon': Icons.carpenter, 'color': Colors.brown},
    {'name': 'سباكة', 'icon': Icons.plumbing, 'color': Colors.blue},
    {'name': 'كهربائي', 'icon': Icons.electric_bolt, 'color': Colors.amber},
    {'name': 'نقاش', 'icon': Icons.format_paint, 'color': Colors.purple},
  ];

  @override
  void initState() {
    super.initState();
    initRecorder();
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }

  // --- تهيئة المسجل ---
  Future<void> initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('الميكروفون غير مسموح به');
    }
    await _recorder.openRecorder();
    _isRecorderReady = true;
    _recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  // --- بدء التسجيل ---
  // --- بدء التسجيل ---
  Future<void> startRecording() async {
    if (!_isRecorderReady) return;
    Directory tempDir = await getTemporaryDirectory();
    // جرب امتداد بسيط بدون صيغة محددة
    String path = '${tempDir.path}/temp_record';

    try {
      await _recorder.startRecorder(toFile: path);
      setState(() {
        _isRecording = true;
        _recordedFilePath = null;
      });
      print('🎤 بدء التسجيل: $path');
    } catch (e) {
      print('❌ خطأ في بدء التسجيل: $e');
      // حاول حل بديل - استخدم openRecorder مرة أخرى
      try {
        await _recorder.closeRecorder();
        await _recorder.openRecorder();
        _isRecorderReady = true;

        await _recorder.startRecorder(toFile: path);
        setState(() {
          _isRecording = true;
          _recordedFilePath = null;
        });
      } catch (retryError) {
        print('❌ فشل إعادة المحاولة: $retryError');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ: لا يمكن تهيئة المسجل'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // --- إيقاف التسجيل ---
  Future<void> stopRecording() async {
    if (!_isRecorderReady) return;
    try {
      final path = await _recorder.stopRecorder();
      print('✅ توقف التسجيل: $path');

      if (path != null) {
        final fileSize = await File(path).length();
        print('📊 حجم الملف: ${(fileSize / 1024).toStringAsFixed(2)} KB');
      }

      setState(() {
        _isRecording = false;
        _recordedFilePath = path;
      });
    } catch (e) {
      print('❌ خطأ في إيقاف التسجيل: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في إيقاف التسجيل: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // --- حفظ التسجيل محلياً (اختياري) ---
  Future<void> saveRecordingPermanent() async {
    if (_recordedFilePath == null) return;

    try {
      final appDir = await getApplicationDocumentsDirectory();
      final String newPath =
          '${appDir.path}/saved_record_${DateTime.now().millisecondsSinceEpoch}.aac';

      final File tempFile = File(_recordedFilePath!);
      await tempFile.copy(newPath);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم حفظ الملف محلياً في: $newPath'),
          backgroundColor: Colors.green,
        ),
      );
      setState(() => _recordedFilePath = null);
    } catch (e) {
      print("Error saving file: $e");
    }
  }

  // --- الدالة الرئيسية: رفع الملف واستقبال الرد ---
  Future<void> executeCustomFunction() async {
    if (_recordedFilePath == null) return;

    setState(() {
      _isLoading = true; // تفعيل اللودينج
    });

    try {
      // 1. التحقق من أن الملف موجود وليس فارغاً
      final recordedFile = File(_recordedFilePath!);
      final fileSize = await recordedFile.length();

      print('\n--- File Info ---');
      print('File Path: $_recordedFilePath');
      final fileSizeMB = (fileSize / 1024 / 1024).toStringAsFixed(2);
      print('File Size: $fileSize bytes ($fileSizeMB MB)');
      print('-------------------\n');

      // إذا كان الملف فارغاً، لا تحاول الإرسال
      if (fileSize == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('الملف فارغ! سجل مرة أخرى بصوت أوضح'),
            backgroundColor: Colors.orange,
          ),
        );
        setState(() => _isLoading = false);
        return;
      }

      // تحذير إذا كان الملف كبيراً جداً (> 50 MB)
      if (fileSize > 50 * 1024 * 1024) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '⚠️ الملف كبير جداً (> 50 MB)! قد يستغرق وقتاً طويلاً',
            ),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
      }

      // عرض رسالة انتظار
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('⏳ جاري الإرسال... قد يستغرق وقتاً'),
          backgroundColor: Colors.blue,
          duration: const Duration(seconds: 120),
        ),
      );

      String fileName = _recordedFilePath!.split('/').last;

      // إنشاء MultipartFile أولاً
      final multipartFile = await MultipartFile.fromFile(
        _recordedFilePath!,
        filename: fileName,
      );

      // 2. إنشاء FormData
      FormData formData = FormData.fromMap({"file": multipartFile});

      print('⬆️ بدء رفع الملف...');

      // 3. استخدام Dio مباشرة لرفع الملف مع timeout و progress
      final response = await DioHelper.dio!.post(
        "https://transcription-api-126016490280.us-central1.run.app/upload-audio",
        data: formData,
        options: Options(
          sendTimeout: const Duration(seconds: 60), // timeout 60 ثانية
          receiveTimeout: const Duration(
            seconds: 120,
          ), // timeout الاستقبال 120 ثانية
        ),
        onSendProgress: (sent, total) {
          final progress = (sent / total * 100).toStringAsFixed(0);
          print('📤 جاري الرفع: $progress%');
        },
        onReceiveProgress: (received, total) {
          final progress = (received / total * 100).toStringAsFixed(0);
          print('📥 جاري الاستقبال: $progress%');
        },
      );

      // 3. التحقق من النجاح - أزل الـ SnackBar القديم أولاً
      ScaffoldMessenger.of(context).clearSnackBars();

      if (response.statusCode == 200 || response.statusCode == 201) {
        // --- استخراج البيانات من الـ JSON ---
        final responseData = response.data; // هذا يحتوي على الـ JSON

        // مثال للرد: {"cleaned_text": "...", "category": "نجارة"}
        String categoryReceived = responseData['category'] ?? '';
        String textReceived = responseData['cleaned_text'] ?? '';

        // --- طباعة الـ Response المفصلة في Console ---
        print('\n============================================');
        print('✅ تم الرد بنجاح من السيرفر');
        print('============================================');
        print('Status Code: ${response.statusCode}');
        print('------- Response Data -------');
        print('Category: $categoryReceived');
        print('Cleaned Text: $textReceived');
        print('------- Full Response JSON -------');
        print(responseData);
        print('============================================\n');

        // إشعار للمستخدم
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم التعرف على طلبك: $categoryReceived'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        // 4. الانتقال لصفحة الخدمات
        if (mounted && categoryReceived.isNotEmpty) {
          context.pushNamed(
            Routs.serviceView,
            extra: categoryReceived, // تمرير اسم القسم (مثلاً: "نجارة")
          );
        }

        // تنظيف الحالة
        setState(() => _recordedFilePath = null);
      } else {
        // --- طباعة خطأ الرد ---
        print('\n============================================');
        print('❌ فشل الرفع من السيرفر');
        print('============================================');
        print('Status Code: ${response.statusCode}');
        print('Status Message: ${response.statusMessage}');
        print('Response Data: ${response.data}');
        print('============================================\n');

        // أزل الـ SnackBar القديم قبل عرض رسالة الفشل
        ScaffoldMessenger.of(context).clearSnackBars();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل الرفع. كود: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } on DioException catch (e) {
      // --- معالجة خاصة لـ DioException ---
      print('\n============================================');
      print('❌ DioException - خطأ في الاتصال');
      print('============================================');
      print('Status Code: ${e.response?.statusCode}');
      print('Status Message: ${e.response?.statusMessage}');
      print('Error Message: ${e.message}');
      print('------- Server Response -------');
      print('Response Data: ${e.response?.data}');
      print('============================================\n');

      String errorMsg = 'خطأ في الاتصال';

      // تحديد نوع الخطأ بناءً على نوع الاستثناء
      if (e.type == DioExceptionType.connectionTimeout) {
        errorMsg = '⏱️ انتهت مهلة الاتصال! تأكد من سرعة الإنترنت';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMsg = '⏱️ انتهت مهلة الاستقبال! السيرفر بطيء أو غير مستجيب';
      } else if (e.type == DioExceptionType.sendTimeout) {
        errorMsg = '⏱️ انتهت مهلة الرفع! الملف كبير أو الإنترنت بطيء';
      } else if (e.type == DioExceptionType.unknown) {
        errorMsg = '❌ خطأ غير معروف: ${e.message}';
      } else if (e.response?.statusCode == 400) {
        final responseData = e.response?.data;
        final detail = responseData?['detail'] ?? '';

        // رسالة خطأ أكثر وضوحاً
        if (detail.contains('No speech recognized')) {
          errorMsg =
              'لم يتم التعرف على الكلام! اتأكد من:\n\n'
              '✓ المايك يعمل بشكل صحيح\n'
              '✓ الصوت واضح ومسموع\n'
              '✓ تسجيل مدة أطول (3+ ثوانٍ)';
        } else {
          errorMsg = 'خطأ في البيانات: $detail';
        }
      } else if (e.response?.statusCode == 404) {
        errorMsg = 'النقطة غير موجودة (404)';
      } else if (e.response?.statusCode == 500) {
        errorMsg = 'خطأ في السيرفر (500)';
      }

      // أزل الـ SnackBar القديم قبل عرض رسالة الخطأ
      ScaffoldMessenger.of(context).clearSnackBars();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      // --- طباعة الأخطاء الأخرى ---
      print('\n============================================');
      print('❌ حدث خطأ أثناء الرفع');
      print('============================================');
      print('Error Type: ${e.runtimeType}');
      print('Error Message: $e');
      print('StackTrace: ${StackTrace.current}');
      print('============================================\n');

      String errorMsg = 'حدث خطأ غير متوقع';

      if (e.toString().contains('SocketException')) {
        errorMsg = '🌐 خطأ في الاتصال بالإنترنت! تحقق من الاتصال';
      } else if (e.toString().contains('TimeoutException')) {
        errorMsg = '⏱️ انتهت المهلة الزمنية! حاول مرة أخرى';
      }

      // أزل الـ SnackBar القديم قبل عرض رسالة الخطأ
      ScaffoldMessenger.of(context).clearSnackBars();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false; // إيقاف اللودينج
      });
    }
  }

  // --- حذف التسجيل الحالي ---
  void deleteCurrentRecording() {
    setState(() {
      _recordedFilePath = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'الأقسام',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Column(
          children: [
            // --- شبكة الأقسام ---
            Expanded(
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.h,
                  childAspectRatio: 1.1,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  return _buildCategoryCard(
                    _categories[index]['name'],
                    _categories[index]['icon'],
                    _categories[index]['color'],
                  );
                },
              ),
            ),

            SizedBox(height: 20.h),

            // --- منطقة التسجيل والتحكم ---
            Container(
              padding: EdgeInsets.all(16.sp),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Text(
                    _isRecording
                        ? 'جاري التسجيل...'
                        : (_recordedFilePath != null
                              ? 'تم التسجيل! ماذا تريد أن تفعل؟'
                              : 'سجل طلبك صوتياً'),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: _isRecording ? Colors.red : Colors.black87,
                    ),
                  ),

                  SizedBox(height: 15.h),

                  // عرض الأزرار حسب الحالة
                  if (_recordedFilePath == null)
                    // زر التسجيل (Mic)
                    GestureDetector(
                      onTap: _isRecording ? stopRecording : startRecording,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 70.h,
                        width: 70.w,
                        decoration: BoxDecoration(
                          color: _isRecording ? Colors.red : Colors.blueAccent,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (_isRecording ? Colors.red : Colors.blue)
                                  .withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          _isRecording ? Icons.stop : Icons.mic,
                          color: Colors.white,
                          size: 35.sp,
                        ),
                      ),
                    )
                  else
                    // أزرار التحكم (حذف، حفظ، إرسال)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // 1. زر الحذف
                        _buildActionButton(
                          icon: Icons.delete,
                          color: Colors.red,
                          label: "حذف",
                          onTap: deleteCurrentRecording,
                          isEnabled: !_isLoading,
                        ),

                        // 2. زر الحفظ المحلي
                        _buildActionButton(
                          icon: Icons.save,
                          color: Colors.green,
                          label: "حفظ",
                          onTap: saveRecordingPermanent,
                          isEnabled: !_isLoading,
                        ),

                        // 3. زر الإرسال (مع مؤشر التحميل)
                        _isLoading
                            ? SizedBox(
                                height: 50.h,
                                width: 50.w,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : _buildActionButton(
                                icon: Icons.send,
                                color: Colors.blue,
                                label: "إرسال",
                                onTap: executeCustomFunction,
                                isEnabled: true,
                              ),
                      ],
                    ),

                  // عداد الوقت
                  if (_isRecording) ...[
                    SizedBox(height: 10.h),
                    StreamBuilder<RecordingDisposition>(
                      stream: _recorder.onProgress,
                      builder: (context, snapshot) {
                        final duration = snapshot.hasData
                            ? snapshot.data!.duration
                            : Duration.zero;
                        String twoDigits(int n) => n.toString().padLeft(2, '0');
                        return Text(
                          '${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  // --- ودجت الأزرار ---
  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
    bool isEnabled = true,
  }) {
    return Opacity(
      opacity: isEnabled ? 1.0 : 0.5,
      child: Column(
        children: [
          GestureDetector(
            onTap: isEnabled ? onTap : null,
            child: Container(
              padding: EdgeInsets.all(12.sp),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: color),
              ),
              child: Icon(icon, color: color, size: 24.sp),
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            label,
            style: TextStyle(fontSize: 12.sp, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // --- ودجت كارت القسم ---
  Widget _buildCategoryCard(String name, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(Routs.serviceView, extra: name);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16.sp),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32.sp, color: color),
            ),
            SizedBox(height: 12.h),
            Text(
              name,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
