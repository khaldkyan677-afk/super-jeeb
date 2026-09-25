import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notif = true;
  String _lang = 'العربية';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D12),
      appBar: AppBar(backgroundColor: const Color(0xFF0D0D12), elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context)),
        title: Text('الإعدادات', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.w600)),
        centerTitle: true),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        _section('التطبيق'),
        _switchTile('الإشعارات', _notif, (v) => setState(() => _notif = v)),
        _textTile('اللغة', _lang, () => setState(() => _lang = _lang == 'العربية' ? 'English' : 'العربية')),
        const SizedBox(height: 16),
        _section('الأمان'),
        _textTile('تغيير كلمة المرور', '', () {}),
        _textTile('المصادقة الثنائية', 'معطلة', () {}),
        const SizedBox(height: 16),
        _section('عن التطبيق'),
        _textTile('الإصدار', '1.0.0', () {}),
        _textTile('سياسة الخصوصية', '', () {}),
      ]));
  }

  Widget _section(String t) => Padding(padding: const EdgeInsets.only(bottom: 8, top: 8),
    child: Text(t, style: GoogleFonts.cairo(color: const Color(0xFFEF233C),
      fontSize: 13, fontWeight: FontWeight.bold)));

  Widget _switchTile(String t, bool v, ValueChanged<bool> f) =>
    Container(margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: const Color(0xFF1A1B26), borderRadius: BorderRadius.circular(12)),
      child: SwitchListTile(title: Text(t, style: GoogleFonts.cairo(color: Colors.white, fontSize: 14)),
        value: v, onChanged: f, activeColor: const Color(0xFFEF233C)));

  Widget _textTile(String t, String sub, VoidCallback f) =>
    GestureDetector(onTap: f, child: Container(margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFF1A1B26), borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Expanded(child: Text(t, style: GoogleFonts.cairo(color: Colors.white, fontSize: 14))),
        if (sub.isNotEmpty) Text(sub, style: GoogleFonts.cairo(color: Colors.grey, fontSize: 12)),
        const SizedBox(width: 8),
        const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
      ])));
}
