import 'package:flutter/material.dart';

class AdminStaffScreen extends StatefulWidget {
  const AdminStaffScreen({super.key});

  @override
  State<AdminStaffScreen> createState() => _AdminStaffScreenState();
}

class _AdminStaffScreenState extends State<AdminStaffScreen> {
  final List<Map<String, dynamic>> _staff = [
    {
      'name': 'خالد وليد',
      'email': 'khaled20010405@gmail.com',
      'role': 'المالك العام',
      'roleColor': Color(0xFFEF233C),
      'status': 'active',
      'avatar': 'KW',
    },
    {
      'name': 'أحمد محمد',
      'email': 'ahmed@superjeeb.com',
      'role': 'نائب آدمن',
      'roleColor': Color(0xFFD4AF37),
      'status': 'active',
      'avatar': 'AM',
    },
    {
      'name': 'سارة علي',
      'email': 'sara@superjeeb.com',
      'role': 'مسؤول مالي',
      'roleColor': Color(0xFF25D366),
      'status': 'active',
      'avatar': 'SA',
    },
    {
      'name': 'محمد حسن',
      'email': 'mohammed@superjeeb.com',
      'role': 'مسؤول تنفيذي',
      'roleColor': Color(0xFF2196F3),
      'status': 'active',
      'avatar': 'MH',
    },
    {
      'name': 'فاطمة سالم',
      'email': 'fatima@superjeeb.com',
      'role': 'مسؤول دعم',
      'roleColor': Colors.purple,
      'status': 'inactive',
      'avatar': 'FS',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B0013),
      appBar: AppBar(
        backgroundColor: const Color(0xFF660F24),
        title: const Text('إدارة الموظفين',
            style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold)),
        leading: const BackButton(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add,
                color: Color(0xFF25D366), size: 24),
            onPressed: () => _showHireDialog(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _statsBar(),
            const SizedBox(height: 20),
            const Text('فريق العمل',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ..._staff.map((s) => _staffCard(s)),
            const SizedBox(height: 20),
            const Text('الأدوار والصلاحيات',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _roleCard('المالك العام', 'صلاحيات مطلقة', Colors.red,
                Icons.shield, ['كل الصلاحيات']),
            _roleCard('نائب آدمن', 'إدارة يومية',
                const Color(0xFFD4AF37), Icons.admin_panel_settings,
                ['قبول التجار', 'قبول المناديب', 'الرد على الشكاوى']),
            _roleCard('مسؤول مالي', 'الشؤون المالية',
                const Color(0xFF25D366), Icons.account_balance,
                ['صرف المستحقات', 'التقارير المالية', 'إدارة المحافظ']),
            _roleCard('مسؤول تنفيذي', 'المهام التنفيذية',
                const Color(0xFF2196F3), Icons.work_outline,
                ['متابعة الطلبات', 'الدعم الفني', 'المراقبة']),
          ],
        ),
      ),
    );
  }

  Widget _statsBar() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          _stat('${_staff.length}', 'إجمالي', const Color(0xFFEF233C),
              Icons.groups),
          Container(width: 1, height: 40, color: Colors.white10),
          _stat(
              '${_staff.where((s) => s['status'] == 'active').length}',
              'نشط',
              const Color(0xFF25D366),
              Icons.check_circle),
          Container(width: 1, height: 40, color: Colors.white10),
          _stat(
              '${_staff.where((s) => s['status'] == 'inactive').length}',
              'موقوف',
              Colors.orange,
              Icons.pause_circle),
        ],
      ),
    );
  }

  Widget _stat(String value, String label, Color color, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(
                  color: Colors.white54, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _staffCard(Map<String, dynamic> s) {
    final roleColor = s['roleColor'] as Color;
    final isActive = s['status'] == 'active';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
            color: isActive ? Colors.white10 : Colors.orange.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: roleColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: roleColor, width: 1.5),
            ),
            child: Center(
              child: Text(s['avatar'],
                  style: TextStyle(
                      color: roleColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
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
                      child: Text(s['name'],
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold)),
                    ),
                    if (!isActive)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('موقوف',
                            style: TextStyle(
                                color: Colors.orange,
                                fontSize: 9,
                                fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(s['email'],
                    style: const TextStyle(
                        color: Colors.white54, fontSize: 10)),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: roleColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(s['role'],
                      style: TextStyle(
                          color: roleColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert,
                color: Colors.white54, size: 20),
            color: const Color(0xFF2B0013),
            onSelected: (v) {
              if (v == 'toggle') {
                setState(() => s['status'] =
                    isActive ? 'inactive' : 'active');
              } else if (v == 'delete') {
                _confirmDelete(s);
              } else if (v == 'permissions') {
                _showPermissions(s);
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'permissions',
                child: Row(
                  children: [
                    Icon(Icons.security,
                        color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text('الصلاحيات',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'toggle',
                child: Row(
                  children: [
                    Icon(Icons.toggle_on,
                        color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text('تفعيل/إيقاف',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete,
                        color: Color(0xFFEF233C), size: 18),
                    SizedBox(width: 8),
                    Text('حذف',
                        style: TextStyle(
                            color: Color(0xFFEF233C))),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _roleCard(String title, String subtitle, Color color,
      IconData icon, List<String> permissions) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 3),
                    Text(subtitle,
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: permissions
                .map((p) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(p,
                          style: TextStyle(
                              color: color,
                              fontSize: 10,
                              fontWeight: FontWeight.w600)),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  void _showHireDialog() {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    String role = 'مسؤول تنفيذي';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          backgroundColor: const Color(0xFF2B0013),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.person_add, color: Color(0xFF25D366)),
              SizedBox(width: 8),
              Text('توظيف موظف جديد',
                  style: TextStyle(color: Colors.white, fontSize: 15)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'الاسم الكامل',
                    labelStyle: TextStyle(color: Colors.white60),
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white24)),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: emailCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'البريد الإلكتروني',
                    labelStyle: TextStyle(color: Colors.white60),
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white24)),
                  ),
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  initialValue: role,
                  dropdownColor: const Color(0xFF2B0013),
                  style: const TextStyle(
                      color: Colors.white, fontSize: 12),
                  decoration: const InputDecoration(
                    labelText: 'الرتبة',
                    labelStyle: TextStyle(color: Colors.white60),
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white24)),
                  ),
                  items: ['نائب آدمن', 'مسؤول مالي', 'مسؤول تنفيذي',
                          'مسؤول دعم']
                      .map((r) =>
                          DropdownMenuItem(value: r, child: Text(r)))
                      .toList(),
                  onChanged: (v) => setS(() => role = v!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء',
                  style: TextStyle(color: Colors.white60)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366)),
              onPressed: () {
                if (nameCtrl.text.isEmpty) return;
                setState(() {
                  _staff.add({
                    'name': nameCtrl.text,
                    'email': emailCtrl.text,
                    'role': role,
                    'roleColor': const Color(0xFF2196F3),
                    'status': 'active',
                    'avatar': nameCtrl.text
                        .split(' ')
                        .take(2)
                        .map((w) => w[0])
                        .join()
                        .toUpperCase(),
                  });
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('✅ تم توظيف الموظف بنجاح'),
                      backgroundColor: Color(0xFF25D366)),
                );
              },
              child: const Text('تثبيت',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showPermissions(Map<String, dynamic> s) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2B0013),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('صلاحيات ${s['name']}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _permissionSwitch('قبول/رفض التجار', true),
            _permissionSwitch('قبول/رفض المناديب', true),
            _permissionSwitch('صرف المستحقات', false),
            _permissionSwitch('إدارة البانرات', true),
            _permissionSwitch('البث الجماعي', false),
            _permissionSwitch('حذف المستخدمين', false),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _permissionSwitch(String title, bool value) {
    return SwitchListTile(
      value: value,
      activeThumbColor: const Color(0xFF25D366),
      onChanged: (_) {},
      title: Text(title,
          style: const TextStyle(color: Colors.white, fontSize: 13)),
      contentPadding: EdgeInsets.zero,
    );
  }

  void _confirmDelete(Map<String, dynamic> s) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF2B0013),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text('حذف الموظف',
            style: TextStyle(color: Colors.white, fontSize: 15)),
        content: Text('هل تريد حذف ${s['name']}؟',
            style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء',
                style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF233C)),
            onPressed: () {
              setState(() => _staff.remove(s));
              Navigator.pop(context);
            },
            child: const Text('حذف',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
