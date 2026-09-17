import 'package:flutter/material.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  // الإعدادات العامة
  double _merchantCommission = 10;
  double _courierCommission = 15;
  double _deliveryCompanyCommission = 8;
  bool _maintenanceMode = false;
  bool _newRegistrations = true;
  bool _autoApproveMerchants = false;
  bool _autoApproveCouriers = false;

  // الإشعارات
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;

  // الأمان
  bool _twoFactorRequired = true;
  bool _ipRestriction = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B0013),
      appBar: AppBar(
        backgroundColor: const Color(0xFF660F24),
        title: const Text('إعدادات النظام',
            style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold)),
        leading: const BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _section('💰 العمولات', [
              _sliderTile(
                'عمولة التاجر',
                _merchantCommission,
                0,
                30,
                const Color(0xFF25D366),
                (v) => setState(() => _merchantCommission = v),
              ),
              _sliderTile(
                'عمولة المندوب',
                _courierCommission,
                0,
                30,
                const Color(0xFFEF233C),
                (v) => setState(() => _courierCommission = v),
              ),
              _sliderTile(
                'عمولة شركة التوصيل',
                _deliveryCompanyCommission,
                0,
                20,
                Colors.purple,
                (v) =>
                    setState(() => _deliveryCompanyCommission = v),
              ),
            ]),
            _section('⚙️ إعدادات عامة', [
              _switchTile(
                'وضع الصيانة',
                'إيقاف التطبيق مؤقتاً',
                _maintenanceMode,
                Icons.construction,
                Colors.orange,
                (v) => setState(() => _maintenanceMode = v),
              ),
              _switchTile(
                'تفعيل التسجيلات الجديدة',
                'السماح بتسجيل مستخدمين جدد',
                _newRegistrations,
                Icons.person_add,
                const Color(0xFF25D366),
                (v) => setState(() => _newRegistrations = v),
              ),
              _switchTile(
                'قبول التجار تلقائياً',
                'بدون مراجعة يدوية',
                _autoApproveMerchants,
                Icons.store,
                Colors.amber,
                (v) => setState(() => _autoApproveMerchants = v),
              ),
              _switchTile(
                'قبول المناديب تلقائياً',
                'بدون مراجعة يدوية',
                _autoApproveCouriers,
                Icons.delivery_dining,
                Colors.orange,
                (v) => setState(() => _autoApproveCouriers = v),
              ),
            ]),
            _section('🔔 الإشعارات', [
              _switchTile(
                'إشعارات Push',
                'للجوال',
                _pushNotifications,
                Icons.notifications_active,
                const Color(0xFFEF233C),
                (v) => setState(() => _pushNotifications = v),
              ),
              _switchTile(
                'إشعارات البريد',
                'للإيميل',
                _emailNotifications,
                Icons.email,
                const Color(0xFF25D366),
                (v) => setState(() => _emailNotifications = v),
              ),
              _switchTile(
                'إشعارات SMS',
                'للرسائل النصية',
                _smsNotifications,
                Icons.sms,
                Colors.blue,
                (v) => setState(() => _smsNotifications = v),
              ),
            ]),
            _section('🔐 الأمان', [
              _switchTile(
                '2FA إجباري للأدمن',
                'تحقق مزدوج',
                _twoFactorRequired,
                Icons.security,
                const Color(0xFFEF233C),
                (v) => setState(() => _twoFactorRequired = v),
              ),
              _switchTile(
                'تقييد IP',
                'الوصول من IP محدد فقط',
                _ipRestriction,
                Icons.lan,
                Colors.purple,
                (v) => setState(() => _ipRestriction = v),
              ),
              _actionTile(
                'سجل العمليات',
                'مراجعة كل الأنشطة',
                Icons.history,
                Colors.blue,
                () {},
              ),
              _actionTile(
                'النسخ الاحتياطي',
                'حفظ نسخة من قاعدة البيانات',
                Icons.backup,
                const Color(0xFF25D366),
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('💾 جاري إنشاء نسخة احتياطية...'),
                        backgroundColor: Color(0xFF25D366)),
                  );
                },
              ),
            ]),
            _section('🌐 المزيد', [
              _actionTile(
                'إعدادات اللغة',
                'العربية / English',
                Icons.language,
                Colors.cyan,
                () {},
              ),
              _actionTile(
                'العملات',
                'ريال قديم، جديد، سعودي، دولار',
                Icons.attach_money,
                const Color(0xFFD4AF37),
                () {},
              ),
              _actionTile(
                'أسعار الصرف',
                'تحديث الأسعار حسب المحافظة',
                Icons.currency_exchange,
                Colors.amber,
                () {},
              ),
              _actionTile(
                'المحافظات والمدن',
                'إدارة مواقع التوصيل',
                Icons.location_city,
                Colors.blue,
                () {},
              ),
            ]),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF233C),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('✅ تم حفظ الإعدادات'),
                        backgroundColor: Color(0xFF25D366)),
                  );
                },
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text('حفظ كل الإعدادات',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 15, 5, 12),
          child: Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
        ),
        ...children,
        const SizedBox(height: 5),
      ],
    );
  }

  Widget _sliderTile(
    String title,
    double value,
    double min,
    double max,
    Color color,
    ValueChanged<double> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('${value.toStringAsFixed(0)}%',
                    style: TextStyle(
                        color: color,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min).toInt(),
            activeColor: color,
            inactiveColor: Colors.white10,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _switchTile(
    String title,
    String subtitle,
    bool value,
    IconData icon,
    Color color,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle,
            style: const TextStyle(
                color: Colors.white54, fontSize: 10)),
        trailing: Switch(
          value: value,
          activeColor: color,
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _actionTile(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle,
            style: const TextStyle(
                color: Colors.white54, fontSize: 10)),
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 14, color: Colors.white30),
      ),
    );
  }
}
