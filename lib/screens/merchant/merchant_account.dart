import 'package:flutter/material.dart';

class MerchantAccountScreen extends StatelessWidget {
  const MerchantAccountScreen({super.key});

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
            _menuSection('إدارة المتجر', [
              _menu(context, Icons.store, 'تعديل المتجر', 'الاسم، الوصف'),
              _menu(context, Icons.schedule, 'ساعات العمل', 'الأوقات'),
              _menu(context, Icons.pause_circle, 'وضع العطلة', 'إيقاف مؤقت'),
              _menu(context, Icons.qr_code, 'QR المتجر', 'مشاركة'),
            ]),
            _menuSection('المحفظة', [
              _menu(context, Icons.account_balance_wallet, 'المحفظة',
                  'الرصيد', color: const Color(0xFF25D366)),
              _menu(context, Icons.request_quote, 'طلب سحب', 'تحويل'),
              _menu(context, Icons.history, 'سجل المعاملات', 'العمليات'),
            ]),
            _menuSection('الإعدادات', [
              _menu(context, Icons.notifications, 'الإشعارات', 'التنبيهات'),
              _menu(context, Icons.message, 'الدردشة', 'العملاء',
                  color: const Color(0xFF25D366)),
              _menu(context, Icons.settings, 'الإعدادات', 'التطبيق'),
              _menu(context, Icons.lock, 'الأمان', 'كلمة السر'),
            ]),
            _menuSection('المساعدة', [
              _menu(context, Icons.support_agent, 'الدعم', 'تواصل'),
              _menu(context, Icons.description, 'الشروط', 'العقد'),
              _menu(context, Icons.info, 'عن التطبيق', 'الإصدار'),
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
      height: 230,
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
            Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: Color(0xFFEF233C),
                shape: BoxShape.circle,
              ),
              child: const CircleAvatar(
                radius: 45,
                backgroundColor: Colors.white,
                child: Icon(Icons.storefront,
                    size: 48, color: Color(0xFF2B2D42)),
              ),
            ),
            const SizedBox(height: 12),
            const Text('متجر الأناقة',
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
                  Icon(Icons.check_circle,
                      color: Color(0xFF25D366), size: 14),
                  SizedBox(width: 5),
                  Text('متجر موثق',
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
            colors: [Color(0xFF25D366), Color(0xFF1a9e4f)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.account_balance_wallet,
                    color: Colors.white70, size: 22),
                SizedBox(width: 8),
                Text('رصيد المبيعات',
                    style: TextStyle(
                        color: Colors.white70, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 10),
            const Text('75,000 YER',
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
                      foregroundColor: const Color(0xFF25D366),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.download, size: 18),
                    label: const Text('سحب',
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
                    label: const Text('التقرير',
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
            child: _stat('142', 'طلب', const Color(0xFFEF233C),
                Icons.receipt_long),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _stat('38', 'منتج', const Color(0xFF25D366),
                Icons.inventory),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _stat('4.8', 'تقييم', Colors.amber, Icons.star),
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
