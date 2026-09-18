import 'package:flutter/material.dart';

class AdminManagementScreen extends StatefulWidget {
  const AdminManagementScreen({super.key});

  @override
  State<AdminManagementScreen> createState() => _AdminManagementScreenState();
}

class _AdminManagementScreenState extends State<AdminManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B0013),
      appBar: AppBar(
        backgroundColor: const Color(0xFF660F24),
        title: const Text('إدارة النظام',
            style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold)),
        leading: const BackButton(color: Colors.white),
        bottom: TabBar(
          controller: _tab,
          indicatorColor: const Color(0xFFEF233C),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: const TextStyle(
              fontSize: 11, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'المستخدمون'),
            Tab(text: 'الأقسام'),
            Tab(text: 'المناطق'),
            Tab(text: 'الشكاوى'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: const [
          _UsersTab(),
          _CategoriesTab(),
          _ZonesTab(),
          _ComplaintsTab(),
        ],
      ),
    );
  }
}

// ============================================================
// 1. المستخدمون
// ============================================================
class _UsersTab extends StatefulWidget {
  const _UsersTab();

  @override
  State<_UsersTab> createState() => _UsersTabState();
}

class _UsersTabState extends State<_UsersTab> {
  String _filter = 'الكل';
  final _filters = ['الكل', 'عملاء', 'تجار', 'مناديب', 'محظورون'];

  final List<Map<String, dynamic>> _users = [
    {
      'name': 'خالد أحمد',
      'email': 'khaled@example.com',
      'role': 'عميل',
      'orders': 24,
      'status': 'active',
      'color': Color(0xFFEF233C),
      'avatar': 'KA',
    },
    {
      'name': 'متجر الأناقة',
      'email': 'elegance@shop.com',
      'role': 'تاجر',
      'orders': 142,
      'status': 'active',
      'color': Color(0xFF25D366),
      'avatar': 'MA',
    },
    {
      'name': 'أحمد المندوب',
      'email': 'ahmed@driver.com',
      'role': 'مندوب',
      'orders': 385,
      'status': 'active',
      'color': Colors.orange,
      'avatar': 'AM',
    },
    {
      'name': 'سارة علي',
      'email': 'sara@example.com',
      'role': 'عميل',
      'orders': 5,
      'status': 'active',
      'color': Color(0xFFEF233C),
      'avatar': 'SA',
    },
    {
      'name': 'عميل متهرب',
      'email': 'fake@spam.com',
      'role': 'عميل',
      'orders': 0,
      'status': 'banned',
      'color': Colors.red,
      'avatar': 'FT',
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_filter == 'الكل') return _users;
    if (_filter == 'عملاء') {
      return _users.where((u) => u['role'] == 'عميل').toList();
    }
    if (_filter == 'تجار') {
      return _users.where((u) => u['role'] == 'تاجر').toList();
    }
    if (_filter == 'مناديب') {
      return _users.where((u) => u['role'] == 'مندوب').toList();
    }
    return _users.where((u) => u['status'] == 'banned').toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 15, vertical: 12),
          color: Colors.white.withValues(alpha: 0.02),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filters.map((f) {
                final sel = _filter == f;
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: InkWell(
                    onTap: () => setState(() => _filter = f),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: sel
                            ? const Color(0xFFEF233C)
                            : Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(f,
                          style: TextStyle(
                              color:
                                  sel ? Colors.white : Colors.white60,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: _filtered.length,
            itemBuilder: (context, i) => _userCard(_filtered[i]),
          ),
        ),
      ],
    );
  }

