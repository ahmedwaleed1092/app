import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationRequest> requests = [
    NotificationRequest(
      id: 1,
      title: 'أحمد علي',
      message: 'يريد التواصل معك',
      messageEn: 'wants to connect with you',
      avatarUrl: 'https://avatar.iran.liara.run/public/9',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationRequest(
      id: 2,
      title: 'سارة محمد',
      message: 'أرسلت لك طلب خدمة',
      messageEn: 'sent you a service request',
      avatarUrl: 'https://avatar.iran.liara.run/public/11',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    NotificationRequest(
      id: 3,
      title: 'محمد عبدالله',
      message: 'يريد العمل معك',
      messageEn: 'wants to work with you',
      avatarUrl: 'https://avatar.iran.liara.run/public/15',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
    NotificationRequest(
      id: 4,
      title: 'فاطمة أحمد',
      message: 'أرسلت لك دعوة تعاون',
      messageEn: 'sent you a collaboration invite',
      avatarUrl: 'https://avatar.iran.liara.run/public/8',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  void _acceptRequest(int id) {
    setState(() {
      requests.removeWhere((req) => req.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✓ تم قبول الطلب'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _declineRequest(int id) {
    setState(() {
      requests.removeWhere((req) => req.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✗ تم رفض الطلب'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inHours < 1) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inDays < 1) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} يوم';
    } else {
      return 'منذ ${(difference.inDays / 7).floor()} أسبوع';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'الإخطارات',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textDirection: TextDirection.rtl,
          ),
          elevation: 0,
          centerTitle: true,
          backgroundColor: const Color(0xFF6366F1),
        ),
        body: requests.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.notifications_off_rounded,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'لا توجد طلبات',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'ستظهر الطلبات الجديدة هنا',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                itemCount: requests.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final request = requests[index];
                  return NotificationRequestCard(
                    request: request,
                    timeAgo: _getTimeAgo(request.timestamp),
                    onAccept: () => _acceptRequest(request.id),
                    onDecline: () => _declineRequest(request.id),
                  );
                },
              ),
      ),
    );
  }
}

class NotificationRequest {
  final int id;
  final String title;
  final String message;
  final String messageEn;
  final String avatarUrl;
  final DateTime timestamp;

  NotificationRequest({
    required this.id,
    required this.title,
    required this.message,
    required this.messageEn,
    required this.avatarUrl,
    required this.timestamp,
  });
}

class NotificationRequestCard extends StatelessWidget {
  final NotificationRequest request;
  final String timeAgo;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const NotificationRequestCard({
    super.key,
    required this.request,
    required this.timeAgo,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[200]!, width: 1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[200]!, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(request.avatarUrl),
                  backgroundColor: Colors.grey[300],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      request.message,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timeAgo,
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onDecline,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[300]!, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'رفض',
                    style: TextStyle(color: Color(0xFF1F2937)),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onAccept,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'قبول',
                    style: TextStyle(color: Colors.white),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
