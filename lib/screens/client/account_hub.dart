import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'general/become_merchant_screen.dart';
import 'general/become_driver_screen.dart';
import 'general/policy_screen.dart';
import 'general/edit_profile_screen.dart';
import 'settings_screen.dart';

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
            // 0. الكارت العلوي (بيانات المستخدم)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF5D001E), Color(0xFF3D0018)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE50914).withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.amber, width: 2),
                    ),
                    child: const CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.person, size: 40, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('مستخدم', style: GoogleFonts.cairo(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.verified, color: Colors.greenAccent, size: 14),
                              const SizedBox(width: 4),
                              Text('حساب موثق', style: GoogleFonts.cairo(color: Colors.greenAccent, fontSize: 11)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.amber),
                    onPressed: () {},
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 1. كرت التاجر والمندوب
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
            const SizedBox(height: 20),

            // 2. كرت الإحصائيات
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF3D0018),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('8500', 'رصيد', Colors.amber),
                  _buildStatItem('1250', 'نقطة', Colors.green),
                  _buildStatItem('24', 'طلب', Colors.red),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. الأقسام
            _buildSectionTitle('حسابي'),
            _buildMenuItem(Icons.person, 'الملف الشخصي', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()))),
            _buildMenuItem(Icons.receipt_long, 'طلباتي', () {}),
            _buildMenuItem(Icons.local_offer, 'كوبوناتي', () {}),
            _buildMenuItem(Icons.share, 'دعوة صديق', () {}),
            _buildMenuItem(Icons.favorite, 'المفضلة', () {}),
            _buildMenuItem(Icons.location_on, 'عناويني', () {}),

            const SizedBox(height: 16),
            _buildSectionTitle('الإعدادات'),
            _buildMenuItem(Icons.settings, 'الإعدادات', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()))),
            _buildMenuItem(Icons.notifications, 'الإشعارات', () {}),
            _buildMenuItem(Icons.security, 'الأمان', () {}),
            _buildMenuItem(Icons.policy, 'الشروط والخصوصية', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PolicyScreen(type: 'terms')))),
            _buildMenuItem(Icons.language, 'اللغة', () {}),
            _buildMenuItem(Icons.star, 'تقييم التطبيق', () {}),

            const SizedBox(height: 16),
            _buildSectionTitle('المساعدة'),
            _buildMenuItem(Icons.help_outline, 'المساعدة والدعم', () {}),
            _buildMenuItem(Icons.info_outline, 'عن التطبيق', () {}),
            _buildMenuItem(Icons.report_problem, 'الإبلاغ عن مشكلة', () {}),

            const SizedBox(height: 16),
            _buildSectionTitle('خطر'),
            _buildMenuItem(Icons.delete, 'حذف الحساب', () {}, textColor: Colors.red),

            const SizedBox(height: 20),
            // 4. زر تسجيل الخروج
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  // كود تسجيل الخروج
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text('تسجيل الخروج', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 40),
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

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.cairo(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: GoogleFonts.cairo(color: Colors.white54, fontSize: 12)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 8),
        child: Text(title, style: GoogleFonts.cairo(color: Colors.white70, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap, {Color textColor = Colors.white}) {
    return Card(
      color: const Color(0xFF3D0018),
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: textColor == Colors.white ? Colors.amber : textColor),
        title: Text(title, style: GoogleFonts.cairo(color: textColor)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 14),
        onTap: onTap,
      ),
    );
  }
}
