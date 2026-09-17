import 'package:flutter/material.dart';

class DriverAccountScreen extends StatelessWidget {
  const DriverAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1C2A),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _header(),
            const SizedBox(height: 20),
            _financialCard(),
            const SizedBox(height: 20),
            _quickStats(),
            const SizedBox(height: 20),
            _menuSection('حسابي', [
              _menu(context, Icons.person, 'تعديل الملف الشخصي',
                  'الاسم والصورة'),
              _menu(context, Icons.description, 'وثائقي',
                  'الرخصة، الهوية', color: Colors.blue),
              _menu(context, Icons.directions_car, 'مركبتي',
                  'النوع واللوحة'),
              _menu(context, Icons.star, 'تقييماتي',
                  '4.9 من 5', color: Colors.amber),
              _menu(context, Icons.emoji_events, 'إنجازاتي',
                  'الشارات والمكافآت', color: const Color(0xFFD4AF37)),
            ]),
            _menuSection('المحفظة', [
              _menu(context, Icons.account_balance_wallet, 'المحفظة',
                  'الرصيد والمديونية',
                  color: const Color(0xFF25D366)),
              _menu(context, Icons.payment, 'طرق السحب',
                  'الكريمي، جيب'),
              _menu(context, Icons.history, 'سجل الأرباح',
                  'كل المعاملات'),
              _menu(context, Icons.request_quote, 'طلب سحب',
                  'تحويل للبنك'),
            ]),
            _menuSection('العمل', [
              _menu(context, Icons.map, 'مناطق العمل',
                  'المناطق المفضلة'),
              _menu(context, Icons.schedule, 'جدول التوفر',
                  'الأيام والساعات'),
              _menu(context, Icons.category, 'أنواع الخدمة',
                  'تاكسي، فرزة، طرود'),
              _menu(context, Icons.pause_circle, 'وضع الراحة',
                  'إيقاف مؤقت', color: Colors.orange),
            ]),
            _menuSection('الإعدادات', [
              _menu(context, Icons.notifications, 'الإشعارات',
                  'تخصيص'),
              _menu(context, Icons.settings, 'الإعدادات',
                  'عامة'),
              _menu(context, Icons.lock, 'الأمان',
                  'كلمة السر'),
              _menu(context, Icons.emergency, 'جهات الطوارئ',
                  'SOS', color: const Color(0xFFEF233C)),
            ]),
            _menuSection('المساعدة', [
              _menu(context, Icons.support_agent, 'الدعم الفني',
                  'تواصل مباشر'),
              _menu(context, Icons.info, 'عن التطبيق',
                  'الإصدار'),
            ]),
            const SizedBox(height: 20),
            _logoutButton(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2B2D42), Color(0xFF1B1C2A)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity: 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.directions_car,
                          color: Colors.white, size: 80),
                      SizedBox(width: 30),
                      Icon(Icons.delivery_dining,
                          color: Colors.white, size: 80),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Color(0xFF25D366),
                    shape: BoxShape.circle,
                  ),
                  child: const CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person,
                        size: 48, color: Color(0xFF2B2D42)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('الكابتن خالد وليد',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF25D366).withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified,
                      color: Color(0xFF25D366), size: 14),
                  SizedBox(width: 5),
                  Text('كابتن موثق',
                      style: TextStyle(
                          color: Color(0xFF25D366),
                          fontSize: 11,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _financialCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFEF233C), Color(0xFF8B1428)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.warning_amber_rounded,
                    color: Colors.white70, size: 22),
                SizedBox(width: 8),
                Text('المديونية الحالية',
                    style: TextStyle(
                        color: Colors.white70, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 10),
            const Text('-3,500 YER',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFFEF233C),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.payments, size: 18),
                    label: const Text('تصفية',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.receipt_long,
                        color: Colors.white, size: 18),
                    label: const Text('الكشف',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Expanded(
            child: _stat('85', 'رحلة', const Color(0xFFEF233C),
                Icons.local_shipping),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _stat('4.9', 'تقييم', Colors.amber, Icons.star),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _stat('3', 'سنوات', const Color(0xFF25D366),
                Icons.emoji_events),
          ),
        ],
      ),
    );
  }

  Widget _stat(String value, String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 3),
          Text(label,
              style: const TextStyle(
                  fontSize: 9, color: Colors.white54),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _menuSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 15, 25, 8),
          child: Text(title,
              style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1)),
        ),
        ...items,
      ],
    );
  }

  Widget _menu(BuildContext context, IconData icon, String title,
      String subtitle, {Color? color}) {
    final c = color ?? const Color(0xFFEF233C);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: ListTile(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('فتح: $title')),
          );
        },
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: c.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: c, size: 20),
        ),
        title: Text(title,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        subtitle: Text(subtitle,
            style: const TextStyle(
                fontSize: 10, color: Colors.white54)),
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 14, color: Colors.white30),
      ),
    );
  }

  Widget _logoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFFEF233C)),
            minimumSize: const Size(0, 55),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)),
          ),
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.logout,
              color: Color(0xFFEF233C), size: 20),
          label: const Text('تسجيل الخروج',
              style: TextStyle(
                  color: Color(0xFFEF233C),
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
