import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BecomeDriverScreen extends StatefulWidget {
  const BecomeDriverScreen({super.key});
  @override
  State<BecomeDriverScreen> createState() => _S();
}
class _S extends State<BecomeDriverScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _vehicle = TextEditingController();
  final _plate = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D12),
      appBar: AppBar(backgroundColor: const Color(0xFF0D0D12), elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context)),
        title: Text('قدّم كمندوب', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.w600)),
        centerTitle: true),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text('انضم كـ مندوب Super Jeeb', style: GoogleFonts.cairo(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text('اكسب من توصيل الطلبات والرحلات', style: GoogleFonts.cairo(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 20),
        _field('الاسم الكامل', _name),
        _field('رقم الهاتف', _phone, keyboard: TextInputType.phone),
        _field('نوع المركبة (سيارة/دراجة/باص)', _vehicle),
        _field('رقم اللوحة', _plate),
        const SizedBox(height: 12),
        Container(padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: const Color(0xFF1A1B26), borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            const Icon(Icons.info_outline, color: Color(0xFFF0C107), size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text('سيتم طلب صورة الرخصة والهوية بعد الموافقة',
              style: GoogleFonts.cairo(color: Colors.grey, fontSize: 12)))])),
        const SizedBox(height: 24),
        SizedBox(width: double.infinity, child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF233C),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: const Color(0xFF25D366),
              content: Text('تم إرسال طلبك، سيتم التواصل معك', style: GoogleFonts.cairo(color: Colors.white))));
          },
          child: Text('إرسال الطلب', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)))),
      ]));
  }
  Widget _field(String h, TextEditingController c, {TextInputType? keyboard}) =>
    Padding(padding: const EdgeInsets.only(bottom: 12),
      child: TextField(controller: c, keyboardType: keyboard, textAlign: TextAlign.right,
        style: GoogleFonts.cairo(color: Colors.white),
        decoration: InputDecoration(hintText: h, hintStyle: GoogleFonts.cairo(color: Colors.grey),
          filled: true, fillColor: const Color(0xFF1A1B26),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))));
}
