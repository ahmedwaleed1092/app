import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';

class AudioRecordingService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final Dio _dio = Dio();

  bool _isInitialized = false;
  bool _isListening = false;
  String _currentText = '';

  bool get isListening => _isListening;
  String get currentText => _currentText;
  bool get isInitialized => _isInitialized;

  AudioRecordingService() {
    _dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    );
  }

  // طلب الصلاحيات
  Future<bool> checkPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  // تهيئة الخدمة
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    final hasPermission = await checkPermission();
    if (!hasPermission) {
      print("المستخدم رفض الوصول للميكروفون");
      return false;
    }

    _isInitialized = await _speech.initialize(
      onStatus: _statusListener,
      onError: _errorListener,
    );

    if (_isInitialized) {
      print("تم تهيئة الخدمة بنجاح");
    } else {
      print("فشل تهيئة الخدمة");
    }

    return _isInitialized;
  }

  // بدء الاستماع
  Future<bool> startListening({
    required Function(String) onResult,
    String language = 'ar-SA',
  }) async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) return false;
    }

    if (!_speech.isAvailable) {
      print("خدمة التعرف على الصوت غير متاحة");
      return false;
    }

    _isListening = true;
    _currentText = '';

    await _speech.listen(
      onResult: (result) {
        _currentText = result.recognizedWords;
        onResult(_currentText);
      },
      localeId: language,
      listenMode: stt.ListenMode.confirmation,
      cancelOnError: true,
      partialResults: true,
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
    );

    return true;
  }

  // إيقاف الاستماع
  Future<void> stopListening() async {
    if (_isListening) {
      await _speech.stop();
      _isListening = false;
    }
  }

  // إلغاء الاستماع
  Future<void> cancelListening() async {
    await _speech.cancel();
    _isListening = false;
    _currentText = '';
  }

  // إرسال النص للـ API
  Future<Map<String, dynamic>?> sendToAPI({
    required String url,
    required String text,
    Map<String, String>? headers,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      print('جاري الإرسال إلى: $url');
      print('النص: $text');

      final data = {
        'text': text,
        'timestamp': DateTime.now().toIso8601String(),
        ...?additionalData,
      };

      final response = await _dio.post(
        url,
        data: data,
        options: Options(
          headers: headers ?? {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ تم الإرسال بنجاح');
        print('الرد: ${response.data}');
        return response.data;
      } else {
        print('❌ فشل الإرسال: ${response.statusCode}');
        return null;
      }
    } on DioException catch (e) {
      print('❌ خطأ في الإرسال: ${e.message}');
      if (e.response != null) {
        print('رد الخطأ: ${e.response?.data}');
        print('كود الخطأ: ${e.response?.statusCode}');
      }
      return null;
    } catch (e) {
      print('❌ خطأ عام: $e');
      return null;
    }
  }

  // تسجيل وإرسال مباشر
  Future<Map<String, dynamic>?> recordAndPost({
    required String url,
    Map<String, String>? headers,
    Map<String, dynamic>? additionalData,
    String language = 'ar-SA',
    Function(String)? onTextUpdate,
    Function(String)? onStatusUpdate,
  }) async {
    String finalText = '';

    onStatusUpdate?.call('جاري التسجيل...');

    // بدء التسجيل
    final started = await startListening(
      onResult: (text) {
        finalText = text;
        onTextUpdate?.call(text);
      },
      language: language,
    );

    if (!started) {
      print('فشل بدء التسجيل');
      onStatusUpdate?.call('فشل بدء التسجيل');
      return null;
    }

    // انتظار انتهاء التسجيل
    while (_isListening) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    onStatusUpdate?.call('جاري الإرسال...');

    // إرسال النص للـ API
    if (finalText.isNotEmpty) {
      final response = await sendToAPI(
        url: url,
        text: finalText,
        headers: headers,
        additionalData: additionalData,
      );

      if (response != null) {
        onStatusUpdate?.call('تم الإرسال بنجاح ✓');
      } else {
        onStatusUpdate?.call('فشل الإرسال');
      }

      return response;
    } else {
      onStatusUpdate?.call('لا يوجد نص للإرسال');
      return null;
    }
  }

  // معالج الحالة
  void _statusListener(String status) {
    print("حالة التسجيل: $status");

    if (status == 'done' || status == 'notListening') {
      _isListening = false;
    } else if (status == 'listening') {
      _isListening = true;
    }
  }

  // معالج الأخطاء
  void _errorListener(dynamic error) {
    print("خطأ في التسجيل: $error");
    _isListening = false;
  }

  // الحصول على اللغات المتاحة
  Future<List<stt.LocaleName>> getAvailableLocales() async {
    if (!_isInitialized) {
      await initialize();
    }
    return await _speech.locales();
  }

  // تنظيف الموارد
  void dispose() {
    _speech.cancel();
    _dio.close();
  }
}
