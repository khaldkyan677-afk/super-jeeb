import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D12),
      appBar: AppBar(backgroundColor: const Color(0xFF0D0D12), elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context)),
        title: Text('عن التطبيق', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.w600)),
        centerTitle: true),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const SizedBox(height: 20),
        Center(child: Container(width: 100, height: 100,
          decoration: BoxDecoration(color: const Color(0xFF1A1B26), borderRadius: BorderRadius.circular(24)),
          child: Center(child: Text('SJ', style: GoogleFonts.cairo(
            color: const Color(0xFFEF233C), fontSize: 36, fontWeight: FontWeight.bold))))),
        const SizedBox(height: 16),
        Center(child: Text('Super Jeeb', style: GoogleFonts.cairo(
          color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))),
        const SizedBox(height: 6),
        Center(child: Text('الإصدار 1.0.0', style: GoogleFonts.cairo(color: Colors.grey, fontSize: 13))),
        const SizedBox(height: 30),
        _item('الشروط والأحكام', () {}),
        _item('سياسة الخصوصية', () {}),
        _item('سياسة الاسترجاع', () {}),
        _item('شارك التطبيق', () {}),
        _item('قيّم التطبيق', () {}),
        const SizedBox(height: 30),
        Center(child: Text('© 2026 Super Jeeb. جميع الحقوق محفوظة',
          style: GoogleFonts.cairo(color: Colors.grey, fontSize: 11))),
      ]));
  }
  Widget _item(String t, VoidCallback f) => GestureDetector(onTap: f,
    child: Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFF1A1B26), borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Expanded(child: Text(t, style: GoogleFonts.cairo(color: Colors.white, fontSize: 14))),
        const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
      ])));
}
