import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _biometricEnabled = false;
  bool _twoFactorEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E000C),
      appBar: AppBar(
        title: const Text('الأمان'),
        backgroundColor: const Color(0xFF3D0018),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('إعدادات الحماية'),
          Card(
            color: const Color(0xFF3D0018),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: SwitchListTile(
              title: Text('تفعيل البصمة (Face ID / Touch ID)', style: GoogleFonts.cairo(color: Colors.white)),
              secondary: const Icon(Icons.fingerprint, color: Colors.amber),
              activeThumbColor: Colors.green,
              value: _biometricEnabled,
              onChanged: (val) => setState(() => _biometricEnabled = val),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            color: const Color(0xFF3D0018),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: SwitchListTile(
              title: Text('التحقق بخطوتين (2FA)', style: GoogleFonts.cairo(color: Colors.white)),
              secondary: const Icon(Icons.verified_user, color: Colors.amber),
              activeThumbColor: Colors.green,
              value: _twoFactorEnabled,
              onChanged: (val) => setState(() => _twoFactorEnabled = val),
            ),
          ),
          
          const SizedBox(height: 24),
          _buildSectionTitle('بيانات الدخول'),
          _buildActionTile(Icons.lock, 'تغيير كلمة المرور', () {}),
          _buildActionTile(Icons.phone, 'تغيير رقم الهاتف', () {}),
          _buildActionTile(Icons.email, 'تغيير البريد الإلكتروني', () {}),
          
          const SizedBox(height: 24),
          _buildSectionTitle('الأجهزة'),
          _buildActionTile(Icons.devices, 'إدارة الأجهزة المتصلة', () {}),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 8),
      child: Text(title, style: GoogleFonts.cairo(color: Colors.white70, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildActionTile(IconData icon, String title, VoidCallback onTap) {
    return Card(
      color: const Color(0xFF3D0018),
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.amber),
        title: Text(title, style: GoogleFonts.cairo(color: Colors.white)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 14),
        onTap: onTap,
      ),
    );
  }
}
