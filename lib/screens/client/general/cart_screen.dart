import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _kRed = Color(0xFFEF233C);
const _kBg = Color(0xFF0D0D12);
const _kSurface = Color(0xFF1A1B26);
const _kGreen = Color(0xFF25D366);

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int _step = 0;

  final List<Map<String, dynamic>> _groups = [
    {
      'store': 'متجر الأناقة للملابس',
      'items': [
        {'name': 'قميص رجالي كلاسيك', 'price': 8000, 'qty': 1, 'icon': Icons.checkroom},
        {'name': 'بنطال جينز', 'price': 12000, 'qty': 1, 'icon': Icons.checkroom},
      ],
    },
  ];

  double get _subtotal {
    double t = 0;
    for (final g in _groups) {
      for (final i in (g['items'] as List)) {
        t += (i['price'] as int) * (i['qty'] as int);
      }
    }
    return t;
  }

  double get _delivery => 1500;
  double get _total => _subtotal + _delivery;

  void _inc(int gi, int ii) => setState(() => ((_groups[gi]['items'] as List)[ii]['qty'] as int).toString());
  void _changeQty(int gi, int ii, int delta) {
    setState(() {
      final items = _groups[gi]['items'] as List;
      final cur = items[ii]['qty'] as int;
      final n = cur + delta;
      if (n <= 0) { items.removeAt(ii); if (items.isEmpty) _groups.removeAt(gi); }
      else { items[ii]['qty'] = n; }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: _groups.isEmpty ? _buildEmpty() : _buildContent(),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(color: _kSurface, shape: BoxShape.circle),
            child: const Icon(Icons.shopping_cart_outlined, color: _kRed, size: 48),
          ),
          const SizedBox(height: 20),
          Text('سلة التسوق فارغة', style: GoogleFonts.cairo(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text('أضف منتجات لتبدأ الطلب', style: GoogleFonts.cairo(color: Colors.grey, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        _buildSteps(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ...List.generate(_groups.length, (gi) => _buildStoreGroup(gi)),
              const SizedBox(height: 8),
              _buildSummary(),
            ],
          ),
        ),
        _buildBottomBar(),
      ],
    );
  }

  Widget _buildSteps() {
    final steps = ['السلة', 'العنوان', 'الدفع', 'التأكيد'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            final done = (i ~/ 2) < _step;
            return Expanded(child: Container(height: 2, color: done ? _kRed : _kSurface));
          }
          final idx = i ~/ 2;
          final active = idx <= _step;
          return Column(
            children: [
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: active ? _kRed : _kSurface,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text('${idx + 1}', style: GoogleFonts.cairo(color: active ? Colors.white : Colors.grey, fontSize: 13, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 4),
              Text(steps[idx], style: GoogleFonts.cairo(color: active ? Colors.white : Colors.grey, fontSize: 10)),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStoreGroup(int gi) {
    final g = _groups[gi];
    final items = g['items'] as List;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: _kSurface, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.storefront, color: _kRed, size: 20),
              const SizedBox(width: 8),
              Expanded(child: Text(g['store'] as String, style: GoogleFonts.cairo(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: _kRed.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                child: Text('${items.length} منتج', style: GoogleFonts.cairo(color: _kRed, fontSize: 11, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const Divider(color: Colors.white12, height: 20),
          ...List.generate(items.length, (ii) => _buildItem(gi, ii, items[ii])),
        ],
      ),
    );
  }

  Widget _buildItem(int gi, int ii, Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 50, height: 50,
            decoration: BoxDecoration(color: _kBg, borderRadius: BorderRadius.circular(10)),
            child: Icon(item['icon'] as IconData, color: _kRed, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name'] as String, style: GoogleFonts.cairo(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text('${item['price']} YER', style: GoogleFonts.cairo(color: _kRed, fontSize: 13, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          _qtyBtn(Icons.remove, () => _changeQty(gi, ii, -1), _kSurface, _kRed),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('${item['qty']}', style: GoogleFonts.cairo(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
          ),
          _qtyBtn(Icons.add, () => _changeQty(gi, ii, 1), _kRed, Colors.white),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap, Color bg, Color fg) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28, height: 28,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle, border: bg == _kSurface ? Border.all(color: _kRed) : null),
        child: Icon(icon, color: fg, size: 16),
      ),
    );
  }

  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: _kSurface, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          _sumRow('المجموع', '${_subtotal.toStringAsFixed(0)} YER', Colors.white),
          const SizedBox(height: 8),
          _sumRow('التوصيل', '${_delivery.toStringAsFixed(0)} YER', Colors.white),
          const Divider(color: Colors.white12, height: 20),
          _sumRow('الإجمالي', '${_total.toStringAsFixed(0)} YER', _kRed, bold: true),
        ],
      ),
    );
  }

  Widget _sumRow(String label, String value, Color color, {bool bold = false}) {
    return Row(
      children: [
        Text(label, style: GoogleFonts.cairo(color: bold ? Colors.white : Colors.grey, fontSize: bold ? 16 : 13, fontWeight: bold ? FontWeight.w700 : FontWeight.w500)),
        const Spacer(),
        Text(value, style: GoogleFonts.cairo(color: color, fontSize: bold ? 16 : 13, fontWeight: bold ? FontWeight.w700 : FontWeight.w600)),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: GestureDetector(
        onTap: () => setState(() => _step = (_step + 1).clamp(0, 3)),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: _kRed,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: _kRed.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6))],
          ),
          child: Center(
            child: Text('متابعة إلى العنوان', style: GoogleFonts.cairo(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
          ),
        ),
      ),
    );
  }
}
