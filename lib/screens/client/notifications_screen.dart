import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'icon': Icons.local_shipping,
      'color': const Color(0xFF25D366),
      'title': 'طلبك في الطريق',
      'body': 'الكابتن أحمد في طريقه إليك الآن',
      'time': 'منذ 5 دقائق',
      'read': false,
    },
    {
      'icon': Icons.local_offer,
      'color': const Color(0xFFEF233C),
      'title': 'خصم خاص لك',
      'body': 'خصم 20% على جميع المنتجات',
      'time': 'منذ ساعة',
      'read': false,
    },
    {
      'icon': Icons.check_circle,
      'color': const Color(0xFF25D366),
      'title': 'تم توصيل طلبك',
      'body': 'نتمنى أن تكون التجربة رائعة',
      'time': 'أمس',
      'read': true,
    },
    {
      'icon': Icons.person_add,
      'color': const Color(0xFF2B2D42),
      'title': 'تم توثيق حسابك',
      'body': 'مرحباً بك في سوبر جيب',
      'time': 'منذ يومين',
      'read': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final unread = _notifications.where((n) => n['read'] == false).length;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2D42),
        title: Row(
          children: [
            const Text('الإشعارات',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            if (unread > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF233C),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('$unread',
                    style: const TextStyle(
                        color: Colors.white, fontSize: 10)),
              ),
            ],
          ],
        ),
        leading: const BackButton(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all, color: Colors.white),
            onPressed: () {
              setState(() {
                for (var n in _notifications) {
                  n['read'] = true;
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('✅ تم تحديد الكل كمقروء'),
                    backgroundColor: Color(0xFF25D366)),
              );
            },
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off,
                      size: 80, color: Colors.grey),
                  SizedBox(height: 15),
                  Text('لا توجد إشعارات',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: _notifications.length,
              itemBuilder: (context, i) => _card(i),
            ),
    );
  }

  Widget _card(int i) {
    final n = _notifications[i];
    final read = n['read'] as bool;
    return GestureDetector(
      onTap: () => setState(() => _notifications[i]['read'] = true),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: read ? Colors.white : const Color(0xFFEF233C).withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              color: read
                  ? Colors.grey.shade200
                  : const Color(0xFFEF233C).withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (n['color'] as Color).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(n['icon'] as IconData,
                  color: n['color'] as Color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(n['title'],
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              read ? FontWeight.w500 : FontWeight.bold,
                          color: const Color(0xFF2B2D42))),
                  const SizedBox(height: 4),
                  Text(n['body'],
                      style: const TextStyle(
                          fontSize: 12, color: Colors.black54)),
                  const SizedBox(height: 4),
                  Text(n['time'],
                      style: const TextStyle(
                          fontSize: 10, color: Colors.grey)),
                ],
              ),
            ),
            if (!read)
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Color(0xFFEF233C),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
