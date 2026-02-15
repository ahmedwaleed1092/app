// file: lib/services/speech_service.dart
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _isAvailable = false;
  bool _isListening = false;

  bool get isAvailable => _isAvailable;
  bool get isListening => _isListening;

  // 1. طلب الصلاحيات
  Future<bool> requestPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  // 2. تهيئة الخدمة
  Future<bool> initialize() async {
    // طلب الصلاحية أولاً
    final hasPermission = await requestPermission();
    if (!hasPermission) {
      print('❌ المستخدم رفض الصلاحية');
      return false;
    }

    // تهيئة الخدمة
    _isAvailable = await _speech.initialize(
      onStatus: (status) {
        print('📊 الحالة: $status');
        _isListening = (status == 'listening');
      },
      onError: (error) {
        print('❌ خطأ: ${error.errorMsg}');
        _isListening = false;
      },
    );

    if (_isAvailable) {
      print('✅ تم التهيئة بنجاح');
    } else {
      print('❌ فشل التهيئة');
    }

    return _isAvailable;
  }

  // 3. بدء الاستماع
  Future<void> startListening({
    required Function(String) onResult,
    String localeId = 'ar-SA', // ar-SA للعربية، en-US للإنجليزية
  }) async {
    if (!_isAvailable) {
      print('❌ الخدمة غير متاحة');
      return;
    }

    await _speech.listen(
      onResult: (result) {
        final text = result.recognizedWords;
        onResult(text);
        print('🎤 النص: $text');
      },
      localeId: localeId,
      listenMode: stt.ListenMode.confirmation, // أو ListenMode.dictation
      cancelOnError: true,
      partialResults: true, // نتائج فورية أثناء الكلام
      listenFor: Duration(seconds: 30), // مدة الاستماع القصوى
      pauseFor: Duration(seconds: 3), // التوقف بعد السكوت
    );

    _isListening = true;
  }

  // 4. إيقاف الاستماع
  Future<void> stopListening() async {
    await _speech.stop();
    _isListening = false;
  }

  // 5. إلغاء الاستماع
  Future<void> cancel() async {
    await _speech.cancel();
    _isListening = false;
  }

  // 6. الحصول على اللغات المتاحة
  Future<List<stt.LocaleName>> getLocales() async {
    if (!_isAvailable) {
      await initialize();
    }
    return await _speech.locales();
  }

  // 7. التحقق من دعم الجهاز
  Future<bool> hasPermission() async {
    return await _speech.hasPermission;
  }

  // 8. تنظيف الموارد
  void dispose() {
    _speech.cancel();
  }
}
