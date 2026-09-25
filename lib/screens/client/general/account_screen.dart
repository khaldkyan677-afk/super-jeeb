import 'become_merchant_screen.dart';
import 'become_driver_screen.dart';
import 'help_screen.dart';
import 'about_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'notifications_screen.dart';
import 'my_orders_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D12),
      appBar: AppBar(backgroundColor: const Color(0xFF0D0D12), elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context)),
        title: Text('حسابي', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.w600)),
        centerTitle: true),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Container(padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFF1A1B26),
            borderRadius: BorderRadius.circular(14)),
          child: Row(children: [
            Container(width: 60, height: 60,
              decoration: const BoxDecoration(color: Color(0xFFEF233C), shape: BoxShape.circle),
              child: const Icon(Icons.person, color: Colors.white, size: 30)),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('مستخدم Super Jeeb', style: GoogleFonts.cairo(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('+967 XXX XXX XXX', style: GoogleFonts.cairo(color: Colors.grey, fontSize: 13)),
            ])),
          ])),
        const SizedBox(height: 20),
        _item(context, Icons.receipt_long, 'طلباتي', 'تتبع طلباتك السابقة', MyOrdersScreen()),
        _item(context, Icons.favorite, 'المفضلة', 'متاجرك ومطاعمك المفضلة', FavoritesScreen()),
        _item(context, Icons.notifications, 'الإشعارات', 'تنبيهات الطلبات والعروض', NotificationsScreen()),
        _item(context, Icons.settings, 'الإعدادات', 'اللغة، الأمان، الخصوصية', SettingsScreen()),
        const SizedBox(height: 20),
        _item(context, Icons.storefront, 'قدّم كتاجر', 'أضف متجرك وابدأ البيع', const BecomeMerchantScreen()),
        _item(context, Icons.delivery_dining, 'قدّم كمندوب', 'اكسب من التوصيل', const BecomeDriverScreen()),
        const SizedBox(height: 20),
        _item(context, Icons.help_outline, 'المساعدة والدعم', 'أسئلة شائعة وتواصل', const HelpScreen()),
        _item(context, Icons.info_outline, 'عن التطبيق', 'الشروط والإصدار', const AboutScreen()),
        const SizedBox(height: 20),
        SizedBox(width: double.infinity, child: OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.logout, color: Color(0xFFEF233C)),
          label: Text('تسجيل الخروج', style: GoogleFonts.cairo(
            color: const Color(0xFFEF233C), fontWeight: FontWeight.w600)),
          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14),
            side: const BorderSide(color: Color(0xFFEF233C)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
      ]));
  }

  Widget _item(BuildContext c, IconData icon, String title, String sub, Widget page) {
    return GestureDetector(
      onTap: () => Navigator.push(c, MaterialPageRoute(builder: (_) => page)),
      child: Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: const Color(0xFF1A1B26), borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          Container(width: 40, height: 40,
            decoration: BoxDecoration(color: const Color(0xFFEF233C).withOpacity(0.15),
              borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: const Color(0xFFEF233C), size: 20)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: GoogleFonts.cairo(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(sub, style: GoogleFonts.cairo(color: Colors.grey, fontSize: 11)),
          ])),
          const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
        ])));
  }
}
