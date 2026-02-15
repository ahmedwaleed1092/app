import 'package:app/feture/search/data/record.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SquareRecordCard extends StatefulWidget {
  final AudioRecordingService audioService;
  final String postUrl;
  final Map<String, String>? headers;
  final Map<String, dynamic>? additionalData;
  final Function(String)? onTextRecorded;
  final Function(Map<String, dynamic>)? onApiResponse;

  const SquareRecordCard({
    super.key,
    required this.audioService,
    required this.postUrl,
    this.headers,
    this.additionalData,
    this.onTextRecorded,
    this.onApiResponse,
  });

  @override
  State<SquareRecordCard> createState() => _SquareRecordCardState();
}

class _SquareRecordCardState extends State<SquareRecordCard> {
  bool _isListening = false;
  bool _isSending = false;
  String _recordedText = '';

  Future<void> _startRecording() async {
    setState(() {
      _isListening = true;
      _recordedText = '';
    });

    final started = await widget.audioService.startListening(
      onResult: (text) {
        setState(() {
          _recordedText = text;
        });
        widget.onTextRecorded?.call(text);
      },
      language: 'ar-SA',
    );

    if (!started) {
      setState(() => _isListening = false);
      _showMessage('فشل بدء التسجيل', isError: true);
    }
  }

  Future<void> _stopAndSend() async {
    await widget.audioService.stopListening();
    setState(() {
      _isListening = false;
      _isSending = true;
    });

    if (_recordedText.isEmpty) {
      setState(() => _isSending = false);
      _showMessage('لا يوجد نص للإرسال', isError: true);
      return;
    }

    final response = await widget.audioService.sendToAPI(
      url: widget.postUrl,
      text: _recordedText,
      headers: widget.headers,
      additionalData: widget.additionalData,
    );

    setState(() => _isSending = false);

    if (response != null) {
      widget.onApiResponse?.call(response);
      _showMessage('تم الإرسال بنجاح');
    } else {
      _showMessage('فشل الإرسال', isError: true);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isSending
          ? null
          : (_isListening ? _stopAndSend : _startRecording),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Container(
          width: 120.w,
          height: 120.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _isSending
                  ? SizedBox(
                      width: 40.w,
                      height: 40.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Color(0xff786454),
                      ),
                    )
                  : Icon(
                      _isListening ? Icons.stop_circle : Icons.mic,
                      size: 50.sp,
                      color: _isListening ? Colors.red : Color(0xff786454),
                    ),
              SizedBox(height: 12.h),
              Text(
                _isSending
                    ? 'إرسال...'
                    : _isListening
                    ? 'إيقاف'
                    : 'تسجيل',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
