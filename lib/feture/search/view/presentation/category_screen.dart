import 'package:app/core/apis/api_functions.dart';
import 'package:app/core/routes/routs.dart';
import 'package:app/core/theme/app_fonts.dart';
import 'package:app/feture/search/data/11.dart';
import 'package:app/feture/search/view/presentation/custom_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late final SpeechService _speechService;
  late final TextEditingController _searchController;
  late final DioHelper _dioHelper;

  bool _isInitialized = false;
  bool _isListening = false;
  bool _isSending = false;
  dynamic apiResponse;

  static const String _endpoint = '/search';
  static const Duration _messageDuration = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    _speechService = SpeechService();
    _searchController = TextEditingController();
    _dioHelper = DioHelper();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    try {
      final initialized = await _speechService.initialize();
      if (mounted) {
        setState(() => _isInitialized = initialized);
        _showMessage(
          initialized ? 'الميكروفون جاهز! ✓' : 'فشل تهيئة الميكروفون',
        );
      }
    } catch (e) {
      _showMessage('خطأ في تهيئة الميكروفون: $e');
    }
  }

  Future<void> _toggleVoiceSearch() async {
    if (!_isInitialized) {
      _showMessage('الخدمة غير جاهزة. جاري إعادة التهيئة...');
      await _initSpeech();
      return;
    }

    if (_isListening) {
      await _stopListening();
    } else {
      await _startListening();
    }
  }

  Future<void> _startListening() async {
    if (mounted) {
      setState(() {
        _isListening = true;
        _searchController.clear();
        apiResponse = null;
      });
    }

    try {
      await _speechService.startListening(
        onResult: (text) {
          if (mounted) {
            setState(() => _searchController.text = text);
          }
        },
        localeId: 'ar-SA',
      );
    } catch (e) {
      _showMessage('خطأ في الاستماع: $e');
      if (mounted) setState(() => _isListening = false);
    }
  }

  Future<void> _stopListening() async {
    try {
      await _speechService.stopListening();
      if (mounted) setState(() => _isListening = false);

      if (_searchController.text.isNotEmpty) {
        await _sendToAPI(_searchController.text);
      }
    } catch (e) {
      _showMessage('خطأ في إيقاف الاستماع: $e');
    }
  }

  Future<void> _sendToAPI(String text) async {
    if (text.trim().isEmpty) {
      _showMessage('الرجاء إدخال نص للبحث');
      return;
    }

    setState(() => _isSending = true);

    try {
      final response = await DioHelper.postRequest(
        endPionts: _endpoint,
        data: {
          'text': text,
          'type': 'voice_search',
          'timestamp': DateTime.now().toIso8601String(),
        },
        headers: {'Content-Type': 'application/json'},
      );

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (mounted) {
          setState(() => apiResponse = response.data);
        }
        _showMessage('تم الإرسال بنجاح ✓');
      } else {
        _showMessage('فشل الإرسال');
      }
    } catch (e) {
      _showMessage('خطأ: $e');
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: _messageDuration),
    );
  }

  @override
  void dispose() {
    _speechService.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F4F6),
      appBar: AppBar(
        title: const Text('الفئات'),
        centerTitle: true,
        actions: [
          if (apiResponse != null)
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: const Icon(Icons.check_circle, color: Colors.green),
            ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.sp),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildStatusIndicator(),
              SizedBox(height: 12.h),
              _buildSearchField(),
              SizedBox(height: 20.h),
              if (apiResponse != null) _buildResponseWidget(),
              SizedBox(height: 20.h),
              _buildCategoriesGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Container(
      padding: EdgeInsets.all(8.sp),
      decoration: BoxDecoration(
        color: _isInitialized ? Colors.green[100] : Colors.orange[100],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _isInitialized ? Icons.check_circle : Icons.pending,
            color: _isInitialized ? Colors.green : Colors.orange,
            size: 16.sp,
          ),
          SizedBox(width: 8.w),
          Text(
            _isInitialized ? 'الميكروفون جاهز' : 'جاري التحميل...',
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      textInputAction: TextInputAction.search,
      onSubmitted: _sendToAPI,
      enabled: !_isSending && !_isListening,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Color(0xff786454), width: 2),
        ),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isSending)
              Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xff786454),
                  ),
                ),
              )
            else
              IconButton(
                icon: const Icon(Icons.search, color: Color(0xff786454)),
                onPressed: _searchController.text.isEmpty
                    ? null
                    : () => _sendToAPI(_searchController.text),
              ),
            SizedBox(width: 4.w),
            Container(
              decoration: BoxDecoration(
                color: _isListening
                    ? Colors.red.withOpacity(0.1)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: _isSending ? null : _toggleVoiceSearch,
                icon: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  color: _isListening
                      ? Colors.red
                      : _isInitialized
                      ? const Color(0xff786454)
                      : Colors.grey,
                ),
              ),
            ),
          ],
        ),
        hintText: _isListening
            ? 'جاري الاستماع...'
            : _isSending
            ? 'جاري الإرسال...'
            : 'ابحث واضغط Enter',
        hintStyle: AppFonts.inter.copyWith(
          color: _isListening
              ? Colors.red[300]
              : _isSending
              ? Colors.orange[300]
              : Colors.grey[500],
          fontSize: 14.sp,
        ),
      ),
    );
  }

  Widget _buildResponseWidget() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.green, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 16.sp),
              SizedBox(width: 8.w),
              Text(
                'تم حفظ النتيجة ✓',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'النوع: ${apiResponse.runtimeType}',
            style: TextStyle(fontSize: 10.sp, color: Colors.grey[700]),
          ),
          SizedBox(height: 4.h),
          Text(
            apiResponse.toString(),
            style: TextStyle(fontSize: 11.sp),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    final categories = [
      _CategoryData('الرياضة', 'assets/images/restaurant.svg'),
      _CategoryData('تسوق', 'assets/images/restaurant.svg'),
      _CategoryData('مطاعم', 'assets/images/restaurant.svg'),
      _CategoryData('ترفيه', 'assets/images/fixIcon.svg'),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return CategoryCard(
          imageUrl: category.imageUrl,
          title: category.title,
          onTap: () => context.pushNamed(Routs.serviceView),
        );
      },
    );
  }
}

class _CategoryData {
  final String title;
  final String imageUrl;

  _CategoryData(this.title, this.imageUrl);
}
