import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BecomeMerchantScreen extends StatefulWidget {
  const BecomeMerchantScreen({super.key});
  @override
  State<BecomeMerchantScreen> createState() => _S();
}
class _S extends State<BecomeMerchantScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _store = TextEditingController();
  String _category = 'سوبرماركت';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D12),
      appBar: AppBar(backgroundColor: const Color(0xFF0D0D12), elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context)),
        title: Text('قدّم كتاجر', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.w600)),
        centerTitle: true),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        _head('انضم إلى Super Jeeb كتاجر', 'أضف متجرك وابدأ البيع خلال دقائق'),
        const SizedBox(height: 20),
        _field('الاسم الكامل', _name),
        _field('رقم الهاتف', _phone, keyboard: TextInputType.phone),
        _field('اسم المتجر', _store),
        const SizedBox(height: 10),
        Text('القسم', style: GoogleFonts.cairo(color: Colors.white, fontSize: 13)),
        const SizedBox(height: 8),
        Container(padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: const Color(0xFF1A1B26), borderRadius: BorderRadius.circular(12)),
          child: DropdownButton<String>(value: _category, isExpanded: true, dropdownColor: const Color(0xFF1A1B26),
            underline: const SizedBox(),
            items: ['سوبرماركت','مطاعم','متاجر','بقالة'].map((e) => DropdownMenuItem(value: e,
              child: Text(e, style: GoogleFonts.cairo(color: Colors.white)))).toList(),
            onChanged: (v) => setState(() => _category = v!))),
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
  Widget _head(String t, String s) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(t, style: GoogleFonts.cairo(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
    const SizedBox(height: 6),
    Text(s, style: GoogleFonts.cairo(color: Colors.grey, fontSize: 13))]);
  Widget _field(String h, TextEditingController c, {TextInputType? keyboard}) =>
    Padding(padding: const EdgeInsets.only(bottom: 12),
      child: TextField(controller: c, keyboardType: keyboard, textAlign: TextAlign.right,
        style: GoogleFonts.cairo(color: Colors.white),
        decoration: InputDecoration(hintText: h, hintStyle: GoogleFonts.cairo(color: Colors.grey),
          filled: true, fillColor: const Color(0xFF1A1B26),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))));
}
