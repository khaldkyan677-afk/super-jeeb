import 'package:flutter/material.dart';

import 'order_tracking_screen.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  final _allOrders = [
    {
      'id': '5021',
      'merchant': 'متجر الأناقة',
      'total': 20000,
      'status': 'in_progress',
      'date': 'اليوم - 10:30 ص',
      'items': ['قميص رجالي', 'بنطلون جينز'],
    },
    {
      'id': '5020',
      'merchant': 'متجر الإلكترونيات',
      'total': 150000,
      'status': 'delivered',
      'date': 'أمس - 03:15 م',
      'items': ['هاتف ذكي'],
    },
    {
      'id': '5019',
      'merchant': 'صيدلية الحياة',
      'total': 4500,
      'status': 'cancelled',
      'date': 'أمس - 11:00 ص',
      'items': ['أدوية'],
    },
    {
      'id': '5018',
      'merchant': 'متجر العطور',
      'total': 8500,
      'status': 'delivered',
      'date': 'منذ 3 أيام',
      'items': ['عطر فاخر'],
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
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2D42),
        title: const Text(
          'طلباتي',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const BackButton(color: Colors.white),
        bottom: TabBar(
          controller: _tab,
          indicatorColor: const Color(0xFFEF233C),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          tabs: const [
            Tab(text: 'الكل'),
            Tab(text: 'جارية'),
            Tab(text: 'مكتملة'),
            Tab(text: 'ملغاة'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _buildList('all'),
          _buildList('in_progress'),
          _buildList('delivered'),
          _buildList('cancelled'),
        ],
      ),
    );
  }

  Widget _buildList(String filter) {
    final orders = filter == 'all'
        ? _allOrders
        : _allOrders.where((o) => o['status'] == filter).toList();

    if (orders.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 80, color: Colors.grey),
            SizedBox(height: 15),
            Text(
              'لا توجد طلبات',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
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
      case 'in_progress':
        color = Colors.orange;
        statusText = 'جاري التحضير';
        statusIcon = Icons.local_shipping;
        break;
      case 'delivered':
        color = const Color(0xFF25D366);
        statusText = 'تم التسليم';
        statusIcon = Icons.check_circle;
        break;
      case 'cancelled':
        color = const Color(0xFFEF233C);
        statusText = 'ملغاة';
        statusIcon = Icons.cancel;
        break;
      default:
        color = Colors.grey;
        statusText = 'قيد المراجعة';
        statusIcon = Icons.hourglass_empty;
    }

    return GestureDetector(
      onTap: () => _showOrderDetails(o),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.receipt_long,
                  color: Color(0xFF2B2D42),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'طلب #${o['id']}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2B2D42),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(statusIcon, color: color, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        statusText,
                        style: TextStyle(
                          color: color,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              children: [
                const Icon(
                  Icons.storefront,
                  color: Color(0xFFEF233C),
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  o['merchant'],
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              o['items'].join(' • '),
              style: const TextStyle(fontSize: 12, color: Colors.black54),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  o['date'],
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                Text(
                  '${o['total']} YER',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEF233C),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderDetails(Map<String, dynamic> o) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF8F9FA),
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
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'طلب #${o['id']}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2B2D42),
              ),
            ),
            const SizedBox(height: 20),
            _detailRow('المتجر', o['merchant']),
            _detailRow('التاريخ', o['date']),
            _detailRow('الإجمالي', '${o['total']} YER'),
            _detailRow('المنتجات', o['items'].join(', ')),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF233C),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          OrderTrackingScreen(orderId: o['id'] as String),
                    ),
                  );
                },
                icon: const Icon(Icons.track_changes, color: Colors.white),
                label: const Text(
                  'تتبع الطلب',
                  style: TextStyle(
                    color: Colors.white,
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

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
