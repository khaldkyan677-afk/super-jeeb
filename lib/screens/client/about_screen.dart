import 'package:flutter/material.dart';
import '../../widgets/sj_logo.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2D42),
        title: const Text('عن التطبيق',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        leading: const BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const SJLogo(size: 130),
            const SizedBox(height: 20),
            const Text('Super Jeeb',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2B2D42))),
            const SizedBox(height: 5),
            const Text('الإصدار 1.0.0',
                style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Text(
                'تطبيق سوبر جيب هو منصة يمنية تربط العميل والتاجر والمندوب.',
                style: TextStyle(
                    fontSize: 13, height: 1.6, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            _section('المميزات'),
            _item(Icons.shopping_cart, 'تسوق من متاجر متعددة'),
            _item(Icons.delivery_dining, 'توصيل سريع وآمن'),
            _item(Icons.payment, 'دفع كاش أو محفظة إلكترونية'),
            _item(Icons.lock, 'تتبع مباشر مع OTP'),
            _item(Icons.support_agent, 'دعم فني 24/7'),
            const SizedBox(height: 20),
            _section('تواصل معنا'),
            _contact(Icons.phone, 'اتصال مباشر', '800 1234'),
            _contact(Icons.email, 'البريد الإلكتروني', 'support@superjeeb.com'),
            _contact(Icons.language, 'الموقع', 'www.superjeeb.com'),
            const SizedBox(height: 20),
            _section('قانوني'),
            _policyTile(context, 'الشروط والأحكام'),
            _policyTile(context, 'سياسة الخصوصية'),
            _policyTile(context, 'إخلاء المسؤولية'),
            const SizedBox(height: 30),
            const Text('© 2026 Super Jeeb',
                style: TextStyle(color: Colors.grey, fontSize: 11)),
            const SizedBox(height: 10),
            const Text('صُنع بحب في اليمن 🇾🇪',
                style: TextStyle(color: Colors.grey, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _section(String t) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(t,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2B2D42))),
      ),
    );
  }

  Widget _item(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFEF233C), size: 22),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _contact(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF25D366), size: 22),
          const SizedBox(width: 12),
          Expanded(
              child: Text(title, style: const TextStyle(fontSize: 13))),
          Text(value,
              style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _policyTile(BuildContext context, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading:
            const Icon(Icons.description, color: Color(0xFFEF233C), size: 22),
        title: Text(title, style: const TextStyle(fontSize: 13)),
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 16, color: Colors.grey),
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            builder: (_) => Container(
              padding: const EdgeInsets.all(20),
              height: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  const Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        'نص السياسة يُكتب هنا...\n\n'
                        '• البند الأول\n'
                        '• البند الثاني\n'
                        '• البند الثالث',
                        style: TextStyle(
                            fontSize: 13, height: 1.8, color: Colors.black87),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
