import 'package:app/feture/sevice_view/model/service_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceView extends StatelessWidget {
  const ServiceView({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      ServiceModel(
        name: 'أحمد محمد',
        rating: 4.8,
        experience: '5 سنوات',
        imageUrl: 'https://via.placeholder.com/80?text=Ahmed',
      ),
      ServiceModel(
        name: 'سارة علي',
        rating: 4.5,
        experience: '3 سنوات',
        imageUrl: 'https://via.placeholder.com/80?text=Sara',
      ),
      ServiceModel(
        name: 'محمود حسن',
        rating: 4.9,
        experience: '7 سنوات',
        imageUrl: 'https://via.placeholder.com/80?text=Mahmoud',
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('الخدمات'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.sp),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return _buildServiceCard(service);
        },
      ),
    );
  }

  Widget _buildServiceCard(ServiceModel service) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      elevation: 4,
      color: Color(0xffF9FAFB),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Row(
          children: [
            // الصورة (اليمين في RTL)
            CircleAvatar(
              radius: 40.r,
              backgroundColor: Colors.grey[300],
              child: ClipOval(
                child: Image.network(
                  "assets/images/photo_2021.png",
                  fit: BoxFit.cover,
                  width: 80.w,
                  height: 80.h,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.person,
                        size: 40.sp,
                        color: Colors.grey[600],
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(width: 16.w),

            // البيانات (الشمال في RTL)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // الاسم والتقييم
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          service.name,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16.sp),
                          SizedBox(width: 4.w),
                          Text(
                            '${service.rating}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.amber[800],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),

                  // الخبرة
                  Row(
                    children: [
                      Icon(
                        Icons.work_outline,
                        size: 14.sp,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        service.experience,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
