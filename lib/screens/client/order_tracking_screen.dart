import 'package:flutter/material.dart';
import 'chat_screen.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;
  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  final int _currentStep = 2;

  final _steps = [
    {
      'title': 'تم استلام الطلب',
      'subtitle': 'تم تأكيد طلبك بنجاح',
      'time': '10:30 ص',
      'icon': Icons.receipt_long,
    },
    {
      'title': 'قبله المتجر',
      'subtitle': 'المتجر يحضّر طلبك',
      'time': '10:35 ص',
      'icon': Icons.storefront,
    },
    {
      'title': 'في الطريق',
      'subtitle': 'الكابتن أحمد في طريقه إليك',
      'time': '10:50 ص',
      'icon': Icons.delivery_dining,
    },
    {
      'title': 'تم التسليم',
      'subtitle': 'في انتظار التسليم',
      'time': '--:--',
      'icon': Icons.home,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2D42),
        title: Text('تتبع الطلب #${widget.orderId}',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold)),
        leading: const BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // خريطة توضيحية
            Container(
              height: 220,
              width: double.infinity,
              color: const Color(0xFF2B2D42).withValues(alpha: 0.05),
              child: const Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map, color: Colors.white24, size: 80),
                      SizedBox(height: 10),
                      Text('📍 خريطة الملاحة',
                          style: TextStyle(
                              color: Colors.black38, fontSize: 12)),
                      Text('⬛⬛⬛⬛ الخط الملاحي نشط ⬛⬛⬛⬛',
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),

            // كابتن الطلب
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8),
                  ],
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      backgroundColor: Color(0xFF2B2D42),
                      child: Icon(Icons.person,
                          color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('الكابتن أحمد',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 3),
                          Row(
                            children: [
                              Icon(Icons.star,
                                  color: Colors.amber, size: 14),
                              SizedBox(width: 3),
                              Text('4.9',
                                  style: TextStyle(fontSize: 12)),
                              SizedBox(width: 10),
                              Text('دراجة نارية',
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.phone,
                          color: Color(0xFF25D366), size: 26),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('📞 اتصال محمي'),
                              backgroundColor: Color(0xFF25D366)),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.chat,
                          color: Color(0xFFEF233C), size: 26),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ChatScreen())),
                    ),
                  ],
                ),
              ),
            ),

            // خطوات الطلب
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('حالة الطلب',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2B2D42))),
                    const SizedBox(height: 20),
                    ..._steps.asMap().entries.map((e) {
                      final i = e.key;
                      final step = e.value;
                      final done = i <= _currentStep;
                      final active = i == _currentStep;
                      return _timelineItem(step, done, active, i);
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // كود OTP
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF25D366).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                      color: const Color(0xFF25D366).withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.lock,
                            color: Color(0xFF25D366), size: 22),
                        SizedBox(width: 10),
                        Text('كود التسليم OTP',
                            style: TextStyle(
                                color: Color(0xFF25D366),
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Text('4892',
                        style: TextStyle(
                            color: Color(0xFF25D366),
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 8)),
                    const SizedBox(height: 10),
                    const Text('شارك هذا الكود مع الكابتن عند التسليم',
                        style: TextStyle(
                            color: Colors.black54, fontSize: 11),
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _timelineItem(Map<String, dynamic> step, bool done, bool active, int i) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // خط زمني
          Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: done
                      ? const Color(0xFF25D366)
                      : Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
                child: Icon(step['icon'] as IconData,
                    color: Colors.white, size: 20),
              ),
              if (i < _steps.length - 1)
                Expanded(
                  child: Container(
                    width: 3,
                    color: done && i < _currentStep
                        ? const Color(0xFF25D366)
                        : Colors.grey.shade300,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 15),
          // تفاصيل
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(step['title'],
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: done
                                  ? const Color(0xFF2B2D42)
                                  : Colors.grey)),
                      if (active) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('الآن',
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(step['subtitle'],
                      style: const TextStyle(
                          fontSize: 12, color: Colors.black54)),
                  const SizedBox(height: 4),
                  Text(step['time'],
                      style: const TextStyle(
                          fontSize: 10, color: Colors.grey)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
