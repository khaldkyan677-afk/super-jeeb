import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import '../../services/api_service.dart';
import 'order_tracking_screen.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});
  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> with SingleTickerProviderStateMixin {
  List<dynamic> _orders = [];
  bool _loading = true;
  Timer? _timer;
  late TabController _tabs;

  final _tabNames = ['قيد المراجعة', 'جارية', 'مكتملة', 'الكل'];

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
    _tabs.addListener(() => setState(() {}));
    _load();
    _timer = Timer.periodic(const Duration(seconds: 15), (_) => _load(silent: true));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _load({bool silent = false}) async {
    if (!silent) setState(() => _loading = true);
    try {
      final list = await ApiService.getMyOrders();
      if (mounted) setState(() { _orders = list; _loading = false; });
    } catch (e) {
      debugPrint('MyOrders ERR: $e');
      if (mounted) setState(() => _loading = false);
    }
  }

  bool _isPending(dynamic o) {
    final m = o is Map ? o as Map<String, dynamic> : <String, dynamic>{};
    final status = (m['status'] ?? '').toString();
    final verif = (m['verificationStatus'] ?? '').toString();
    return status == 'pending' || verif == 'pending';
  }

  bool _isRunning(dynamic o) {
    final m = o is Map ? o as Map<String, dynamic> : <String, dynamic>{};
    final s = (m['status'] ?? '').toString();
    return ['accepted', 'preparing', 'ready', 'on_the_way'].contains(s);
  }

  bool _isComplete(dynamic o) {
    final m = o is Map ? o as Map<String, dynamic> : <String, dynamic>{};
    final s = (m['status'] ?? '').toString();
    return s == 'delivered' || s == 'cancelled';
  }

  List<dynamic> _filtered(int index) {
    switch (index) {
      case 0: return _orders.where(_isPending).toList();
      case 1: return _orders.where(_isRunning).toList();
      case 2: return _orders.where(_isComplete).toList();
      default: return _orders;
    }
  }

  (String, Color, IconData) _statusInfo(String s, String verif) {
    if (verif == 'rejected') return ('مرفوض', Colors.red, Icons.cancel);
    if (verif == 'pending') return ('قيد المراجعة', Colors.orange, Icons.hourglass_top);
    switch (s) {
      case 'pending': return ('بانتظار الموافقة', Colors.orange, Icons.hourglass_top);
      case 'accepted': return ('تم القبول', Colors.blue, Icons.check_circle_outline);
      case 'preparing': return ('جاري التحضير', Colors.purple, Icons.restaurant);
      case 'ready': return ('جاهز للتوصيل', Colors.teal, Icons.inventory_2_outlined);
      case 'on_the_way': return ('في الطريق', Colors.indigo, Icons.delivery_dining);
      case 'delivered': return ('تم التسليم', Colors.green, Icons.check_circle);
      case 'cancelled': return ('ملغي', Colors.grey, Icons.block);
      default: return (s, Colors.grey, Icons.info_outline);
    }
  }

  bool _canTrack(String s) => ['accepted', 'preparing', 'ready', 'on_the_way', 'delivered'].contains(s);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D12),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: Text('طلباتي', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.refresh, color: Colors.white), onPressed: () => _load()),
        ],
        bottom: TabBar(
          controller: _tabs,
          isScrollable: true,
          indicatorColor: const Color(0xFFFFE233),
          labelColor: const Color(0xFFFFE233),
          unselectedLabelColor: Colors.white60,
          labelStyle: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.bold),
          tabs: _tabNames.map((t) => Tab(text: t)).toList(),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFFFE233)))
          : TabBarView(
              controller: _tabs,
              children: List.generate(4, (i) {
                final items = _filtered(i);
                if (items.isEmpty) {
                  return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey.shade800),
                    const SizedBox(height: 16),
                    Text('لا توجد طلبات', style: GoogleFonts.cairo(color: Colors.white70, fontSize: 16)),
                  ]));
                }
                return RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: items.length,
                    itemBuilder: (_, idx) => _card(items[idx]),
                  ),
                );
              }),
            ),
    );
  }

  Widget _card(dynamic o) {
    final m = o is Map ? o as Map<String, dynamic> : <String, dynamic>{};
    final store = m['storeId'];
    final storeName = store is Map ? (store['name'] ?? 'متجر') : 'متجر';
    final status = (m['status'] ?? 'pending').toString();
    final verif = (m['verificationStatus'] ?? 'none').toString();
    final total = m['total'] ?? 0;
    final items = (m['items'] as List?) ?? [];
    final createdAt = m['createdAt']?.toString() ?? '';
    final dateShort = createdAt.isNotEmpty && createdAt.length >= 10 ? createdAt.substring(0, 10) : '';
    final (label, color, icon) = _statusInfo(status, verif);
    final showRate = status == 'delivered';
    final showTrack = _canTrack(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF15151C),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(storeName, style: GoogleFonts.cairo(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                child: Text(label, style: GoogleFonts.cairo(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.inventory_2_outlined, color: Colors.white54, size: 16),
              const SizedBox(width: 6),
              Text('${items.length} منتج', style: GoogleFonts.cairo(color: Colors.white70, fontSize: 12)),
              const SizedBox(width: 16),
              const Icon(Icons.calendar_today_outlined, color: Colors.white54, size: 14),
              const SizedBox(width: 6),
              Text(dateShort, style: GoogleFonts.cairo(color: Colors.white70, fontSize: 12)),
              const Spacer(),
              Text('$total ر.ي', style: GoogleFonts.cairo(color: const Color(0xFFFFE233), fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          if (showTrack || showRate) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                if (showTrack)
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFFFE233)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(
                        builder: (_) => OrderTrackingScreen(order: m),
                      )),
                      icon: const Icon(Icons.location_on_outlined, color: Color(0xFFFFE233), size: 18),
                      label: Text('تتبع الطلب', style: GoogleFonts.cairo(color: const Color(0xFFFFE233), fontWeight: FontWeight.bold)),
                    ),
                  ),
                if (showTrack && showRate) const SizedBox(width: 8),
                if (showRate)
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFE233),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      onPressed: () => _showRatingDialog(m['_id']?.toString() ?? '', storeName),
                      icon: const Icon(Icons.star, color: Colors.black, size: 18),
                      label: Text('قيّم', style: GoogleFonts.cairo(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _showRatingDialog(String orderId, String storeName) async {
    int stars = 5;
    final ctrl = TextEditingController();
    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          backgroundColor: const Color(0xFF15151C),
          title: Text('تقييم $storeName', style: GoogleFonts.cairo(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) => IconButton(
                  onPressed: () => setS(() => stars = i + 1),
                  icon: Icon(i < stars ? Icons.star : Icons.star_border, color: const Color(0xFFFFE233), size: 30),
                )),
              ),
              TextField(
                controller: ctrl,
                style: GoogleFonts.cairo(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'اكتب ملاحظاتك...',
                  hintStyle: GoogleFonts.cairo(color: Colors.white38),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text('إلغاء', style: GoogleFonts.cairo(color: Colors.white70))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFE233)),
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('شكراً لتقييمك ⭐', style: GoogleFonts.cairo(color: Colors.white)),
                    backgroundColor: const Color(0xFF25D366),
                  ),
                );
              },
              child: Text('إرسال', style: GoogleFonts.cairo(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
