import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final faqs = [
      ['كيف أتابع طلبي؟', 'اذهب إلى "طلباتي" واختر الطلب لعرض الحالة والمندوب.'],
      ['كيف أطلب من متجر معين؟', 'اختر القسم (سوبرماركت/مطاعم...)، ثم اختر المتجر وأضف المنتجات.'],
      ['كيف أتواصل مع الدعم؟', 'يمكنك التواصل عبر زر "اتصل بنا" في هذه الصفحة.'],
      ['ما هي طرق الدفع؟', 'الدفع النقدي عند الاستلام، أو الدفع الإلكتروني عبر المحفظة.'],
      ['كيف أضيف عنواناً جديداً؟', 'من حسابي > العناوين > إضافة عنوان.'],
    ];
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D12),
      appBar: AppBar(backgroundColor: const Color(0xFF0D0D12), elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context)),
        title: Text('المساعدة والدعم', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.w600)),
        centerTitle: true),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text('الأسئلة الشائعة', style: GoogleFonts.cairo(color: const Color(0xFFEF233C),
          fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...faqs.map((f) => Container(margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(color: const Color(0xFF1A1B26), borderRadius: BorderRadius.circular(12)),
          child: ExpansionTile(
            iconColor: const Color(0xFFEF233C),
            collapsedIconColor: Colors.white,
            title: Text(f[0], style: GoogleFonts.cairo(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
            children: [Padding(padding: const EdgeInsets.all(14),
              child: Text(f[1], style: GoogleFonts.cairo(color: Colors.grey, fontSize: 13)))]))),
        const SizedBox(height: 16),
        Text('تواصل معنا', style: GoogleFonts.cairo(color: const Color(0xFFEF233C),
          fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        _contact(Icons.phone, 'اتصل بنا', '+967 777 000 000'),
        _contact(Icons.chat, 'دردشة مباشرة', 'متاح 24/7'),
        _contact(Icons.email, 'البريد الإلكتروني', 'support@superjeeb.com'),
      ]));
  }
  Widget _contact(IconData i, String t, String s) => Container(
    margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: const Color(0xFF1A1B26), borderRadius: BorderRadius.circular(12)),
    child: Row(children: [
      Container(width: 40, height: 40,
        decoration: BoxDecoration(color: const Color(0xFFEF233C).withOpacity(0.15),
          borderRadius: BorderRadius.circular(10)),
        child: Icon(i, color: const Color(0xFFEF233C), size: 20)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(t, style: GoogleFonts.cairo(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
        Text(s, style: GoogleFonts.cairo(color: Colors.grey, fontSize: 12)),
      ])),
    ]));
}
