import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _kRed = Color(0xFFEF233C);
const _kBg = Color(0xFF0D0D12);
const _kSurface = Color(0xFF1A1B26);
const _kGold = Color(0xFFF0C107);
const _kGreen = Color(0xFF25D366);

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildQuickActions(),
            const SizedBox(height: 16),
            _buildStats(),
            const SizedBox(height: 20),
            _buildSectionTitle('حسابي'),
            _buildMenuItem(Icons.person_outline, 'تعديل الملف الشخصي', _kRed),
            _buildMenuItem(Icons.receipt_long_outlined, 'طلباتي', _kRed),
            _buildMenuItem(Icons.location_on_outlined, 'عناويني', _kRed),
            _buildMenuItem(Icons.favorite_border, 'المفضلة', _kRed),
            const SizedBox(height: 16),
            _buildSectionTitle('الإعدادات'),
            _buildMenuItem(Icons.notifications_none, 'الإشعارات', _kRed),
            _buildMenuItem(Icons.language, 'اللغة', _kRed),
            _buildMenuItem(Icons.help_outline, 'المساعدة والدعم', _kRed),
            _buildMenuItem(Icons.info_outline, 'عن التطبيق', _kRed),
            const SizedBox(height: 16),
            _buildLogout(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      decoration: const BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            width: 90, height: 90,
            decoration: BoxDecoration(
              color: _kBg,
              shape: BoxShape.circle,
              border: Border.all(color: _kRed, width: 3),
            ),
            child: const Icon(Icons.person, color: _kRed, size: 48),
          ),
          const SizedBox(height: 12),
          Text('خالد الأحمدي', style: GoogleFonts.cairo(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.verified, color: _kGreen, size: 16),
              const SizedBox(width: 4),
              Text('حساب موثق', style: GoogleFonts.cairo(color: _kGreen, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 4),
          Text('client@superjeeb.com', style: GoogleFonts.cairo(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _quickCard(Icons.storefront, 'قدّم كتاجر', 'افتح متجرك', _kGreen)),
          const SizedBox(width: 10),
          Expanded(child: _quickCard(Icons.delivery_dining, 'قدّم كمندوب', 'انضم ككابتن', _kGold)),
        ],
      ),
    );
  }

  Widget _quickCard(IconData icon, String title, String sub, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.4), width: 1.2),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 10),
          Text(title, style: GoogleFonts.cairo(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(sub, style: GoogleFonts.cairo(color: Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(color: _kSurface, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            _statItem('24', 'طلب', _kRed),
            _divider(),
            _statItem('1,250', 'نقطة', _kGreen),
            _divider(),
            _statItem('8,500', 'رصيد', _kGold),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String value, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: GoogleFonts.cairo(color: color, fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(label, style: GoogleFonts.cairo(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _divider() => Container(width: 1, height: 30, color: Colors.white12);

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Text(title, style: GoogleFonts.cairo(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: _kSurface, borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: GoogleFonts.cairo(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600))),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildLogout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _kSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _kRed.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout, color: _kRed, size: 20),
            const SizedBox(width: 10),
            Text('تسجيل الخروج', style: GoogleFonts.cairo(color: _kRed, fontSize: 14, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
