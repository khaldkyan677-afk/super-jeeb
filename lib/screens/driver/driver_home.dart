import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'driver_theme.dart';
import 'driver_map.dart';
import '../../services/api_service.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});
  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  bool _availableDelivery = true;
  bool _availableServices = false;


  Future<void> _updateStage(String stage, String label) async {
    // TODO: نستخدم الطلب الحالي
    final res = await ApiService.updateTripStage(orderId: 'CURRENT', stage: stage);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(res.containsKey('error') ? 'خطأ: ${res['error']}' : '✓ $label'),
        backgroundColor: res.containsKey('error') ? DJ.danger : DJ.success,
      ),
    );
  }


  Future<void> _acceptFromList() async {
    final list = await ApiService.getAvailableOrders();
    if (!mounted) return;
    if (list.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا توجد طلبات متاحة'), backgroundColor: DJ.warning),
      );
      return;
    }
    final first = list.first as Map<String, dynamic>;
    final oid = first['_id'].toString();
    final res = await ApiService.acceptOrder(oid);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(res.containsKey('error') ? 'فشل: ${res['error']}' : '✓ تم قبول الطلب'),
        backgroundColor: res.containsKey('error') ? DJ.danger : DJ.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DJ.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _header(),
              const SizedBox(height: 18),
              _todaySummary(),
              const SizedBox(height: 18),
              _currentTrip(),
              const SizedBox(height: 18),
              _sectionTitle('الطلبات القريبة', 'عرض الكل'),
              const SizedBox(height: 10),
              _orderCard('#5489', 'مطعم الأصالة', 'حي المنصورة - تعز', '4,500', '2.3 كم'),
              const SizedBox(height: 10),
              _orderCard('#5490', 'متجر موبايلات', 'شارع تعز', '3,200', '3.1 كم'),
              const SizedBox(height: 10),
              _orderCard('#5491', 'صيدلية الحياة', 'حي الروضة', '2,800', '1.8 كم'),
              const SizedBox(height: 18),
              _availabilityToggles(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DJ.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: DJ.shadowSoft,
      ),
      child: Row(
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: DJ.primary,
              shape: BoxShape.circle,
              border: Border.all(color: DJ.softRed, width: 3),
            ),
            child: const Icon(Icons.person_rounded, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('أحمد علي', style: DJ.h3),
                const SizedBox(height: 3),
                Text('مندوب توصيل', style: DJ.tiny),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 8, height: 8,
                      decoration: const BoxDecoration(color: DJ.success, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 6),
                    Text('متصل الآن', style: GoogleFonts.cairo(fontSize: 11, color: DJ.success, fontWeight: FontWeight.w700)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: DJ.softRed, borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                const Icon(Icons.star_rounded, color: DJ.warning, size: 16),
                const SizedBox(width: 4),
                Text('4.8', style: GoogleFonts.cairo(fontWeight: FontWeight.w800, fontSize: 12, color: DJ.text)),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Stack(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: DJ.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: DJ.border)),
                child: const Icon(Icons.notifications_none_rounded, color: DJ.primary, size: 20),
              ),
              Positioned(
                top: 6, right: 6,
                child: Container(
                  width: 8, height: 8,
                  decoration: BoxDecoration(color: DJ.danger, shape: BoxShape.circle, border: Border.all(color: DJ.card, width: 1.5)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _todaySummary() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [DJ.primary, DJ.secondary], begin: Alignment.topRight, end: Alignment.bottomLeft),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: DJ.primary.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up_rounded, color: Colors.white, size: 22),
              const SizedBox(width: 8),
              Text('ملخص اليوم', style: GoogleFonts.cairo(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
              const Spacer(),
              Text('اليوم', style: GoogleFonts.cairo(color: Colors.white70, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 16),
          Text('24,750', style: GoogleFonts.cairo(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800)),
          Text('إجمالي الأرباح (ري)', style: GoogleFonts.cairo(color: Colors.white70, fontSize: 11)),
          const SizedBox(height: 14),
          Row(
            children: [
              _stat('12', 'الرحلات'),
              _stat('2,063', 'متوسط الرحلة'),
              _stat('12', 'المكتملة'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String val, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Text(val, style: GoogleFonts.cairo(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(label, style: GoogleFonts.cairo(color: Colors.white70, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _currentTrip() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: DJ.card, borderRadius: BorderRadius.circular(20), boxShadow: DJ.shadowSoft),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10, height: 10,
                decoration: const BoxDecoration(color: DJ.success, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text('رحلتي الآن', style: DJ.h3),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: DJ.softRed, borderRadius: BorderRadius.circular(10)),
                child: Text('قيد التوصيل', style: GoogleFonts.cairo(color: DJ.primary, fontSize: 10, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text('#5487', style: GoogleFonts.cairo(fontWeight: FontWeight.w800, fontSize: 14)),
          const SizedBox(height: 10),
          _tripLine(Icons.store_rounded, 'من:', 'مطعم الأمل'),
          const SizedBox(height: 6),
          _tripLine(Icons.location_on_rounded, 'إلى:', 'حي المنصورة - تعز'),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.access_time_rounded, color: DJ.textMuted, size: 16),
              const SizedBox(width: 6),
              Text('الوقت المتوقع: 15 دقيقة', style: DJ.muted),
            ],
          ),
          const SizedBox(height: 14),
          _tripProgress(),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DriverMapScreen())),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DJ.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.map_rounded, size: 20),
                  label: Text('فتح الخريطة', style: GoogleFonts.cairo(fontWeight: FontWeight.w800, fontSize: 13)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tripLine(IconData icon, String label, String val) {
    return Row(
      children: [
        Icon(icon, color: DJ.primary, size: 18),
        const SizedBox(width: 8),
        Text(label, style: DJ.muted),
        const SizedBox(width: 6),
        Expanded(child: Text(val, style: DJ.body.copyWith(fontWeight: FontWeight.w700, fontSize: 12))),
      ],
    );
  }

  Widget _tripProgress() {
    final steps = ['استلام', 'في الطريق', 'تم التسليم'];
    return Row(
      children: [
        for (int i = 0; i < steps.length; i++) ...[
          Expanded(
            child: GestureDetector(
              onTap: () {
                final stages = ['accepted', 'on_the_way', 'delivered'];
                _updateStage(stages[i], steps[i]);
              },
              child: Column(
                children: [
                  Container(
                    width: 22, height: 22,
                    decoration: BoxDecoration(
                      color: i <= 1 ? DJ.primary : DJ.border,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(i == 0 ? Icons.check_rounded : (i == 1 ? Icons.local_shipping_rounded : Icons.done_all_rounded), color: Colors.white, size: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(steps[i], style: DJ.tiny.copyWith(color: i <= 1 ? DJ.primary : DJ.textMuted)),
                ],
              ),
            ),
          ),
          if (i < steps.length - 1)
            Container(height: 2, width: 20, color: i < 1 ? DJ.primary : DJ.border),
        ],
      ],
    );
  }

  Widget _sectionTitle(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: DJ.h3),
        Text(action, style: GoogleFonts.cairo(color: DJ.primary, fontSize: 12, fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _orderCard(String id, String store, String address, String price, String distance) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: DJ.card, borderRadius: BorderRadius.circular(18), boxShadow: DJ.shadowSoft),
      child: Column(
        children: [
          Row(
            children: [
              Text(id, style: GoogleFonts.cairo(fontWeight: FontWeight.w800, fontSize: 13)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: DJ.softNavy, borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    const Icon(Icons.near_me_rounded, color: DJ.secondary, size: 12),
                    const SizedBox(width: 3),
                    Text(distance, style: GoogleFonts.cairo(color: DJ.secondary, fontSize: 10, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const Spacer(),
              Text('$price ري', style: DJ.price),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: DJ.softRed, borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.store_rounded, color: DJ.primary, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(store, style: DJ.body.copyWith(fontWeight: FontWeight.w700, fontSize: 12)),
                    Text(address, style: DJ.tiny),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => _acceptFromList(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: DJ.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  elevation: 0,
                ),
                child: Text('استلام الطلب', style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _availabilityToggles() {
    return Row(
      children: [
        Expanded(child: _toggleCard('متاح للخدمات', Icons.handyman_rounded, _availableServices, (v) => setState(() => _availableServices = v))),
        const SizedBox(width: 10),
        Expanded(child: _toggleCard('متاح للتوصيل', Icons.delivery_dining_rounded, _availableDelivery, (v) => setState(() => _availableDelivery = v))),
      ],
    );
  }

  Widget _toggleCard(String label, IconData icon, bool val, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: DJ.card, borderRadius: BorderRadius.circular(18), boxShadow: DJ.shadowSoft),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: DJ.primary, size: 20),
              const SizedBox(width: 6),
              Expanded(child: Text(label, style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w800))),
            ],
          ),
          const SizedBox(height: 6),
          Text(val ? 'مفعّل' : 'معطّل', style: GoogleFonts.cairo(fontSize: 10, color: val ? DJ.success : DJ.textMuted)),
          const SizedBox(height: 6),
          Switch(
            value: val,
            activeThumbColor: DJ.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
