import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderTrackingScreen extends StatelessWidget {
  final Map<String, dynamic> order;
  const OrderTrackingScreen({super.key, required this.order});

  int _stepFromStatus(String s) {
    switch (s) {
      case 'pending': return 0;
      case 'accepted': return 1;
      case 'preparing': return 2;
      case 'ready': return 2;
      case 'on_the_way': return 3;
      case 'delivered': return 4;
      default: return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = (order['status'] ?? 'pending').toString();
    final verif = (order['verificationStatus'] ?? 'none').toString();
    final currentStep = _stepFromStatus(status);
    final driver = order['driverId'];
    final customer = order['customerId'];
    final store = order['storeId'];
    final storeName = store is Map ? (store['name'] ?? '') : '';
    final pin = (order['pin'] ?? '').toString();
    final showPin = status == 'on_the_way' || status == 'delivered';
    final showDriver = driver != null && driver is Map;

    final steps = [
      {'t': 'تم إنشاء الطلب', 's': 'طلبك في النظام', 'icon': Icons.receipt_long},
      {'t': 'تم إرسال طلبك للتاجر', 's': 'التاجر سيتواصل معك', 'icon': Icons.storefront},
      {'t': 'جاري التحضير', 's': 'المتجر يجهّز طلبك', 'icon': Icons.restaurant},
      {'t': 'في الطريق', 's': 'المندوب في طريقه إليك', 'icon': Icons.delivery_dining},
      {'t': 'تم التسليم', 's': 'استلمت طلبك بنجاح', 'icon': Icons.check_circle},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2D42),
        leading: const BackButton(color: Colors.white),
        title: Text('تتبع الطلب',
          style: GoogleFonts.cairo(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 220,
              width: double.infinity,
              color: const Color(0xFF2B2D42).withValues(alpha: 0.05),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        status == 'delivered' ? Icons.check_circle : Icons.delivery_dining,
                        color: status == 'delivered' ? const Color(0xFF25D366) : const Color(0xFF2B2D42),
                        size: 80,
                      ),
                      const SizedBox(height: 10),
                      Text(_statusLabel(status, verif),
                        style: GoogleFonts.cairo(color: const Color(0xFF2B2D42), fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      if (storeName.isNotEmpty)
                        Text(storeName, style: GoogleFonts.cairo(color: Colors.black54, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
            if (showDriver)
              Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: const Color(0xFF2B2D42),
                        child: const Icon(Icons.person, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('المندوب',
                              style: GoogleFonts.cairo(color: Colors.grey, fontSize: 12)),
                            const SizedBox(height: 2),
                            Text((driver['name'] ?? 'مندوب').toString(),
                              style: GoogleFonts.cairo(color: const Color(0xFF2B2D42), fontSize: 15, fontWeight: FontWeight.bold)),
                            if (customer is Map && customer['phone'] != null)
                              Text((driver['phone'] ?? '').toString(),
                                style: GoogleFonts.cairo(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                      IconButton(icon: const Icon(Icons.phone, color: Color(0xFF25D366)), onPressed: () {}),
                      IconButton(icon: const Icon(Icons.chat, color: Color(0xFF2B2D42)), onPressed: () {}),
                    ],
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('حالة الطلب',
                      style: GoogleFonts.cairo(color: const Color(0xFF2B2D42), fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ...List.generate(steps.length, (i) {
                      final isDone = i <= currentStep;
                      final isCurrent = i == currentStep;
                      final color = isDone ? const Color(0xFF25D366) : Colors.grey.shade300;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: isDone ? color : Colors.grey.shade200,
                                shape: BoxShape.circle,
                                border: isCurrent ? Border.all(color: color, width: 3) : null,
                              ),
                              child: Icon(steps[i]['icon'] as IconData, color: isDone ? Colors.white : Colors.grey, size: 18),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(steps[i]['t'] as String,
                                    style: GoogleFonts.cairo(
                                      color: isDone ? const Color(0xFF2B2D42) : Colors.grey,
                                      fontSize: 14,
                                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600)),
                                  const SizedBox(height: 2),
                                  Text(steps[i]['s'] as String,
                                    style: GoogleFonts.cairo(color: Colors.grey, fontSize: 12)),
                                ],
                              ),
                            ),
                            if (isDone) Icon(Icons.check_circle, color: color, size: 20),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            if (showPin && pin.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF25D366).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: const Color(0xFF25D366).withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.lock_outline, color: Color(0xFF25D366), size: 20),
                          const SizedBox(width: 8),
                          Text('كود التسليم OTP',
                            style: GoogleFonts.cairo(color: const Color(0xFF2B2D42), fontSize: 14, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(pin,
                        style: GoogleFonts.cairo(color: const Color(0xFF25D366), fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: 8)),
                      const SizedBox(height: 8),
                      Text('شارك هذا الكود مع المندوب عند التسليم',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(color: Colors.grey, fontSize: 12)),
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

  String _statusLabel(String s, String verif) {
    if (verif == 'pending') return 'قيد المراجعة';
    if (verif == 'rejected') return 'مرفوض';
    switch (s) {
      case 'pending': return 'بانتظار الموافقة';
      case 'accepted': return 'تم القبول';
      case 'preparing': return 'جاري التحضير';
      case 'ready': return 'جاهز للتوصيل';
      case 'on_the_way': return 'في الطريق';
      case 'delivered': return 'تم التسليم';
      case 'cancelled': return 'ملغي';
      default: return 'قيد المعالجة';
    }
  }
}
