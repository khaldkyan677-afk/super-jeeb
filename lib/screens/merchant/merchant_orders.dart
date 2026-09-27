import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'merchant_theme.dart';
import '../../services/api_service.dart';

class MerchantOrdersScreen extends StatefulWidget {
  const MerchantOrdersScreen({super.key});
  @override
  State<MerchantOrdersScreen> createState() => _MerchantOrdersScreenState();
}

class _MerchantOrdersScreenState extends State<MerchantOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  final _statuses = ['جديدة', 'قيد المراجعة', 'قيد التجهيز', 'جاهزة للمندوب', 'مع المندوب', 'مكتملة', 'ملغاة'];
  List<_Order> _orders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: _statuses.length, vsync: this);
    _loadOrders();
  }

  @override
  void dispose() { _tabs.dispose(); super.dispose(); }

  Future<void> _loadOrders() async {
    setState(() => _loading = true);
    final data = await ApiService.getMerchantOrders();
    final statusMap = {
      'pending': 'جديدة',
      'accepted': 'قيد المراجعة',
      'preparing': 'قيد التجهيز',
      'ready': 'جاهزة للمندوب',
      'on_the_way': 'مع المندوب',
      'delivered': 'مكتملة',
      'cancelled': 'ملغاة',
    };
    final list = data.map((raw) {
      final o = raw as Map<String, dynamic>;
      final client = o['clientId'] as Map<String, dynamic>?;
      final driver = o['driverId'] as Map<String, dynamic>?;
      final items = (o['items'] as List<dynamic>?) ?? [];
      final oid = (o['_id'] ?? '').toString();
      return _Order(
        id: oid,
        shortId: '#${oid.length >= 6 ? oid.substring(0, 6) : oid}',
        customer: client?['name'] ?? 'عميل',
        phone: client?['phone'] ?? '—',
        itemsCount: '${items.length} منتجات',
        total: '${o['total'] ?? 0}',
        statusLabel: statusMap[o['status']] ?? 'جديدة',
        rawStatus: o['status'] ?? 'pending',
        payment: 'نقداً',
        address: o['address'] ?? 'صنعاء',
        driver: driver?['name'] ?? 'لا يوجد',
        notes: o['notes'] ?? '',
      );
    }).toList();

    if (!mounted) return;
    setState(() { _orders = list; _loading = false; });
  }

  List<_Order> _filter(String s) => _orders.where((o) => o.statusLabel == s).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MJ.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Text('الطلبات', style: MJ.h1),
                  const Spacer(),
                  InkWell(
                    onTap: _loadOrders,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: MJ.softPink, borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          Icon(Icons.refresh_rounded, color: MJ.primary, size: 16),
                          const SizedBox(width: 4),
                          Text('تحديث', style: GoogleFonts.cairo(color: MJ.primary, fontSize: 12, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 40,
              child: TabBar(
                controller: _tabs,
                isScrollable: true,
                labelColor: Colors.white,
                unselectedLabelColor: MJ.textMuted,
                labelStyle: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700),
                unselectedLabelStyle: GoogleFonts.cairo(fontSize: 12),
                indicator: BoxDecoration(color: MJ.primary, borderRadius: BorderRadius.circular(12)),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                tabs: _statuses.map((s) => Tab(
                  child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text(s)),
                )).toList(),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: MJ.primary))
                  : RefreshIndicator(
                      color: MJ.primary,
                      onRefresh: _loadOrders,
                      child: TabBarView(
                        controller: _tabs,
                        children: _statuses.map((s) {
                          final list = _filter(s);
                          if (list.isEmpty) return _emptyState();
                          return ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                            itemCount: list.length,
                            separatorBuilder: (_, i) => const SizedBox(height: 10),
                            itemBuilder: (_, i) => _orderCard(list[i]),
                          );
                        }).toList(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.inbox_rounded, color: MJ.textMuted, size: 64),
        const SizedBox(height: 12),
        Text('لا توجد طلبات في هذه الحالة', style: MJ.muted),
      ],
    ),
  );

  Widget _orderCard(_Order o) {
    final stColor = _statusColor(o.rawStatus);
    return GestureDetector(
      onTap: () => _openDetails(o),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: MJ.card, borderRadius: BorderRadius.circular(18), boxShadow: MJ.shadowSoft),
        child: Column(
          children: [
            Row(
              children: [
                Text(o.shortId, style: GoogleFonts.cairo(fontWeight: FontWeight.w800, fontSize: 14)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: stColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                  child: Text(o.statusLabel, style: GoogleFonts.cairo(color: stColor, fontSize: 10, fontWeight: FontWeight.w700)),
                ),
                const Spacer(),
                Text('${o.total} ري', style: MJ.price),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: MJ.softPink, borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.person_rounded, color: MJ.primary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(o.customer, style: MJ.body.copyWith(fontWeight: FontWeight.w700, fontSize: 12)),
                      Text('${o.itemsCount} • ${o.payment}', style: MJ.tiny),
                    ],
                  ),
                ),
                Icon(Icons.chevron_left_rounded, color: MJ.textMuted),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'pending': return MJ.danger;
      case 'accepted': return MJ.warning;
      case 'preparing': return MJ.warning;
      case 'ready': return MJ.success;
      case 'on_the_way': return MJ.primary;
      case 'delivered': return MJ.success;
      case 'cancelled': return MJ.textMuted;
      default: return MJ.textMuted;
    }
  }

  void _openDetails(_Order o) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _orderDetailsSheet(o),
    );
  }

  Widget _orderDetailsSheet(_Order o) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, scroll) => Container(
        decoration: const BoxDecoration(color: MJ.bg, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
        child: ListView(
          controller: scroll,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: MJ.border, borderRadius: BorderRadius.circular(4)))),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('تفاصيل الطلب ${o.shortId}', style: MJ.h2),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: _statusColor(o.rawStatus).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                  child: Text(o.statusLabel, style: GoogleFonts.cairo(color: _statusColor(o.rawStatus), fontSize: 11, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _infoSection('بيانات العميل', [
              _infoRow(Icons.person_rounded, 'الاسم', o.customer),
              _infoRow(Icons.phone_rounded, 'الجوال', o.phone),
            ]),
            const SizedBox(height: 14),
            _infoSection('المنتجات', [
              _infoRow(Icons.shopping_bag_rounded, 'العناصر', o.itemsCount),
              _infoRow(Icons.payments_rounded, 'الإجمالي', '${o.total} ري'),
              _infoRow(Icons.credit_card_rounded, 'الدفع', o.payment),
            ]),
            const SizedBox(height: 14),
            _infoSection('التوصيل', [
              _infoRow(Icons.location_on_rounded, 'العنوان', o.address),
              _infoRow(Icons.delivery_dining_rounded, 'المندوب', o.driver),
            ]),
            if (o.notes.isNotEmpty) ...[
              const SizedBox(height: 14),
              _infoSection('ملاحظات', [_infoRow(Icons.notes_rounded, 'ملاحظة', o.notes)]),
            ],
            const SizedBox(height: 20),
            Text('الإجراءات', style: MJ.h3),
            const SizedBox(height: 10),
            _actionButtons(o),
          ],
        ),
      ),
    );
  }

  Widget _infoSection(String title, List<Widget> rows) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: MJ.card, borderRadius: BorderRadius.circular(16), boxShadow: MJ.shadowSoft),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: MJ.h3.copyWith(fontSize: 13)),
        const SizedBox(height: 10),
        ...rows,
      ],
    ),
  );

  Widget _infoRow(IconData ic, String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        Icon(ic, color: MJ.primary, size: 18),
        const SizedBox(width: 10),
        Text('$label:', style: MJ.muted),
        const SizedBox(width: 6),
        Expanded(child: Text(value, style: MJ.body.copyWith(fontWeight: FontWeight.w700, fontSize: 12))),
      ],
    ),
  );

  Widget _actionButtons(_Order o) {
    final buttons = <Widget>[];
    if (o.rawStatus == 'pending') {
      buttons.add(_btn('قبول الطلب', MJ.success, Icons.check_rounded, 'accepted', o));
      buttons.add(_btn('رفض الطلب', MJ.danger, Icons.close_rounded, 'cancelled', o));
    } else if (o.rawStatus == 'accepted') {
      buttons.add(_btn('بدء التجهيز', MJ.warning, Icons.play_arrow_rounded, 'preparing', o));
    } else if (o.rawStatus == 'preparing') {
      buttons.add(_btn('الطلب جاهز', MJ.success, Icons.done_all_rounded, 'ready', o));
    } else if (o.rawStatus == 'ready') {
      buttons.add(_btn('إلغاء الطلب', MJ.danger, Icons.cancel_rounded, 'cancelled', o));
    }
    return Column(
      children: buttons.map((b) => Padding(padding: const EdgeInsets.only(bottom: 10), child: b)).toList(),
    );
  }

  Widget _btn(String label, Color color, IconData ic, String newStatus, _Order o) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: () async {
          Navigator.pop(context);
          final res = await ApiService.updateOrderStatus(orderId: o.id, status: newStatus);
          if (!mounted) return;
          if (res.containsKey('error')) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('فشل: ${res['error']}', style: GoogleFonts.cairo()), backgroundColor: MJ.danger),
            );
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم: $label', style: GoogleFonts.cairo()), backgroundColor: color),
          );
          _loadOrders();
        },
        icon: Icon(ic, color: Colors.white, size: 20),
        label: Text(label, style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
      ),
    );
  }
}

class _Order {
  final String id, shortId, customer, phone, itemsCount, total, statusLabel, rawStatus, payment, address, driver, notes;
  _Order({
    required this.id,
    required this.shortId,
    required this.customer,
    required this.phone,
    required this.itemsCount,
    required this.total,
    required this.statusLabel,
    required this.rawStatus,
    required this.payment,
    required this.address,
    required this.driver,
    required this.notes,
  });
}
