import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'driver_theme.dart';

class DriverOrdersScreen extends StatefulWidget {
  const DriverOrdersScreen({super.key});
  @override
  State<DriverOrdersScreen> createState() => _DriverOrdersScreenState();
}

class _DriverOrdersScreenState extends State<DriverOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() { _tabs.dispose(); super.dispose(); }

  final _delivery = [
    _O('#5489', 'مطعم الأصالة', 'حي المنصورة', 'حي الروضة', '4,500', '2.3 كم', '15 د'),
    _O('#5490', 'متجر موبايلات', 'شارع تعز', 'حي الشماسي', '3,200', '3.1 كم', '20 د'),
    _O('#5491', 'صيدلية الحياة', 'حي الروضة', 'حي المظفر', '2,800', '1.8 كم', '10 د'),
  ];

  final _services = [
    _O('#S120', 'نقل أغراض', 'حي القاهرة', 'حي السنينة', '5,000', '4.2 كم', '25 د'),
    _O('#S121', 'مشوار', 'شارع جمال', 'مطار تعز', '7,000', '8.5 كم', '35 د'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DJ.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Text('الطلبات', style: DJ.h1),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: DJ.softRed, borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        const Icon(Icons.filter_list_rounded, color: DJ.primary, size: 16),
                        const SizedBox(width: 4),
                        Text('تصفية', style: GoogleFonts.cairo(color: DJ.primary, fontSize: 12, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 44,
              decoration: BoxDecoration(color: DJ.card, borderRadius: BorderRadius.circular(14), boxShadow: DJ.shadowSoft),
              child: TabBar(
                controller: _tabs,
                labelColor: Colors.white,
                unselectedLabelColor: DJ.textMuted,
                labelStyle: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w800),
                unselectedLabelStyle: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w600),
                indicator: BoxDecoration(color: DJ.primary, borderRadius: BorderRadius.circular(12)),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: const EdgeInsets.all(4),
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'طلبات التوصيل'),
                  Tab(text: 'طلبات الخدمات'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TabBarView(
                controller: _tabs,
                children: [
                  _list(_delivery),
                  _list(_services),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _list(List<_O> list) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_rounded, color: DJ.textMuted, size: 64),
            const SizedBox(height: 12),
            Text('لا توجد طلبات', style: DJ.muted),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      itemCount: list.length,
      separatorBuilder: (_, i) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _card(list[i]),
    );
  }

  Widget _card(_O o) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: DJ.card, borderRadius: BorderRadius.circular(18), boxShadow: DJ.shadowSoft),
      child: Column(
        children: [
          Row(
            children: [
              Text(o.id, style: GoogleFonts.cairo(fontWeight: FontWeight.w800, fontSize: 13)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: DJ.softNavy, borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    const Icon(Icons.near_me_rounded, color: DJ.secondary, size: 12),
                    const SizedBox(width: 3),
                    Text(o.distance, style: GoogleFonts.cairo(color: DJ.secondary, fontSize: 10, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const Spacer(),
              Text('${o.price} ري', style: DJ.price),
            ],
          ),
          const SizedBox(height: 12),
          _row(Icons.store_rounded, 'من:', o.from),
          const SizedBox(height: 6),
          _row(Icons.location_on_rounded, 'إلى:', o.to),
          const SizedBox(height: 6),
          _row(Icons.access_time_rounded, 'الوقت:', o.duration),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: DJ.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: Text('رفض', style: GoogleFonts.cairo(color: DJ.textMuted, fontWeight: FontWeight.w800, fontSize: 12)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () => _showActions(o),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DJ.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 0,
                  ),
                  child: Text('قبول الطلب', style: GoogleFonts.cairo(fontWeight: FontWeight.w800, fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(IconData ic, String label, String val) {
    return Row(
      children: [
        Icon(ic, color: DJ.primary, size: 16),
        const SizedBox(width: 8),
        Text(label, style: DJ.muted.copyWith(fontSize: 11)),
        const SizedBox(width: 6),
        Expanded(child: Text(val, style: DJ.body.copyWith(fontWeight: FontWeight.w700, fontSize: 12))),
      ],
    );
  }

  void _showActions(_O o) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: DJ.card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: DJ.border, borderRadius: BorderRadius.circular(4))),
            const SizedBox(height: 20),
            Text('مراحل الرحلة', style: DJ.h3),
            const SizedBox(height: 16),
            ..._stages.map((s) => _stageItem(s)),
          ],
        ),
      ),
    );
  }

  final _stages = [
    ('توجه إلى المتجر', Icons.directions_bike_rounded),
    ('وصلت إلى المتجر', Icons.store_rounded),
    ('استلمت الطلب', Icons.inventory_2_rounded),
    ('في الطريق', Icons.local_shipping_rounded),
    ('وصلت للعميل', Icons.pin_drop_rounded),
    ('تم التسليم', Icons.check_circle_rounded),
  ];

  Widget _stageItem((String, IconData) s) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: DJ.softRed, borderRadius: BorderRadius.circular(12)),
            child: Icon(s.$2, color: DJ.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(s.$1, style: DJ.body.copyWith(fontWeight: FontWeight.w700, fontSize: 13))),
          Icon(Icons.chevron_left_rounded, color: DJ.textMuted),
        ],
      ),
    );
  }
}

class _O {
  final String id, from, fromAddr, to, price, distance, duration;
  _O(this.id, this.from, this.fromAddr, this.to, this.price, this.distance, this.duration);
}
