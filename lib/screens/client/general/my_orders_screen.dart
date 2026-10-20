import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/api_service.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> _allOrders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);
    try {
      final res = await http.get(
        Uri.parse('${ApiService.baseUrl}/api/orders/my-orders'),
        headers: {'Authorization': 'Bearer ${ApiService.authToken}'},
      );
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        setState(() => _allOrders = data['orders'] ?? []);
      }
    } catch (e) {
      debugPrint('Error loading orders: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<dynamic> _filterOrders(String status) {
    if (status == 'active') {
      return _allOrders.where((o) => ['accepted', 'preparing', 'ready', 'delivering'].contains(o['status'])).toList();
    } else if (status == 'completed') {
      return _allOrders.where((o) => o['status'] == 'delivered').toList();
    } else if (status == 'cancelled') {
      return _allOrders.where((o) => o['status'] == 'cancelled').toList();
    } else { // pending
      return _allOrders.where((o) => o['status'] == 'pending').toList();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E000C),
      appBar: AppBar(
        title: const Text('طلباتي'),
        backgroundColor: const Color(0xFF3D0018),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.amber,
          tabs: const [
            Tab(text: 'قيد المراجعة'),
            Tab(text: 'النشطة'),
            Tab(text: 'المكتملة'),
            Tab(text: 'الملغاة'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOrdersList('pending'),
                _buildOrdersList('active'),
                _buildOrdersList('completed'),
                _buildOrdersList('cancelled'),
              ],
            ),
    );
  }

  Widget _buildOrdersList(String type) {
    final orders = _filterOrders(type);
    if (orders.isEmpty) {
      return Center(child: Text('لا توجد طلبات هنا', style: GoogleFonts.cairo(color: Colors.white54)));
    }

    return RefreshIndicator(
      onRefresh: _loadOrders,
      color: Colors.amber,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: orders.length,
        itemBuilder: (ctx, i) => _buildOrderCard(orders[i]),
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    String statusText = '';
    Color statusColor = Colors.grey;
    if (order['status'] == 'pending') { statusText = 'قيد المراجعة'; statusColor = Colors.orange; }
    else if (order['status'] == 'accepted' || order['status'] == 'preparing') { statusText = 'قيد التجهيز'; statusColor = Colors.blue; }
    else if (order['status'] == 'ready' || order['status'] == 'delivering') { statusText = 'جاري التوصيل'; statusColor = Colors.green; }
    else if (order['status'] == 'delivered') { statusText = 'مكتمل'; statusColor = Colors.green; }
    else if (order['status'] == 'cancelled') { statusText = 'ملغي'; statusColor = Colors.red; }

    return Card(
      color: const Color(0xFF3D0018),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('طلب #${order['_id'].toString().substring(18)}', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                  child: Text(statusText, style: GoogleFonts.cairo(color: statusColor, fontSize: 12)),
                ),
              ],
            ),
            const Divider(color: Colors.white24),
            Text('المتجر: ${order['storeId']?['name'] ?? 'غير معروف'}', style: GoogleFonts.cairo(color: Colors.white70)),
            const SizedBox(height: 4),
            Text('الإجمالي: ${order['total']} ريال', style: GoogleFonts.cairo(color: Colors.amber, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
