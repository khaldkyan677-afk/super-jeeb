import 'package:flutter/material.dart';
import '../../services/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: SettingsService.instance,
      builder: (context, _) => Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: const Color(0xFF2B2D42),
          title: const Text('الإعدادات',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          leading: const BackButton(color: Colors.white),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 15),
              _sectionTitle('المظهر'),
              _switchTile(
                Icons.dark_mode,
                'الوضع الليلي',
                'تفعيل الواجهة الداكنة',
                SettingsService.instance.darkMode,
                (v) => SettingsService.instance.toggleDarkMode(v),
              ),
              const SizedBox(height: 15),
              _sectionTitle('اللغة'),
              _selectTile(
                Icons.language,
                'اللغة',
                SettingsService.instance.language == 'ar'
                    ? 'العربية'
                    : 'English',
                ['العربية', 'English'],
                (v) => SettingsService.instance
                    .setLanguage(v == 'العربية' ? 'ar' : 'en'),
              ),
              const SizedBox(height: 15),
              _sectionTitle('العملة'),
              _selectTile(
                Icons.attach_money,
                'العملة المفضلة',
                SettingsService.instance.currency,
                ['YER', 'SAR', 'USD'],
                (v) => SettingsService.instance.setCurrency(v),
              ),
              const SizedBox(height: 15),
              _sectionTitle('الإشعارات'),
              _switchTile(
                Icons.notifications_active,
                'الإشعارات',
                'استقبال إشعارات التطبيق',
                SettingsService.instance.notificationsEnabled,
                (v) => SettingsService.instance.toggleNotifications(v),
              ),
              _switchTile(
                Icons.volume_up,
                'الأصوات',
                'أصوات التنبيه',
                SettingsService.instance.sound,
                (v) => SettingsService.instance.toggleSound(v),
              ),
              const SizedBox(height: 15),
              _sectionTitle('المزيد'),
              _actionTile(context, Icons.location_on, 'العناوين المحفوظة'),
              _actionTile(context, Icons.payment, 'طرق الدفع'),
              _actionTile(context, Icons.lock, 'الأمان والخصوصية'),
              _actionTile(context, Icons.delete_forever, 'حذف الحساب',
                  color: Colors.red),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String t) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Text(t,
            style: const TextStyle(
                color: Color(0xFF2B2D42),
                fontSize: 13,
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _switchTile(IconData icon, String title, String subtitle,
      bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFEF233C), size: 22),
        title: Text(title, style: const TextStyle(fontSize: 14)),
        subtitle: Text(subtitle,
            style: const TextStyle(fontSize: 11, color: Colors.grey)),
        trailing: Switch(
          value: value,
          activeColor: const Color(0xFF25D366),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _selectTile(IconData icon, String title, String current,
      List<String> options, ValueChanged<String> onChanged) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFEF233C), size: 22),
        title: Text(title, style: const TextStyle(fontSize: 14)),
        trailing: DropdownButton<String>(
          value: current,
          underline: const SizedBox(),
          style: const TextStyle(
              color: Color(0xFF2B2D42),
              fontSize: 13,
              fontWeight: FontWeight.bold),
          items: options
              .map((o) => DropdownMenuItem(value: o, child: Text(o)))
              .toList(),
          onChanged: (v) => onChanged(v!),
        ),
      ),
    );
  }

  Widget _actionTile(BuildContext context, IconData icon, String title,
      {Color? color}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading:
            Icon(icon, color: color ?? const Color(0xFFEF233C), size: 22),
        title: Text(title,
            style: TextStyle(
                fontSize: 14, color: color ?? const Color(0xFF2B2D42))),
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 16, color: Colors.grey),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('فتح: $title')),
          );
        },
      ),
    );
  }
}