  Widget _userCard(Map<String, dynamic> u) {
    final isBanned = u['status'] == 'banned';
    final color = u['color'] as Color;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
            color: isBanned
                ? const Color(0xFFEF233C).withValues(alpha: 0.5)
                : Colors.white10,
            width: isBanned ? 1.5 : 1),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 1.5),
            ),
            child: Center(
              child: Text(u['avatar'],
                  style: TextStyle(
                      color: color,
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
                      child: Text(u['name'],
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold)),
                    ),
                    if (isBanned)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF233C)
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('محظور',
                            style: TextStyle(
                                color: Color(0xFFEF233C),
                                fontSize: 9,
                                fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(u['email'],
                    style: const TextStyle(
                        color: Colors.white54, fontSize: 10)),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(u['role'],
                          style: TextStyle(
                              color: color,
                              fontSize: 9,
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    Text('${u['orders']} طلب',
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert,
                color: Colors.white54, size: 20),
            color: const Color(0xFF2B0013),
            onSelected: (v) {
              if (v == 'view') {
                _showUserDetails(u);
              } else if (v == 'ban') {
                setState(() => u['status'] = 'banned');
              } else if (v == 'unban') {
                setState(() => u['status'] = 'active');
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'view',
                child: Row(
                  children: [
                    Icon(Icons.visibility,
                        color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text('عرض التفاصيل',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: isBanned ? 'unban' : 'ban',
                child: Row(
                  children: [
                    Icon(
                        isBanned ? Icons.check : Icons.block,
                        color: isBanned
                            ? const Color(0xFF25D366)
                            : const Color(0xFFEF233C),
                        size: 18),
                    const SizedBox(width: 8),
                    Text(isBanned ? 'إلغاء الحظر' : 'حظر',
                        style: TextStyle(
                            color: isBanned
                                ? const Color(0xFF25D366)
                                : const Color(0xFFEF233C))),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showUserDetails(Map<String, dynamic> u) {
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
            Text(u['name'],
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _detailRow('البريد', u['email']),
            _detailRow('الدور', u['role']),
            _detailRow('عدد الطلبات', '${u['orders']}'),
            _detailRow('الحالة',
                u['status'] == 'active' ? 'نشط' : 'محظور'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: Colors.white54, fontSize: 12)),
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}

// ============================================================
// 2. الأقسام
// ============================================================
class _CategoriesTab extends StatefulWidget {
  const _CategoriesTab();

  @override
  State<_CategoriesTab> createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<_CategoriesTab> {
  final List<Map<String, dynamic>> _categories = [
    {'name': 'مطاعم', 'icon': Icons.restaurant, 'count': 45, 'active': true},
    {'name': 'سوبرماركت', 'icon': Icons.shopping_cart, 'count': 32, 'active': true},
    {'name': 'صيدليات', 'icon': Icons.local_pharmacy, 'count': 28, 'active': true},
    {'name': 'ملابس', 'icon': Icons.checkroom, 'count': 67, 'active': true},
    {'name': 'إلكترونيات', 'icon': Icons.phone_android, 'count': 51, 'active': true},
    {'name': 'عطور', 'icon': Icons.spa, 'count': 24, 'active': true},
    {'name': 'مكسرات', 'icon': Icons.eco, 'count': 18, 'active': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _addCategory,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('إضافة قسم جديد',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: _categories.length,
            itemBuilder: (context, i) => _catCard(_categories[i], i),
          ),
        ),
      ],
    );
  }

  Widget _catCard(Map<String, dynamic> c, int i) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFEF233C).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(c['icon'] as IconData,
                color: const Color(0xFFEF233C), size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c['name'],
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 3),
                Text('${c['count']} متجر',
                    style: const TextStyle(
                        color: Colors.white54, fontSize: 10)),
              ],
            ),
          ),
          Switch(
            value: c['active'] as bool,
            activeThumbColor: const Color(0xFF25D366),
            onChanged: (v) => setState(() => c['active'] = v),
          ),
          IconButton(
            icon: const Icon(Icons.delete,
                color: Color(0xFFEF233C), size: 20),
            onPressed: () {
              setState(() => _categories.removeAt(i));
            },
          ),
        ],
      ),
    );
  }

  void _addCategory() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF2B0013),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text('إضافة قسم',
            style: TextStyle(color: Colors.white, fontSize: 15)),
        content: TextField(
          controller: ctrl,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'اسم القسم',
            labelStyle: TextStyle(color: Colors.white60),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white24)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء',
                style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366)),
            onPressed: () {
              if (ctrl.text.isNotEmpty) {
                setState(() {
                  _categories.add({
                    'name': ctrl.text,
                    'icon': Icons.category,
                    'count': 0,
                    'active': true,
                  });
                });
              }
              Navigator.pop(context);
            },
            child: const Text('إضافة',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 3. مناطق التوصيل
// ============================================================
class _ZonesTab extends StatefulWidget {
  const _ZonesTab();

  @override
  State<_ZonesTab> createState() => _ZonesTabState();
}

class _ZonesTabState extends State<_ZonesTab> {
  final List<Map<String, dynamic>> _zones = [
    {'name': 'صنعاء - المركز', 'city': 'صنعاء', 'fee': 1500, 'eta': 30, 'active': true},
    {'name': 'صنعاء - حدة', 'city': 'صنعاء', 'fee': 1200, 'eta': 25, 'active': true},
    {'name': 'عدن - كريتر', 'city': 'عدن', 'fee': 1800, 'eta': 40, 'active': true},
    {'name': 'تعز - المظفر', 'city': 'تعز', 'fee': 2000, 'eta': 45, 'active': true},
    {'name': 'الحديدة - المدينة', 'city': 'الحديدة', 'fee': 2200, 'eta': 50, 'active': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _addZone,
              icon: const Icon(Icons.add_location, color: Colors.white),
              label: const Text('إضافة منطقة',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: _zones.length,
            itemBuilder: (context, i) => _zoneCard(_zones[i], i),
          ),
        ),
      ],
    );
  }

  Widget _zoneCard(Map<String, dynamic> z, int i) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF25D366).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.location_city,
                    color: Color(0xFF25D366), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(z['name'],
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 3),
                    Text('${z['city']} - ${z['eta']} دقيقة',
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 10)),
                  ],
                ),
              ),
              Switch(
                value: z['active'] as bool,
                activeThumbColor: const Color(0xFF25D366),
                onChanged: (v) => setState(() => z['active'] = v),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.attach_money,
                  color: Colors.amber, size: 16),
              const SizedBox(width: 4),
              Text('رسوم التوصيل: ${z['fee']} YER',
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 11)),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.delete,
                    color: Color(0xFFEF233C), size: 20),
                onPressed: () {
                  setState(() => _zones.removeAt(i));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _addZone() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF2B0013),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text('إضافة منطقة',
            style: TextStyle(color: Colors.white, fontSize: 15)),
        content: TextField(
          controller: ctrl,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'اسم المنطقة',
            labelStyle: TextStyle(color: Colors.white60),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white24)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء',
                style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366)),
            onPressed: () {
              if (ctrl.text.isNotEmpty) {
                setState(() {
                  _zones.add({
                    'name': ctrl.text,
                    'city': 'صنعاء',
                    'fee': 1500,
                    'eta': 30,
                    'active': true,
                  });
                });
              }
              Navigator.pop(context);
            },
            child: const Text('إضافة',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 4. الشكاوى
// ============================================================
class _ComplaintsTab extends StatefulWidget {
  const _ComplaintsTab();

  @override
  State<_ComplaintsTab> createState() => _ComplaintsTabState();
}

class _ComplaintsTabState extends State<_ComplaintsTab> {
  final List<Map<String, dynamic>> _complaints = [
    {
      'id': 'C-501',
      'from': 'خالد أحمد',
      'against': 'متجر الإلكترونيات',
      'subject': 'منتج تالف',
      'status': 'pending',
      'priority': 'high',
      'date': 'اليوم 10:30 ص',
    },
    {
      'id': 'C-500',
      'from': 'سارة محمد',
      'against': 'مندوب #3042',
      'subject': 'تأخر التوصيل',
      'status': 'in_progress',
      'priority': 'normal',
      'date': 'اليوم 09:15 ص',
    },
    {
      'id': 'C-499',
      'from': 'أحمد علي',
      'against': 'صيدلية النور',
      'subject': 'طلب خاطئ',
      'status': 'resolved',
      'priority': 'low',
      'date': 'أمس 08:45 م',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: _complaints.length,
      itemBuilder: (context, i) => _complaintCard(_complaints[i], i),
    );
  }

  Widget _complaintCard(Map<String, dynamic> c, int i) {
    final status = c['status'] as String;
    final priority = c['priority'] as String;

    Color statusColor;
    String statusText;
    switch (status) {
      case 'pending':
        statusColor = Colors.orange;
        statusText = 'معلقة';
        break;
      case 'in_progress':
        statusColor = const Color(0xFFEF233C);
        statusText = 'قيد المعالجة';
        break;
      default:
        statusColor = const Color(0xFF25D366);
        statusText = 'محلولة';
    }

    Color priorityColor;
    String priorityText;
    switch (priority) {
      case 'high':
        priorityColor = const Color(0xFFEF233C);
        priorityText = 'عالية';
        break;
      case 'normal':
        priorityColor = Colors.orange;
        priorityText = 'عادية';
        break;
      default:
        priorityColor = Colors.grey;
        priorityText = 'منخفضة';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  status == 'resolved'
                      ? Icons.check_circle
                      : Icons.warning_amber,
                  color: statusColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('شكوى #${c['id']}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 3),
                    Text(c['date'],
                        style: const TextStyle(
                            color: Colors.white38, fontSize: 10)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: priorityColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(priorityText,
                    style: TextStyle(
                        color: priorityColor,
                        fontSize: 9,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const Divider(color: Colors.white10, height: 20),
          _infoRow('من', c['from']),
          const SizedBox(height: 4),
          _infoRow('ضد', c['against']),
          const SizedBox(height: 4),
          _infoRow('الموضوع', c['subject']),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(statusText,
                        style: TextStyle(
                            color: statusColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              if (status != 'resolved') ...[
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      setState(() => c['status'] = 'resolved');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('✅ تم حل الشكوى'),
                            backgroundColor: Color(0xFF25D366)),
                      );
                    },
                    child: const Text('حل',
                        style: TextStyle(
                            color: Colors.white, fontSize: 11)),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text('$label:',
              style: const TextStyle(
                  color: Colors.white38, fontSize: 11)),
        ),
        Expanded(
          child: Text(value,
              style: const TextStyle(
                  color: Colors.white70, fontSize: 11),
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}
