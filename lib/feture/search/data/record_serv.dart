// file: lib/pages/speech_test_page.dart
import 'package:app/feture/search/data/11.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SpeechTestPage extends StatefulWidget {
  const SpeechTestPage({super.key});

  @override
  State<SpeechTestPage> createState() => _SpeechTestPageState();
}

class _SpeechTestPageState extends State<SpeechTestPage> {
  final SpeechService _speechService = SpeechService();

  String _text = '';
  bool _isInitialized = false;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    final initialized = await _speechService.initialize();
    setState(() {
      _isInitialized = initialized;
    });

    if (!initialized) {
      _showMessage('فشل تهيئة خدمة التعرف على الصوت');
    }
  }

  Future<void> _toggleListening() async {
    if (!_isInitialized) {
      _showMessage('الخدمة غير جاهزة');
      return;
    }

    if (_isListening) {
      await _speechService.stopListening();
      setState(() {
        _isListening = false;
      });
    } else {
      setState(() {
        _text = '';
        _isListening = true;
      });

      await _speechService.startListening(
        onResult: (text) {
          setState(() {
            _text = text;
          });
        },
        localeId: 'ar-SA',
      );
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _speechService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختبار التعرف على الصوت'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // حالة الخدمة
              Container(
                padding: EdgeInsets.all(12.sp),
                decoration: BoxDecoration(
                  color: _isInitialized ? Colors.green[100] : Colors.red[100],
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isInitialized ? Icons.check_circle : Icons.error,
                      color: _isInitialized ? Colors.green : Colors.red,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      _isInitialized ? 'الخدمة جاهزة' : 'الخدمة غير جاهزة',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _isInitialized
                            ? Colors.green[900]
                            : Colors.red[900],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40.h),

              // زر التسجيل
              GestureDetector(
                onTap: _toggleListening,
                child: Container(
                  width: 100.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isListening ? Colors.red : Color(0xff786454),
                    boxShadow: [
                      BoxShadow(
                        color: (_isListening ? Colors.red : Color(0xff786454))
                            .withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    color: Colors.white,
                    size: 50.sp,
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              Text(
                _isListening ? 'جاري الاستماع...' : 'اضغط للتسجيل',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: _isListening ? Colors.red : Colors.grey[700],
                ),
              ),

              SizedBox(height: 40.h),

              // النص المُعترف به
              if (_text.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.sp),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Color(0xff786454)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'النص المُعترف به:',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff786454),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        _text,
                        style: TextStyle(fontSize: 16.sp, height: 1.5),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
