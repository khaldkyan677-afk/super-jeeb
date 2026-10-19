import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'general/become_merchant_screen.dart';
import 'general/become_driver_screen.dart';

class AccountHubScreen extends StatefulWidget {
  const AccountHubScreen({super.key});

  @override
  State<AccountHubScreen> createState() => _AccountHubScreenState();
}

class _AccountHubScreenState extends State<AccountHubScreen> {
  bool _isMerchantPending = false;
  bool _isDriverPending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E000C),
      appBar: AppBar(
        title: const Text('حسابي'),
        backgroundColor: const Color(0xFF3D0018),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildUpgradeCard(
                    title: _isMerchantPending ? 'قيد المراجعة' : 'كن تاجر',
                    subtitle: _isMerchantPending ? 'بانتظار الإدارة' : 'ابدأ تجارتك الآن',
                    icon: Icons.storefront,
                    color: _isMerchantPending ? Colors.grey : const Color(0xFF25D366),
                    onTap: _isMerchantPending ? () {} : () async {
                      final res = await Navigator.push(context, MaterialPageRoute(builder: (_) => const BecomeMerchantScreen()));
                      if (res == true) setState(() => _isMerchantPending = true);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildUpgradeCard(
                    title: _isDriverPending ? 'قيد المراجعة' : 'كن مندوب',
                    subtitle: _isDriverPending ? 'بانتظار الإدارة' : 'للتوصيل السريع',
                    icon: Icons.delivery_dining,
                    color: _isDriverPending ? Colors.grey : Colors.orange,
                    onTap: _isDriverPending ? () {} : () async {
                      final res = await Navigator.push(context, MaterialPageRoute(builder: (_) => const BecomeDriverScreen()));
                      if (res == true) setState(() => _isDriverPending = true);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            _buildMenuItem(Icons.person, 'الملف الشخصي', () {}),
            _buildMenuItem(Icons.security, 'الأمان', () {}),
            _buildMenuItem(Icons.devices, 'الأجهزة', () {}),
            _buildMenuItem(Icons.policy, 'الشروط والخصوصية', () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildUpgradeCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(title, style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold)),
            Text(subtitle, style: GoogleFonts.cairo(color: Colors.white54, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.amber),
      title: Text(title, style: GoogleFonts.cairo(color: Colors.white)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 14),
      onTap: onTap,
    );
  }
}
