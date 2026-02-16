import 'package:app/feture/profile/views/presentation/profile_view.dart';
import 'package:app/feture/sevice_view/model/service_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceView extends StatelessWidget {
  final String categoryName; // المتغير المستقبل

  const ServiceView({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    // معالجة اسم الفئة - إزالة الكسرات والمسافات الزائدة
    final normalizedCategory = _normalizeCategory(categoryName);

    // قاعدة بيانات وهمية (تأكد أن الـ roole يطابق أسماء الأقسام في الصفحة السابقة)
    final allServices = [
      ServiceModel(
        name: 'أحمد محمد',
        rating: 4.8,
        experience: '5 سنوات',
        roole: 'نجار',
        imageUrl: 'https://via.placeholder.com/150',
      ),
      ServiceModel(
        name: 'سارة علي',
        rating: 4.5,
        experience: '3 سنوات',
        roole: 'نجار',
        imageUrl: 'https://via.placeholder.com/150',
      ),
      ServiceModel(
        name: 'كريم محمود',
        rating: 4.9,
        experience: '9 سنوات',
        roole: 'سباكة',
        imageUrl: 'https://via.placeholder.com/150',
      ),
      ServiceModel(
        name: 'حسن إبراهيم',
        rating: 4.2,
        experience: '4 سنوات',
        roole: 'سباكة',
        imageUrl: 'https://via.placeholder.com/150',
      ),
      ServiceModel(
        name: 'مصطفى كامل',
        rating: 5.0,
        experience: '10 سنوات',
        roole: 'كهربائي',
        imageUrl: 'https://via.placeholder.com/150',
      ),
    ];

    // عملية الفلترة (Filtering) مع اسم معايير
    final filteredList = allServices
        .where(
          (element) => _normalizeCategory(element.roole) == normalizedCategory,
        )
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(categoryName), // عنوان الصفحة هو اسم القسم
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: filteredList.isEmpty
          ? Center(
              child: Text(
                'لا يوجد مقدمي خدمة في قسم $categoryName حالياً',
                style: TextStyle(fontSize: 16.sp),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16.sp),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final service = filteredList[index];
                return _buildServiceCard(service, context);
              },
            ),
    );
  }

  Widget _buildServiceCard(ServiceModel service, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileView(service: service),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 16.h),
        elevation: 4,
        color: const Color(0xffF9FAFB),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.sp),
          child: Row(
            children: [
              // الصورة
              CircleAvatar(
                radius: 40.r,
                backgroundImage: NetworkImage(
                  service.imageUrl ??
                      "https://png.pngtree.com/png-vector/20240905/ourmid/pngtree-carpentry-master-at-work-woodworking-tools-techniques-and-professional-png-image_13756497.png",
                ),
                backgroundColor: Colors.grey[300],
                onBackgroundImageError: (_, __) {}, // منع الخطأ لو الرابط بايظ
                child: service.imageUrl == null
                    ? Icon(Icons.person, size: 40.sp)
                    : null,
              ),
              SizedBox(width: 16.w),
              // البيانات
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          service.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 16.sp),
                            Text(
                              '${service.rating}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '${service.roole} • خبرة ${service.experience}',
                      style: TextStyle(color: Colors.black, fontSize: 12.sp),
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

  /// دالة لمعايرة اسم الفئة - تحويل الأسماء المختلفة لاسم قياسي
  String _normalizeCategory(String category) {
    // تنظيف المسافات والأحرف الزائدة
    final normalized = category.trim().toLowerCase();

    // معالجة الاختلافات الشائعة
    if (normalized.contains('نج')) {
      // نجار، نجرة، نجارة تصبح كلها "نجار"
      return 'نجار';
    } else if (normalized.contains('سب')) {
      // سباكة، سباك تصبح كلها "سباكة"
      return 'سباكة';
    } else if (normalized.contains('كهرب') || normalized.contains('كهر')) {
      // كهربائي تصبح "كهربائي"
      return 'كهربائي';
    } else if (normalized.contains('نقا') || normalized.contains('نقش')) {
      // نقاش، نقاشة تصبح كلها "نقاش"
      return 'نقاش';
    }

    return normalized;
  }
}
