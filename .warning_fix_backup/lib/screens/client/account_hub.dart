import 'package:flutter/material.dart';
import 'package:super_jeeb/widgets/password_field.dart';

import 'settings_screen.dart';
import 'notifications_screen.dart';
import 'favorites_screen.dart';
import 'help_screen.dart';
import 'about_screen.dart';
import 'my_orders_screen.dart';
import 'coupons_screen.dart';

class AccountHubScreen extends StatelessWidget {
  const AccountHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _header(),
            const SizedBox(height: 20),
            _upgradeSection(context),
            const SizedBox(height: 20),
            _quickStats(),
            const SizedBox(height: 20),
            _menuSection('حسابي', [
              _menu(
                Icons.person,
                'تعديل الملف الشخصي',
                () => _open(context, const EditProfileScreen()),
              ),
              _menu(
                Icons.receipt_long,
                'طلباتي',
                () => _open(context, const MyOrdersScreen()),
              ),
              _menu(
                Icons.favorite,
                'المفضلة',
                () => _open(context, const FavoritesScreen()),
              ),
              _menu(
                Icons.local_offer,
                'الكوبونات',
                () => _open(context, const CouponsScreen()),
              ),
            ]),
            _menuSection('الإعدادات', [
              _menu(
                Icons.settings,
                'الإعدادات العامة',
                () => _open(context, const SettingsScreen()),
              ),
              _menu(
                Icons.notifications_active,
                'الإشعارات',
                () => _open(context, const NotificationsScreen()),
              ),
              _menu(
                Icons.security,
                'الأمان',
                () => _open(context, const SecurityScreen()),
              ),
              _menu(
                Icons.devices,
                'الأجهزة المتصلة',
                () => _open(context, const DevicesScreen()),
              ),
            ]),
            _menuSection('المساعدة', [
              _menu(
                Icons.contact_support,
                'تواصل معنا',
                () => _open(context, const HelpScreen()),
              ),
              _menu(
                Icons.info_outline,
                'عن التطبيق',
                () => _open(context, const AboutScreen()),
              ),
              _menu(
                Icons.assignment,
                'الشروط والسياسات',
                () => _open(context, const AboutScreen()),
              ),
            ]),
            _menuSection('خطر', [
              _menu(
                Icons.delete_forever,
                'حذف الحساب',
                () => _confirmDelete(context),
                color: Colors.red,
              ),
            ]),
            const SizedBox(height: 15),
            _logoutButton(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      height: 240,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2B2D42), Color(0xFF1B1C2A)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 55, color: Color(0xFF2B2D42)),
            ),
            const SizedBox(height: 12),
            const Text(
              'خالد الأحمدي',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.verified, color: Color(0xFF25D366), size: 16),
                const SizedBox(width: 4),
                Text(
                  'حساب موثق',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'client@superjeeb.com',
              style: TextStyle(color: Colors.white60, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _upgradeSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Expanded(
            child: _upgradeCard(
              context,
              icon: Icons.storefront,
              title: 'قدّم كتاجر',
              subtitle: 'افتح متجرك',
              color: const Color(0xFF25D366),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _upgradeCard(
              context,
              icon: Icons.delivery_dining,
              title: 'قدّم كمندوب',
              subtitle: 'انضم ككابتن',
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _upgradeCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2B2D42),
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _quickStats() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          _stat('24', 'طلب', const Color(0xFFEF233C)),
          Container(width: 1, height: 40, color: Colors.grey.shade200),
          _stat('1,250', 'نقطة', const Color(0xFF25D366)),
          Container(width: 1, height: 40, color: Colors.grey.shade200),
          _stat('8,500', 'رصيد', const Color(0xFFD4AF37)),
        ],
      ),
    );
  }

  Widget _stat(String value, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _menuSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 15, 25, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
        ...items,
      ],
    );
  }

  Widget _menu(
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color? color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 5),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (color ?? const Color(0xFFEF233C)).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color ?? const Color(0xFFEF233C), size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: color ?? const Color(0xFF2B2D42),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }

  Widget _logoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFEF233C),
            minimumSize: const Size(0, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onPressed: () => _confirmLogout(context),
          icon: const Icon(Icons.logout, color: Colors.white),
          label: const Text(
            'تسجيل الخروج',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _open(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('تسجيل الخروج', style: TextStyle(fontSize: 16)),
        content: const Text('هل تريد تسجيل الخروج من حسابك؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF233C),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('خروج', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text('حذف الحساب', style: TextStyle(fontSize: 16)),
          ],
        ),
        content: const Text(
          'سيتم حذف حسابك وكل بياناتك نهائياً. لا يمكن التراجع عن هذا الإجراء.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'حذف نهائي',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _name = TextEditingController(text: 'خالد الأحمدي');
  final _email = TextEditingController(text: 'client@superjeeb.com');
  final _phone = TextEditingController(text: '777000001');
  final _bio = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2D42),
        title: const Text(
          'تعديل الملف الشخصي',
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        leading: const BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundColor: Color(0xFF2B2D42),
                  child: Icon(Icons.person, size: 65, color: Colors.white),
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFFEF233C),
                  child: IconButton(
                    icon: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 18,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            _field(_name, 'الاسم الكامل', Icons.person),
            const SizedBox(height: 15),
            _field(_email, 'البريد الإلكتروني', Icons.email),
            const SizedBox(height: 15),
            _field(_phone, 'رقم الهاتف', Icons.phone),
            const SizedBox(height: 15),
            _field(_bio, 'نبذة عنك', Icons.description, maxLines: 3),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF233C),
                  minimumSize: const Size(0, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ تم حفظ التعديلات'),
                      backgroundColor: Color(0xFF25D366),
                    ),
                  );
                },
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text(
                  'حفظ التعديلات',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController c,
    String label,
    IconData icon, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: c,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 13),
        prefixIcon: Icon(icon, color: const Color(0xFFEF233C)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});
  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _2fa = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2D42),
        title: const Text(
          'الأمان',
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        leading: const BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            _card(
              Icons.lock_outline,
              'تغيير كلمة السر',
              'آخر تغيير: منذ 3 أشهر',
              () => _showChangePass(context),
            ),
            _switchCard(
              Icons.security,
              'التحقق بخطوتين (2FA)',
              'حماية إضافية لحسابك',
              _2fa,
              (v) => setState(() => _2fa = v),
            ),
            _card(
              Icons.fingerprint,
              'البصمة / Face ID',
              'تسجيل دخول سريع',
              () {},
            ),
            _card(Icons.history, 'سجل الدخول', 'آخر 10 عمليات', () {}),
            _card(
              Icons.phonelink_lock,
              'التحقق بالهاتف',
              'موثق عبر OTP',
              () {},
              status: 'موثق',
              statusColor: const Color(0xFF25D366),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(
    IconData icon,
    String title,
    String sub,
    VoidCallback onTap, {
    String? status,
    Color? statusColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFEF233C).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFFEF233C), size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          sub,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        trailing: status != null
            ? Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: (statusColor ?? Colors.grey).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor ?? Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      ),
    );
  }

  Widget _switchCard(
    IconData icon,
    String title,
    String sub,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF25D366).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF25D366), size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          sub,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        trailing: Switch(
          value: value,
          activeThumbColor: const Color(0xFF25D366),
          onChanged: onChanged,
        ),
      ),
    );
  }

  void _showChangePass(BuildContext context) {
    final oldPass = TextEditingController();
    final newPass = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'تغيير كلمة السر',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              PasswordField(
                controller: oldPass,
                labelText: 'كلمة المرور الحالية',
              ),
              const SizedBox(height: 15),
              PasswordField(
                controller: newPass,
                labelText: 'كلمة المرور الجديدة',
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF233C),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✅ تم تغيير كلمة السر'),
                        backgroundColor: Color(0xFF25D366),
                      ),
                    );
                  },
                  child: const Text(
                    'حفظ',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DevicesScreen extends StatelessWidget {
  const DevicesScreen({super.key});

  final devices = const [
    {
      'name': 'Samsung Galaxy S23',
      'type': 'Android',
      'location': 'صنعاء، اليمن',
      'last': 'الآن',
      'current': true,
    },
    {
      'name': 'iPhone 14 Pro',
      'type': 'iOS',
      'location': 'عدن، اليمن',
      'last': 'منذ ساعتين',
      'current': false,
    },
    {
      'name': 'Chrome (Windows)',
      'type': 'Web',
      'location': 'تعز، اليمن',
      'last': 'منذ 3 أيام',
      'current': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2D42),
        title: const Text(
          'الأجهزة المتصلة',
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        leading: const BackButton(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: devices.length,
        itemBuilder: (context, i) => _deviceCard(devices[i]),
      ),
    );
  }

  Widget _deviceCard(Map<String, dynamic> d) {
    final isCurrent = d['current'] as bool;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: isCurrent
            ? Border.all(color: const Color(0xFF25D366), width: 1.5)
            : null,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2B2D42).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              d['type'] == 'Android'
                  ? Icons.android
                  : d['type'] == 'iOS'
                  ? Icons.phone_iphone
                  : Icons.computer,
              color: const Color(0xFF2B2D42),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        d['name'],
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (isCurrent)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF25D366)
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'هذا الجهاز',
                          style: TextStyle(
                            color: Color(0xFF25D366),
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 12, color: Colors.grey),
                    const SizedBox(width: 3),
                    Text(
                      d['location'],
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  'آخر نشاط: ${d['last']}',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
          if (!isCurrent)
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: Color(0xFFEF233C),
                size: 20,
              ),
              onPressed: () {},
            ),
        ],
      ),
    );
  }
}
