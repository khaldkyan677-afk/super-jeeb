import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../services/api_service.dart';
import 'merchant_theme.dart';

class MerchantStoreScreen extends StatefulWidget {
  const MerchantStoreScreen({super.key});
  @override
  State<MerchantStoreScreen> createState() => _MerchantStoreScreenState();
}

class _MerchantStoreScreenState extends State<MerchantStoreScreen> {
  final _name = TextEditingController();
  final _desc = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  bool _open = true;
  bool _loading = true;
  bool _saving = false;
  String _category = 'supermarket';

  final _categories = {
    'supermarket': 'سوبرماركت',
    'restaurant': 'مطاعم',
    'pharmacy': 'صيدليات',
    'grocery': 'بقالات',
    'mall': 'متاجر',
  };

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _name.dispose(); _desc.dispose(); _phone.dispose(); _address.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final r = await http.get(
        Uri.parse('${ApiService.baseUrl}/api/merchants/me/store'),
        headers: ApiService.getHeaders,
      );
      if (r.statusCode == 200) {
        final d = jsonDecode(r.body);
        final s = d['store'] ?? {};
        setState(() {
          _name.text = (s['name'] ?? '').toString();
          _desc.text = (s['description'] ?? '').toString();
          _phone.text = (s['phone'] ?? '').toString();
          final loc = s['location'];
          if (loc is Map) _address.text = (loc['address'] ?? '').toString();
          _open = s['isActive'] == true;
          final cat = (s['category'] ?? 'supermarket').toString();
          if (_categories.containsKey(cat)) _category = cat;
        });
      }
    } catch (e) { debugPrint('LOAD_ERR: $e'); }
    setState(() => _loading = false);
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('اكتب اسم المتجر', style: GoogleFonts.cairo(color: Colors.white)), backgroundColor: Colors.red),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final r = await http.put(
        Uri.parse('${ApiService.baseUrl}/api/merchants/me/store'),
        headers: {...ApiService.getHeaders, 'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _name.text.trim(),
          'description': _desc.text.trim(),
          'phone': _phone.text.trim(),
          'category': _category,
          'location': {'address': _address.text.trim()},
          'isActive': _open,
        }),
      );
      if (!mounted) return;
      if (r.statusCode < 300) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم حفظ بيانات المتجر', style: GoogleFonts.cairo(color: Colors.white)), backgroundColor: MJ.success),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل: ${r.statusCode}', style: GoogleFonts.cairo(color: Colors.white)), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: $e', style: GoogleFonts.cairo(color: Colors.white)), backgroundColor: Colors.red),
      );
    }
    if (mounted) setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(backgroundColor: MJ.bg, body: const Center(child: CircularProgressIndicator(color: MJ.primary)));
    }
    return Scaffold(
      backgroundColor: MJ.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('متجري', style: GoogleFonts.cairo(color: MJ.text, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('إدارة بيانات متجرك', style: GoogleFonts.cairo(color: MJ.textMuted, fontSize: 13)),
              const SizedBox(height: 18),
              _coverCard(),
              const SizedBox(height: 16),
              _switchRow('المتجر مفتوح', _open, (v) => setState(() => _open = v)),
              const SizedBox(height: 14),
              _sectionTitle('بيانات المتجر'),
              const SizedBox(height: 10),
              _field('اسم المتجر', _name, Icons.storefront_rounded),
              const SizedBox(height: 10),
              _field('وصف المتجر', _desc, Icons.description_outlined, maxLines: 3),
              const SizedBox(height: 10),
              _field('رقم الهاتف', _phone, Icons.phone_rounded),
              const SizedBox(height: 10),
              _field('العنوان', _address, Icons.location_on_rounded),
              const SizedBox(height: 20),
              _sectionTitle('تصنيف المتجر'),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: MJ.card,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: MJ.shadowSoft,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _category,
                    isExpanded: true,
                    dropdownColor: MJ.card,
                    style: GoogleFonts.cairo(color: MJ.text, fontSize: 14),
                    items: _categories.entries.map((e) => DropdownMenuItem(
                      value: e.key,
                      child: Text(e.value, style: GoogleFonts.cairo(color: MJ.text)),
                    )).toList(),
                    onChanged: (v) { if (v != null) setState(() => _category = v); },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MJ.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _saving ? null : _save,
                  child: _saving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text('حفظ التعديلات', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
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
                  Text('تغيير', style: GoogleFonts.cairo(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
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
          Expanded(child: Text(label, style: GoogleFonts.cairo(color: MJ.text, fontWeight: FontWeight.w700, fontSize: 13))),
          Text(val ? 'مفتوح' : 'مغلق', style: GoogleFonts.cairo(color: val ? MJ.success : MJ.danger, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Switch(value: val, activeThumbColor: MJ.primary, onChanged: onChange),
        ],
      ),
    );
  }

  Widget _sectionTitle(String t) => Text(t, style: GoogleFonts.cairo(color: MJ.text, fontSize: 15, fontWeight: FontWeight.bold));

  Widget _field(String hint, TextEditingController c, IconData ic, {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(color: MJ.card, borderRadius: BorderRadius.circular(14), boxShadow: MJ.shadowSoft),
      child: TextField(
        controller: c,
        maxLines: maxLines,
        style: GoogleFonts.cairo(color: MJ.text),
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
}
