import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'driver_theme.dart';

class DriverEarningsScreen extends StatefulWidget {
  const DriverEarningsScreen({super.key});
  @override
  State<DriverEarningsScreen> createState() => _DriverEarningsScreenState();
}

class _DriverEarningsScreenState extends State<DriverEarningsScreen> {
  int _tab = 0;
  final _tabs = ['اليوم', 'الأسبوع', 'الشهر'];

  final _data = {
    'اليوم': ['24,750', '12', '2,063', '8,500', '16,250'],
    'الأسبوع': ['156,300', '78', '2,004', '52,100', '104,200'],
    'الشهر': ['642,800', '312', '2,060', '210,300', '432,500'],
  };

  final _transactions = [
    ('#5489', 'توصيل طلب', 'اليوم 14:30', '+4,500', true),
    ('#S120', 'نقل أغراض', 'اليوم 12:15', '+5,000', true),
    ('سحب', 'طلب سحب الأرباح', 'أمس 20:00', '-15,000', false),
    ('#5488', 'توصيل طلب', 'أمس 18:45', '+3,200', true),
    ('#5487', 'توصيل طلب', 'أمس 16:20', '+2,800', true),
  ];


  void _requestWithdraw() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('سيتم إرسال طلب السحب للإدارة'),
        backgroundColor: DJ.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = _data[_tabs[_tab]]!;
    return Scaffold(
      backgroundColor: DJ.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('أرباحي', style: DJ.h1),
              const SizedBox(height: 14),
              _tabsRow(),
              const SizedBox(height: 16),
              _mainCard(d),
              const SizedBox(height: 14),
              Row(
                children: [
                  _miniCard('أرباح التوصيل', '\${d[3]} ري', Icons.delivery_dining_rounded),
                  const SizedBox(width: 10),
                  _miniCard('أرباح الخدمات', '\${d[4]} ري', Icons.handyman_rounded),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('السجل المالي', style: DJ.h3),
                  Text('عرض الكل', style: GoogleFonts.cairo(color: DJ.primary, fontSize: 12, fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 10),
              ..._transactions.map((t) => _txnCard(t)),
              const SizedBox(height: 18),
              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => _requestWithdraw(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DJ.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.account_balance_rounded, size: 20),
                  label: Text('طلب سحب الأرباح', style: GoogleFonts.cairo(fontWeight: FontWeight.w800, fontSize: 14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabsRow() {
    return Container(
      height: 44,
      decoration: BoxDecoration(color: DJ.card, borderRadius: BorderRadius.circular(14), boxShadow: DJ.shadowSoft),
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final sel = _tab == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _tab = i),
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: sel ? DJ.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(11),
                ),
                alignment: Alignment.center,
                child: Text(_tabs[i], style: GoogleFonts.cairo(
                  color: sel ? Colors.white : DJ.textMuted,
                  fontSize: 13, fontWeight: FontWeight.w800,
                )),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _mainCard(List<String> d) {
    return Container(
      padding: const EdgeInsets.all(20),
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
              const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 22),
              const SizedBox(width: 8),
              Text('إجمالي الأرباح', style: GoogleFonts.cairo(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(d[0], style: GoogleFonts.cairo(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w800)),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text('ري', style: GoogleFonts.cairo(color: Colors.white70, fontSize: 14)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _statPill(Icons.route_rounded, '${d[1]} رحلة'),
              const SizedBox(width: 8),
              _statPill(Icons.trending_up_rounded, 'متوسط ${d[2]} ري'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statPill(IconData ic, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Icon(ic, color: Colors.white, size: 14),
          const SizedBox(width: 6),
          Text(label, style: GoogleFonts.cairo(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _miniCard(String label, String val, IconData ic) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: DJ.card, borderRadius: BorderRadius.circular(16), boxShadow: DJ.shadowSoft),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: DJ.softRed, borderRadius: BorderRadius.circular(10)),
              child: Icon(ic, color: DJ.primary, size: 18),
            ),
            const SizedBox(height: 10),
            Text(val, style: GoogleFonts.cairo(fontWeight: FontWeight.w800, fontSize: 14)),
            const SizedBox(height: 2),
            Text(label, style: DJ.tiny),
          ],
        ),
      ),
    );
  }

  Widget _txnCard((String, String, String, String, bool) t) {
    final isPositive = t.$5;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: DJ.card, borderRadius: BorderRadius.circular(16), boxShadow: DJ.shadowSoft),
      child: Row(
        children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: isPositive ? DJ.softRed : DJ.softNavy,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isPositive ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
              color: isPositive ? DJ.primary : DJ.secondary, size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(t.$1, style: GoogleFonts.cairo(fontWeight: FontWeight.w800, fontSize: 13)),
                    const SizedBox(width: 6),
                    Text(t.$2, style: DJ.muted.copyWith(fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 3),
                Text(t.$3, style: DJ.tiny),
              ],
            ),
          ),
          Text(t.$4, style: GoogleFonts.cairo(
            fontWeight: FontWeight.w800, fontSize: 14,
            color: isPositive ? DJ.success : DJ.danger,
          )),
        ],
      ),
    );
  }
}
