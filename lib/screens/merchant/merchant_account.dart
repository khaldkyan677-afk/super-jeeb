import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'merchant_theme.dart';

class MerchantAccountScreen extends StatelessWidget {
  const MerchantAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MJ.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('الحساب', style: MJ.h1),
              const SizedBox(height: 16),
              _profileCard(),
              const SizedBox(height: 18),
              _section('إدارة المتجر', [
                _item(Icons.storefront_rounded, 'بيانات المتجر', () {}),
                _item(Icons.business_center_rounded, 'الفروع', () {}),
                _item(Icons.group_rounded, 'الموظفون والصلاحيات', () {}),
                _item(Icons.attach_money_rounded, 'الحساب المالي', () {}),
                _item(Icons.credit_card_rounded, 'طرق الدفع', () {}),
              ]),
              const SizedBox(height: 14),
              _section('التحليلات والتقارير', [
                _item(Icons.bar_chart_rounded, 'التحليلات', () {}),
                _item(Icons.receipt_long_rounded, 'الفواتير', () {}),
                _item(Icons.people_alt_rounded, 'العملاء', () {}),
              ]),
              const SizedBox(height: 14),
              _section('الإعدادات', [
                _item(Icons.notifications_rounded, 'الإشعارات', () {}),
                _item(Icons.help_outline_rounded, 'الدعم والمساعدة', () {}),
                _item(Icons.policy_rounded, 'الشروط والسياسات', () {}),
                _item(Icons.info_rounded, 'عن التطبيق', () {}),
              ]),
              const SizedBox(height: 20),
              _logoutButton(context),
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
        gradient: const LinearGradient(colors: [MJ.primary, MJ.primaryLight], begin: Alignment.topRight, end: Alignment.bottomLeft),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: MJ.primary.withValues(alpha: 0.25), blurRadius: 18, offset: const Offset(0, 6))],
      ),
      child: Row(
        children: [
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
            child: Icon(Icons.storefront_rounded, color: MJ.primary, size: 32),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('متجر الفواكه الطازجة', style: GoogleFonts.cairo(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text('خالد يحيى', style: GoogleFonts.cairo(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 2),
                Text('+967 777 000 000', style: GoogleFonts.cairo(color: Colors.white70, fontSize: 11)),
              ],
            ),
          ),
          Icon(Icons.edit_rounded, color: Colors.white70, size: 20),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> items) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(color: MJ.card, borderRadius: BorderRadius.circular(18), boxShadow: MJ.shadowSoft),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
            child: Text(title, style: MJ.h3.copyWith(fontSize: 13)),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _item(IconData ic, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: MJ.softPink, borderRadius: BorderRadius.circular(10)),
              child: Icon(ic, color: MJ.primary, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: MJ.body.copyWith(fontSize: 13, fontWeight: FontWeight.w600))),
            Icon(Icons.chevron_left_rounded, color: MJ.textMuted),
          ],
        ),
      ),
    );
  }

  Widget _logoutButton(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              backgroundColor: MJ.card,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text('تسجيل الخروج', style: MJ.h3),
              content: Text('هل تريد الخروج من التطبيق؟', style: MJ.body),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: Text('إلغاء', style: GoogleFonts.cairo(color: MJ.textMuted))),
                TextButton(onPressed: () => Navigator.pop(context), child: Text('خروج', style: GoogleFonts.cairo(color: MJ.danger, fontWeight: FontWeight.w800))),
              ],
            ),
          );
        },
        icon: Icon(Icons.logout_rounded, color: MJ.danger),
        label: Text('تسجيل الخروج', style: GoogleFonts.cairo(color: MJ.danger, fontSize: 14, fontWeight: FontWeight.w800)),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: MJ.danger, width: 1.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}
