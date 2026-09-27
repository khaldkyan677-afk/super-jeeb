import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'merchant_theme.dart';

class MerchantHomeScreen extends StatefulWidget {
  const MerchantHomeScreen({super.key});
  @override
  State<MerchantHomeScreen> createState() => _MerchantHomeScreenState();
}

class _MerchantHomeScreenState extends State<MerchantHomeScreen> {
  final bool _open = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MJ.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _header(),
              const SizedBox(height: 18),
              _pulseCard(),
              const SizedBox(height: 20),
              _sectionTitle('طلبات تحتاج انتباهك', 'عرض الكل'),
              const SizedBox(height: 10),
              _orderCard('#5487', 'أحمد محمد', '5 منتجات', '8,500 ري', 'جديد', Colors.red, 'منذ 12 دقيقة'),
              const SizedBox(height: 10),
              _orderCard('#5486', 'سارة علي', '3 منتجات', '5,200 ري', 'قيد التجهيز', MJ.warning, 'منذ 28 دقيقة'),
              const SizedBox(height: 10),
              _orderCard('#5485', 'محمد عبدالله', '2 منتج', '3,700 ري', 'جاهز للمندوب', MJ.success, 'منذ ساعة'),
              const SizedBox(height: 20),
              _storePreview(),
              const SizedBox(height: 20),
              _sectionTitle('أحدث المنتجات', 'عرض الكل'),
              const SizedBox(height: 10),
              SizedBox(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _productMini('طماطم طازجة', '1,200', Icons.eco_rounded),
                    _productMini('موز', '900', Icons.agriculture_rounded),
                    _productMini('تفاح أحمر', '1,500', Icons.apple_rounded),
                    _addProductMini(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _quickActions(),
            ],
          ),
        ),
      ),
    );
  }

  // ── الرأس ──
  Widget _header() {
    return Row(
      children: [
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(color: MJ.primary, borderRadius: BorderRadius.circular(14)),
          child: const Icon(Icons.storefront_rounded, color: Colors.white, size: 26),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('متجر الفواكه الطازجة', style: MJ.h3),
              const SizedBox(height: 3),
              Row(
                children: [
                  Container(width: 8, height: 8, decoration: BoxDecoration(color: _open ? MJ.success : MJ.danger, shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  Text(_open ? 'مفتوح الآن' : 'مغلق', style: GoogleFonts.cairo(fontSize: 11, color: _open ? MJ.success : MJ.danger, fontWeight: FontWeight.w700)),
                ],
              ),
            ],
          ),
        ),
        Stack(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: MJ.card, borderRadius: BorderRadius.circular(14), boxShadow: MJ.shadowSoft),
              child: Icon(Icons.notifications_none_rounded, color: MJ.primary),
            ),
            Positioned(
              top: 8, right: 8,
              child: Container(width: 10, height: 10, decoration: BoxDecoration(color: MJ.danger, shape: BoxShape.circle, border: Border.all(color: MJ.card, width: 2))),
            ),
          ],
        ),
      ],
    );
  }

  // ── نبض المتجر ──
  Widget _pulseCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [MJ.primary, MJ.primaryLight], begin: Alignment.topRight, end: Alignment.bottomLeft),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: MJ.primary.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.monitor_heart_rounded, color: Colors.white, size: 22),
              const SizedBox(width: 8),
              Text('نبض متجرك', style: GoogleFonts.cairo(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
              const Spacer(),
              Text('اليوم', style: GoogleFonts.cairo(color: Colors.white70, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _stat('المبيعات اليوم', '23', Icons.trending_up_rounded),
              _stat('الطلبات الجديدة', '5', Icons.fiber_new_rounded),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _stat('قيد التجهيز', '5', Icons.hourglass_top_rounded),
              _stat('إجمالي اليوم', '12,450', Icons.payments_rounded),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String val, IconData ic) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(14)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(ic, color: Colors.white70, size: 18),
            const SizedBox(height: 6),
            Text(val, style: GoogleFonts.cairo(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(label, style: GoogleFonts.cairo(color: Colors.white70, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  // ── عنوان قسم ──
  Widget _sectionTitle(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: MJ.h3),
        Text(action, style: GoogleFonts.cairo(color: MJ.primary, fontSize: 12, fontWeight: FontWeight.w700)),
      ],
    );
  }

  // ── بطاقة طلب ──
  Widget _orderCard(String id, String name, String items, String price, String status, Color stColor, String time) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: MJ.card, borderRadius: BorderRadius.circular(18), boxShadow: MJ.shadowSoft),
      child: Row(
        children: [
          Container(
            width: 50, height: 50,
            decoration: BoxDecoration(color: MJ.softPink, borderRadius: BorderRadius.circular(14)),
            child: Icon(Icons.receipt_long_rounded, color: MJ.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(id, style: GoogleFonts.cairo(fontWeight: FontWeight.w800, fontSize: 13)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: stColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                      child: Text(status, style: GoogleFonts.cairo(color: stColor, fontSize: 10, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('$name • $items', style: MJ.muted),
                const SizedBox(height: 2),
                Text(time, style: MJ.tiny),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(price, style: MJ.price),
              const SizedBox(height: 4),
              Icon(Icons.chevron_left_rounded, color: MJ.textMuted),
            ],
          ),
        ],
      ),
    );
  }

  // ── معاينة المتجر ──
  Widget _storePreview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [MJ.primary.withValues(alpha: 0.9), MJ.primaryLight], begin: Alignment.topRight, end: Alignment.bottomLeft),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: MJ.primary.withValues(alpha: 0.25), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('واجهة متجري', style: GoogleFonts.cairo(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text('شاهد كيف يظهر متجرك للعميل', style: GoogleFonts.cairo(color: Colors.white70, fontSize: 11)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Text('معاينة الآن', style: GoogleFonts.cairo(color: MJ.primary, fontSize: 11, fontWeight: FontWeight.w800)),
                ),
              ],
            ),
          ),
          Icon(Icons.store_rounded, color: Colors.white.withValues(alpha: 0.25), size: 64),
        ],
      ),
    );
  }

  // ── منتج صغير ──
  Widget _productMini(String name, String price, IconData icon) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(left: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: MJ.card, borderRadius: BorderRadius.circular(16), boxShadow: MJ.shadowSoft),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 60,
            decoration: BoxDecoration(color: MJ.softPink, borderRadius: BorderRadius.circular(12)),
            child: Center(child: Icon(icon, color: MJ.primary, size: 32)),
          ),
          const SizedBox(height: 8),
          Text(name, style: MJ.body.copyWith(fontWeight: FontWeight.w700, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text('$price ري', style: MJ.price.copyWith(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _addProductMini() {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(color: MJ.softPink, borderRadius: BorderRadius.circular(16), border: Border.all(color: MJ.primary.withValues(alpha: 0.2), style: BorderStyle.solid)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_circle_rounded, color: MJ.primary, size: 34),
          const SizedBox(height: 6),
          Text('إضافة منتج', style: GoogleFonts.cairo(color: MJ.primary, fontSize: 11, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  // ── أزرار سريعة ──
  Widget _quickActions() {
    return Row(
      children: [
        _action(Icons.add_box_rounded, 'إضافة منتج'),
        const SizedBox(width: 10),
        _action(Icons.manage_accounts_rounded, 'إدارة الطلبات'),
        const SizedBox(width: 10),
        _action(Icons.local_offer_rounded, 'إضافة عرض'),
      ],
    );
  }

  Widget _action(IconData ic, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(color: MJ.card, borderRadius: BorderRadius.circular(16), boxShadow: MJ.shadowSoft),
        child: Column(
          children: [
            Icon(ic, color: MJ.primary, size: 24),
            const SizedBox(height: 6),
            Text(label, style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
