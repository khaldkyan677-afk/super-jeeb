import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'merchant_theme.dart';

class MerchantStoreScreen extends StatefulWidget {
  const MerchantStoreScreen({super.key});
  @override
  State<MerchantStoreScreen> createState() => _MerchantStoreScreenState();
}

class _MerchantStoreScreenState extends State<MerchantStoreScreen> {
  bool _open = true;
  final _name = TextEditingController(text: 'متجر الفواكه الطازجة');
  final _desc = TextEditingController(text: 'فواكه وخضروات طازجة يومياً');
  final _phone = TextEditingController(text: '+967 777 000 000');
  final _address = TextEditingController(text: 'صنعاء - شارع حدة');

  @override
  void dispose() {
    _name.dispose(); _desc.dispose(); _phone.dispose(); _address.dispose();
    super.dispose();
  }

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
              Text('واجهة متجري', style: MJ.h1),
              const SizedBox(height: 4),
              Text('تحكم كامل في شكل متجرك', style: MJ.muted),
              const SizedBox(height: 18),

              _coverCard(),
              const SizedBox(height: 16),

              _switchRow('حالة المتجر', _open, (v) => setState(() => _open = v)),
              const SizedBox(height: 14),

              _sectionTitle('بيانات المتجر'),
              const SizedBox(height: 10),
              _field('اسم المتجر', _name, Icons.storefront_rounded),
              const SizedBox(height: 10),
              _field('وصف المتجر', _desc, Icons.description_rounded, maxLines: 3),
              const SizedBox(height: 10),
              _field('رقم التواصل', _phone, Icons.phone_rounded),
              const SizedBox(height: 10),
              _field('الموقع', _address, Icons.location_on_rounded),

              const SizedBox(height: 20),
              _sectionTitle('أوقات العمل'),
              const SizedBox(height: 10),
              _hoursCard(),

              const SizedBox(height: 20),
              _sectionTitle('الفئات'),
              const SizedBox(height: 10),
              _chipsRow(['فواكه', 'خضروات', 'عروض', 'طازج']),

              const SizedBox(height: 20),
              _sectionTitle('المنتجات المميزة'),
              const SizedBox(height: 10),
              _featuredNote(),

              const SizedBox(height: 24),
              _saveButton(),
              const SizedBox(height: 10),
              _previewButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _coverCard() {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [MJ.primary, MJ.primaryLight], begin: Alignment.topRight, end: Alignment.bottomLeft),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: MJ.primary.withValues(alpha: 0.25), blurRadius: 18, offset: const Offset(0, 6))],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 14, right: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                  Text('تغيير الغلاف', style: GoogleFonts.cairo(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -20, right: 16,
            child: Container(
              width: 80, height: 80,
              decoration: BoxDecoration(color: MJ.card, borderRadius: BorderRadius.circular(20), border: Border.all(color: MJ.bg, width: 4)),
              child: Icon(Icons.storefront_rounded, color: MJ.primary, size: 40),
            ),
          ),
        ],
      ),
    );
  }

  Widget _switchRow(String label, bool val, Function(bool) onChange) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: MJ.card, borderRadius: BorderRadius.circular(16), boxShadow: MJ.shadowSoft),
      child: Row(
        children: [
          Icon(val ? Icons.check_circle_rounded : Icons.cancel_rounded, color: val ? MJ.success : MJ.danger),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: MJ.body.copyWith(fontWeight: FontWeight.w700))),
          Text(val ? 'مفتوح الآن' : 'مغلق', style: GoogleFonts.cairo(color: val ? MJ.success : MJ.danger, fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(width: 8),
          Switch(value: val, activeThumbColor: MJ.primary, onChanged: onChange),
        ],
      ),
    );
  }

  Widget _sectionTitle(String t) => Text(t, style: MJ.h3);

  Widget _field(String hint, TextEditingController c, IconData ic, {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(color: MJ.card, borderRadius: BorderRadius.circular(14), boxShadow: MJ.shadowSoft),
      child: TextField(
        controller: c,
        maxLines: maxLines,
        style: GoogleFonts.cairo(),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.cairo(color: MJ.textMuted),
          prefixIcon: Icon(ic, color: MJ.primary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _hoursCard() {
    const days = ['السبت','الأحد','الإثنين','الثلاثاء','الأربعاء','الخميس','الجمعة'];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: MJ.card, borderRadius: BorderRadius.circular(16), boxShadow: MJ.shadowSoft),
      child: Column(
        children: days.map((d) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Expanded(child: Text(d, style: MJ.body.copyWith(fontWeight: FontWeight.w700, fontSize: 12))),
              Text('8:00 ص - 10:00 م', style: MJ.muted),
              const SizedBox(width: 10),
              Icon(Icons.edit_outlined, color: MJ.primary, size: 18),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _chipsRow(List<String> tags) {
    return Wrap(
      spacing: 8, runSpacing: 8,
      children: tags.map((t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(color: MJ.softPink, borderRadius: BorderRadius.circular(20), border: Border.all(color: MJ.primary.withValues(alpha: 0.15))),
        child: Text(t, style: GoogleFonts.cairo(color: MJ.primary, fontSize: 12, fontWeight: FontWeight.w700)),
      )).toList()..add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(color: MJ.card, borderRadius: BorderRadius.circular(20), border: Border.all(color: MJ.border)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_rounded, color: MJ.primary, size: 16),
              const SizedBox(width: 4),
              Text('إضافة', style: GoogleFonts.cairo(color: MJ.primary, fontSize: 12, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _featuredNote() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: MJ.softPink, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Icon(Icons.star_rounded, color: MJ.primary),
          const SizedBox(width: 10),
          Expanded(child: Text('اختر منتجات لتظهر في أعلى متجرك للعميل', style: MJ.body.copyWith(fontSize: 12))),
          Icon(Icons.chevron_left_rounded, color: MJ.primary),
        ],
      ),
    );
  }

  Widget _saveButton() {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم الحفظ', style: GoogleFonts.cairo()), backgroundColor: MJ.success),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: MJ.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: Text('حفظ التغييرات', style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w800)),
      ),
    );
  }

  Widget _previewButton() {
    return SizedBox(
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('معاينة المتجر كعميل', style: GoogleFonts.cairo()), backgroundColor: MJ.primary),
          );
        },
        icon: Icon(Icons.visibility_rounded, color: MJ.primary),
        label: Text('معاينة المتجر كعميل', style: GoogleFonts.cairo(color: MJ.primary, fontSize: 15, fontWeight: FontWeight.w800)),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: MJ.primary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}
