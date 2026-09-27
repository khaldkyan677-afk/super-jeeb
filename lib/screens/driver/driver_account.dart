import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'driver_theme.dart';

class DriverAccountScreen extends StatelessWidget {
  const DriverAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DJ.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('الحساب', style: DJ.h1),
              const SizedBox(height: 16),
              _profileCard(),
              const SizedBox(height: 18),
              _section('مركبتي', [
                _item(Icons.directions_car_rounded, 'بيانات المركبة', ''),
                _item(Icons.description_rounded, 'وثائق المركبة', ''),
                _item(Icons.add_circle_outline_rounded, 'إضافة مركبة', ''),
              ]),
              const SizedBox(height: 14),
              _section('خدماتي', [
                _item(Icons.handyman_rounded, 'إدارة الخدمات', ''),
                _item(Icons.location_city_rounded, 'مناطق العمل', ''),
                _item(Icons.access_time_rounded, 'أوقات العمل', ''),
                _item(Icons.attach_money_rounded, 'أسعار الخدمات', ''),
              ]),
              const SizedBox(height: 14),
              _section('السجل والتقييمات', [
                _item(Icons.history_rounded, 'سجل الرحلات', ''),
                _item(Icons.star_rounded, 'التقييمات', '4.8 ★'),
                _item(Icons.receipt_long_rounded, 'الفواتير', ''),
              ]),
              const SizedBox(height: 14),
              _section('الإعدادات', [
                _item(Icons.notifications_rounded, 'الإشعارات', ''),
                _item(Icons.help_outline_rounded, 'الدعم والمساعدة', ''),
                _item(Icons.policy_rounded, 'الشروط والسياسات', ''),
                _item(Icons.info_outline_rounded, 'عن التطبيق', ''),
              ]),
              const SizedBox(height: 20),
              _logout(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [DJ.primary, DJ.secondary], begin: Alignment.topRight, end: Alignment.bottomLeft),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: DJ.primary.withValues(alpha: 0.25), blurRadius: 18, offset: const Offset(0, 6))],
      ),
      child: Row(
        children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Icon(Icons.person_rounded, color: DJ.primary, size: 34),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('أحمد علي', style: GoogleFonts.cairo(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text('مندوب توصيل', style: GoogleFonts.cairo(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 2),
                Text('+967 777 111 222', style: GoogleFonts.cairo(color: Colors.white70, fontSize: 11)),
              ],
            ),
          ),
          const Icon(Icons.edit_rounded, color: Colors.white70, size: 20),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> items) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(color: DJ.card, borderRadius: BorderRadius.circular(18), boxShadow: DJ.shadowSoft),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
            child: Text(title, style: DJ.h3.copyWith(fontSize: 13)),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _item(IconData ic, String label, String trailing) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: DJ.softRed, borderRadius: BorderRadius.circular(10)),
              child: Icon(ic, color: DJ.primary, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: DJ.body.copyWith(fontSize: 13, fontWeight: FontWeight.w600))),
            if (trailing.isNotEmpty)
              Text(trailing, style: GoogleFonts.cairo(color: DJ.primary, fontWeight: FontWeight.w800, fontSize: 12)),
            const SizedBox(width: 6),
            Icon(Icons.chevron_left_rounded, color: DJ.textMuted),
          ],
        ),
      ),
    );
  }

  Widget _logout(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              backgroundColor: DJ.card,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text('تسجيل الخروج', style: DJ.h3),
              content: Text('هل تريد الخروج من التطبيق؟', style: DJ.body),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: Text('إلغاء', style: GoogleFonts.cairo(color: DJ.textMuted))),
                TextButton(onPressed: () => Navigator.pop(context), child: Text('خروج', style: GoogleFonts.cairo(color: DJ.danger, fontWeight: FontWeight.w800))),
              ],
            ),
          );
        },
        icon: Icon(Icons.logout_rounded, color: DJ.danger),
        label: Text('تسجيل الخروج', style: GoogleFonts.cairo(color: DJ.danger, fontSize: 14, fontWeight: FontWeight.w800)),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: DJ.danger, width: 1.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}
