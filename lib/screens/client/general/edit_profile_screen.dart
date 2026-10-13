import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../services/auth_service.dart';
import '../../../services/api_service.dart';
import 'package:google_fonts/google_fonts.dart';

const _kRed = Color(0xFFEF233C);
const _kBg = Color(0xFF0D0D12);
const _kSurface = Color(0xFF1A1B26);
const _kGreen = Color(0xFF25D366);

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  String _city = 'صنعاء';
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _name.text = AuthService.instance.getUserName();
    _phone.text = AuthService.instance.getUserPhone();
    _email.text = AuthService.instance.getUserEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: _kBg, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: Text('تعديل الملف الشخصي', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _avatar(),
          const SizedBox(height: 24),
          _field('الاسم الكامل', _name, Icons.person_outline),
          _field('رقم الهاتف', _phone, Icons.phone_outlined),
          _field('البريد الإلكتروني', _email, Icons.email_outlined, enabled: false),
          const SizedBox(height: 12),
          Text('المدينة', style: GoogleFonts.cairo(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 8),
          _cityDropdown(),
          const SizedBox(height: 30),
          _saveBtn(),
        ],
      ),
    );
  }

  Widget _avatar() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 100, height: 100,
            decoration: BoxDecoration(color: _kSurface, shape: BoxShape.circle, border: Border.all(color: _kRed, width: 3)),
            child: const Icon(Icons.person, color: _kRed, size: 54),
          ),
          Positioned(
            bottom: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: _kRed, shape: BoxShape.circle),
              child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, IconData icon, {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.cairo(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(color: _kSurface, borderRadius: BorderRadius.circular(14)),
            child: TextField(
              controller: ctrl,
              enabled: enabled,
              textAlign: TextAlign.right,
              style: GoogleFonts.cairo(color: enabled ? Colors.white : Colors.grey),
              decoration: InputDecoration(
                prefixIcon: Icon(icon, color: _kRed, size: 20),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cityDropdown() {
    final cities = ['صنعاء', 'عدن', 'تعز', 'الحديدة', 'إب', 'المكلا'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: _kSurface, borderRadius: BorderRadius.circular(14)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _city,
          isExpanded: true,
          dropdownColor: _kSurface,
          icon: const Icon(Icons.arrow_drop_down, color: _kRed),
          items: cities.map((c) => DropdownMenuItem<String>(value: c, child: Text(c, style: GoogleFonts.cairo(color: Colors.white, fontSize: 14)))).toList(),
          onChanged: (v) => setState(() => _city = v ?? _city),
        ),
      ),
    );
  }

  Future<void> _doSave() async {
    setState(() => _saving = true);
    try {
      final r = await http.put(
        Uri.parse('\${ApiService.baseUrl}/api/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          if (ApiService.authToken != null) 'Authorization': 'Bearer \${ApiService.authToken}',
        },
        body: jsonEncode({
          'name': _name.text.trim(),
          'email': _email.text.trim(),
        }),
      );
      if (!mounted) return;
      if (r.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم حفط التعديلات بنجاح', style: GoogleFonts.cairo(color: Colors.white)), backgroundColor: _kGreen),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل الحفط: \${r.statusCode}', style: GoogleFonts.cairo(color: Colors.white)), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: \$e', style: GoogleFonts.cairo(color: Colors.white)), backgroundColor: Colors.red),
      );
    }
    if (mounted) setState(() => _saving = false);
  }

  Widget _saveBtn() {
    return GestureDetector(
        onTap: _saving ? null : _doSave,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: _kRed,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: _kRed.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6))],
        ),
        child: Center(child: Text('حفظ التعديلات', style: GoogleFonts.cairo(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700))),
      ),
    );
  }
}
