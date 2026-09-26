import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'client/client_app.dart';
import 'merchant/merchant_app.dart';
import 'driver/driver_app.dart';
import 'admin/admin_app.dart';

const _kRed = Color(0xFFEF233C);
const _kBg = Color(0xFF0D0D12);
const _kSurface = Color(0xFF1A1B26);
const _kGreen = Color(0xFF25D366);
const _kGold = Color(0xFFF0C107);

class DevSelectorScreen extends StatelessWidget {
  const DevSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(color: _kRed.withOpacity(0.15), shape: BoxShape.circle, border: Border.all(color: _kRed, width: 2)),
                child: const Icon(Icons.shield, color: _kRed, size: 44),
              ),
              const SizedBox(height: 16),
              Text('وضع المطوّر', style: GoogleFonts.cairo(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text('اختر التطبيق للدخول إليه', style: GoogleFonts.cairo(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 40),
              Row(children: [
                Expanded(child: _card(context, 'العميل', Icons.phone_android, _kRed, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ClientApp())))),
                const SizedBox(width: 12),
                Expanded(child: _card(context, 'التاجر', Icons.storefront, _kGreen, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MerchantApp())))),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: _card(context, 'المندوب', Icons.delivery_dining, _kGold, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DriverApp())))),
                const SizedBox(width: 12),
                Expanded(child: _card(context, 'الأدمن', Icons.admin_panel_settings, _kRed, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminApp())))),
              ]),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                  decoration: BoxDecoration(color: _kSurface, borderRadius: BorderRadius.circular(14), border: Border.all(color: _kRed.withOpacity(0.4))),
                  child: Text('خروج', style: GoogleFonts.cairo(color: _kRed, fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card(BuildContext ctx, String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: _kSurface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.5), width: 1.5),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(height: 12),
            Text(title, style: GoogleFonts.cairo(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
