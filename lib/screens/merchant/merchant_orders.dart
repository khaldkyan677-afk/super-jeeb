import 'package:flutter/material.dart';

class MerchantOrdersScreen extends StatefulWidget {
  const MerchantOrdersScreen({super.key});

  @override
  State<MerchantOrdersScreen> createState() =>
      _MerchantOrdersScreenState();
}

class _MerchantOrdersScreenState extends State<MerchantOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  final List<Map<String, dynamic>> _newOrders = [
    {
      'id': '5021',
      'customer': 'خالد أحمد',
      'phone': '777000001',
      'address': 'صنعاء - شارع حدة',
      'total': 20000,
      'items': 2,
      'status': 'new',
      'time': 'منذ 5 دقائق',
    },
    {
      'id': '5022',
      'customer': 'سارة محمد',
      'phone': '777000002',
      'address': 'صنعاء - شارع تعز',
      'total': 8500,
      'items': 1,
      'status': 'new',
      'time': 'منذ 12 دقيقة',
    },
  ];

  final List<Map<String, dynamic>> _preparingOrders = [
    {
      'id': '5018',
      'customer': 'أحمد علي',
      'phone': '777000003',
      'address': 'صنعاء - شارع الزبيري',
      'total': 35000,
      'items': 3,
      'status': 'preparing',
      'time': 'منذ 20 دقيقة',
    },
  ];

  final List<Map<String, dynamic>> _doneOrders = [
    {
      'id': '5015',
      'customer': 'فاطمة س.',
      'phone': '777000004',
      'address': 'صنعاء - شارع بغداد',
      'total': 12000,
      'items': 1,
      'status': 'done',
      'time': 'اليوم - 10:30 ص',
    },
    {
      'id': '5014',
      'customer': 'محمد ح.',
      'phone': '777000005',
      'address': 'صنعاء - شارع الستين',
      'total': 45000,
      'items': 4,
      'status': 'done',
      'time': 'اليوم - 09:15 ص',
    },
  ];

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
      backgroundColor: const Color(0xFF1B1C2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2D42),
        title: const Text('إدارة الطلبات',
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
          tabs: [
            Tab(text: 'جديدة (${_newOrders.length})'),
            Tab(text: 'تحضير (${_preparingOrders.length})'),
            Tab(text: 'مكتملة (${_doneOrders.length})'),
            const Tab(text: 'الكل'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _buildList(_newOrders, 'new'),
          _buildList(_preparingOrders, 'preparing'),
          _buildList(_doneOrders, 'done'),
          _buildList(
            [..._newOrders, ..._preparingOrders, ..._doneOrders],
            'all',
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> orders, String filter) {
    if (orders.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined,
                size: 80, color: Colors.white24),
            SizedBox(height: 15),
            Text('لا توجد طلبات',
                style: TextStyle(color: Colors.white54, fontSize: 14)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: orders.length,
      itemBuilder: (context, i) => _orderCard(orders[i]),
    );
  }

  Widget _orderCard(Map<String, dynamic> o) {
    final status = o['status'] as String;
    Color color;
    String statusText;
    IconData statusIcon;

    switch (status) {
      case 'new':
        color = Colors.orange;
        statusText = 'جديد';
        statusIcon = Icons.notifications_active;
        break;
      case 'preparing':
        color = const Color(0xFFEF233C);
        statusText = 'قيد التحضير';
        statusIcon = Icons.restaurant;
        break;
      case 'done':
        color = const Color(0xFF25D366);
        statusText = 'مكتمل';
        statusIcon = Icons.check_circle;
        break;
      default:
        color = Colors.grey;
        statusText = 'غير معروف';
        statusIcon = Icons.help;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: status == 'new'
              ? Colors.orange.withValues(alpha: 0.5)
              : Colors.white10,
          width: status == 'new' ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(statusIcon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('طلب #${o['id']}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 3),
                    Text(o['time'],
                        style: const TextStyle(
                            color: Colors.white38, fontSize: 10)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(statusText,
                    style: TextStyle(
                        color: color,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const Divider(color: Colors.white10, height: 20),
          _row(Icons.person, 'العميل', o['customer']),
          const SizedBox(height: 6),
          _row(Icons.phone, 'الهاتف', o['phone']),
          const SizedBox(height: 6),
          _row(Icons.location_on, 'العنوان', o['address']),
          const SizedBox(height: 6),
          _row(Icons.shopping_bag, 'المنتجات',
              '${o['items']} منتج - ${o['total']} YER'),
          if (status == 'new') ...[
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      setState(() {
                        o['status'] = 'preparing';
                        _newOrders.remove(o);
                        _preparingOrders.add(o);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('✅ تم قبول الطلب'),
                            backgroundColor: Color(0xFF25D366)),
                      );
                    },
                    icon: const Icon(Icons.check,
                        color: Colors.white, size: 16),
                    label: const Text('قبول',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFEF233C)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => _showRejectDialog(o),
                    icon: const Icon(Icons.close,
                        color: Color(0xFFEF233C), size: 16),
                    label: const Text('رفض',
                        style: TextStyle(
                            color: Color(0xFFEF233C),
                            fontSize: 11,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
          if (status == 'preparing') ...[
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF233C),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  setState(() {
                    o['status'] = 'done';
                    _preparingOrders.remove(o);
                    _doneOrders.add(o);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('🏁 تم تسليم الطلب للمندوب'),
                        backgroundColor: Color(0xFF25D366)),
                  );
                },
                icon: const Icon(Icons.local_shipping,
                    color: Colors.white, size: 16),
                label: const Text('تسليم للمندوب',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white38, size: 14),
        const SizedBox(width: 6),
        Text('$label: ',
            style: const TextStyle(
                color: Colors.white38, fontSize: 11)),
        Expanded(
          child: Text(value,
              style: const TextStyle(
                  color: Colors.white70, fontSize: 11),
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  void _showRejectDialog(Map<String, dynamic> o) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF2B2D42),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text('سبب الرفض',
            style: TextStyle(color: Colors.white, fontSize: 15)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _reason(context, o, 'نفذت الكمية'),
            _reason(context, o, 'الفرع مغلق'),
            _reason(context, o, 'لا يمكن التوصيل للمنطقة'),
          ],
        ),
      ),
    );
  }

  Widget _reason(BuildContext context, Map<String, dynamic> o, String reason) {
    return ListTile(
      title: Text(reason,
          style: const TextStyle(color: Colors.white, fontSize: 13)),
      trailing: const Icon(Icons.arrow_forward_ios,
          color: Colors.white30, size: 14),
      onTap: () {
        setState(() => _newOrders.remove(o));
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('❌ تم رفض الطلب: $reason'),
              backgroundColor: const Color(0xFFEF233C)),
        );
      },
    );
  }
}
