import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'track_order_screen.dart';

const _kRed = Color(0xFFEF233C);
const _kBg = Color(0xFF0D0D12);
const _kSurface = Color(0xFF1A1B26);

class RequestFormScreen extends StatefulWidget {
  final String serviceType;
  final IconData icon;
  const RequestFormScreen({super.key, required this.serviceType, required this.icon});

  @override
  State<RequestFormScreen> createState() => _RequestFormScreenState();
}

class _RequestFormScreenState extends State<RequestFormScreen> {
  final _c1 = TextEditingController();
  final _c2 = TextEditingController();
  final _c3 = TextEditingController();
  final _c4 = TextEditingController();
  String _option = '';
  List<Map<String, dynamic>> _stores = [];
  String? _selectedStore;
  String _payMethod = 'كاش';

  @override
  void initState() {
    super.initState();
    _loadStores();
  }

  Future<void> _loadStores() async {
    try {
      final r = await http.get(Uri.base.resolve('/api/stores'));
      if (r.statusCode == 200) {
        final list = jsonDecode(r.body) as List;
        if (mounted) setState(() => _stores = list.cast<Map<String, dynamic>>());
      }
    } catch (_) {}
  }

  List<Map<String, dynamic>> get _fields {
    switch (widget.serviceType) {
      case 'تاكسي': return [
        {'c': _c1, 'label': 'من (نقطة الانطلاق)', 'icon': Icons.my_location},
        {'c': _c2, 'label': 'إلى (الوجهة)', 'icon': Icons.location_on},
        {'c': _c3, 'label': 'وقت الرحلة (الآن / موعد)', 'icon': Icons.access_time},
      ];
      case 'طرود': return [
        {'c': _c1, 'label': 'من (موقع الاستلام)', 'icon': Icons.my_location},
        {'c': _c2, 'label': 'إلى (موقع التسليم)', 'icon': Icons.location_on},
        {'c': _c3, 'label': 'وصف الطرد (حجم/وزن)', 'icon': Icons.inventory_2},
        {'c': _c4, 'label': 'رقم المستلم', 'icon': Icons.phone},
      ];
      case 'فرزة': return [
        {'c': _c1, 'label': 'من (نقطة التجمع)', 'icon': Icons.my_location},
        {'c': _c2, 'label': 'إلى (الوجهة)', 'icon': Icons.location_on},
        {'c': _c3, 'label': 'عدد الركاب', 'icon': Icons.people},
        {'c': _c4, 'label': 'وقت الرحلة', 'icon': Icons.access_time},
      ];
      case 'Super Express': return [
        {'c': _c1, 'label': 'من (موقع الاستلام)', 'icon': Icons.my_location},
        {'c': _c2, 'label': 'إلى (موقع التسليم)', 'icon': Icons.location_on},
        {'c': _c3, 'label': 'وصف الشحنة (نوع/حجم)', 'icon': Icons.inventory_2},
        {'c': _c4, 'label': 'رقم المستلم', 'icon': Icons.phone},
      ];
      case 'اشتري لي': return [
        {'c': _c1, 'label': 'من (المتجر / السوق)', 'icon': Icons.storefront},
        {'c': _c2, 'label': 'قائمة المشتريات', 'icon': Icons.list_alt},
        {'c': _c3, 'label': 'الميزانية التقريبية', 'icon': Icons.attach_money},
      ];
    }
    return [];
  }

  List<String> get _options {
    switch (widget.serviceType) {
      case 'تاكسي': return ['اقتصادي', 'مريح', 'VIP'];
      case 'طرود': return ['عادي', 'سريع', 'فوري'];
      case 'فرزة': return ['4 ركاب', '7 ركاب', '14 راكب'];
      case 'Super Express': return ['خلال ساعة', 'تأمين الشحنة', 'تتبع لحظي'];
      case 'اشتري لي': return ['دفع كاش', 'دفع محفظة'];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: _kBg,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: Text(widget.serviceType, style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _hero(),
          const SizedBox(height: 20),
          ..._fields.map(_buildField).toList(),
          if (widget.serviceType == 'اشتري لي') ...[
            const SizedBox(height: 20),
            Text('اختر المتجر', style: GoogleFonts.cairo(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 8),
            _buildStoreDropdown(),
            const SizedBox(height: 16),
            _buildCostBreakdown(),
          ],
          const SizedBox(height: 20),
          Text('الخيارات', style: GoogleFonts.cairo(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: _options.map((o) => _buildChip(o)).toList(),
          ),
          const SizedBox(height: 20),
          Text('طريقة الدفع', style: GoogleFonts.cairo(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 8),
          _buildPayMethods(),
          const SizedBox(height: 30),
          _buildButton(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildStoreDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: _kSurface, borderRadius: BorderRadius.circular(14)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedStore,
          isExpanded: true,
          dropdownColor: _kSurface,
          icon: const Icon(Icons.arrow_drop_down, color: _kRed),
          hint: Text('اختر متجراً...', style: GoogleFonts.cairo(color: Colors.grey, fontSize: 14)),
          items: _stores.map((s) {
            final name = (s['name'] ?? '').toString();
            return DropdownMenuItem<String>(
              value: name,
              child: Text(name, style: GoogleFonts.cairo(color: Colors.white, fontSize: 14)),
            );
          }).toList(),
          onChanged: (v) => setState(() => _selectedStore = v),
        ),
      ),
    );
  }

  double _parseBudget() {
    final t = _c3.text.trim();
    if (t.isEmpty) return 0;
    return double.tryParse(t) ?? 0;
  }

  Widget _buildCostBreakdown() {
    final budget = _parseBudget();
    final delivery = 500.0;
    final commission = budget * 0.05;
    final total = budget + delivery + commission;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: _kSurface, borderRadius: BorderRadius.circular(14), border: Border.all(color: _kRed.withOpacity(0.3))),
      child: Column(
        children: [
          _costRow('قيمة المشتريات', budget),
          const SizedBox(height: 6),
          _costRow('رسوم التوصيل', delivery),
          const SizedBox(height: 6),
          _costRow('عمولة الخدمة (5%)', commission),
          const Divider(color: Colors.white12, height: 18),
          _costRow('الإجمالي', total, bold: true),
        ],
      ),
    );
  }

  Widget _costRow(String label, double value, {bool bold = false}) {
    return Row(
      children: [
        Text(label, style: GoogleFonts.cairo(color: bold ? Colors.white : Colors.grey, fontSize: bold ? 14 : 12, fontWeight: bold ? FontWeight.w700 : FontWeight.w500)),
        const Spacer(),
        Text('${value.toStringAsFixed(0)} ر.ي', style: GoogleFonts.cairo(color: _kRed, fontSize: bold ? 14 : 12, fontWeight: bold ? FontWeight.w700 : FontWeight.w600)),
      ],
    );
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: _kSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: _kRed.withOpacity(0.15), shape: BoxShape.circle),
                child: const Icon(Icons.check_circle, color: _kRed, size: 44),
              ),
              const SizedBox(height: 14),
              Text('تأكيد الطلب', style: GoogleFonts.cairo(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text('سيتم إرسال طلب ${widget.serviceType} الآن', style: GoogleFonts.cairo(color: Colors.grey, fontSize: 13), textAlign: TextAlign.center),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(color: _kBg, borderRadius: BorderRadius.circular(12)),
                        child: Center(child: Text('إلغاء', style: GoogleFonts.cairo(color: Colors.grey, fontWeight: FontWeight.w600))),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TrackOrderScreen(serviceType: widget.serviceType)));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(color: _kRed, borderRadius: BorderRadius.circular(12)),
                        child: Center(child: Text('تأكيد', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.w700))),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPayMethods() {
    final methods = [
      {'label': 'كاش', 'icon': Icons.payments_outlined},
      {'label': 'محفظة', 'icon': Icons.account_balance_wallet_outlined},
      {'label': 'دفع مسبق', 'icon': Icons.credit_card},
    ];
    return Row(
      children: methods.map((m) {
        final label = m['label'] as String;
        final sel = _payMethod == label;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => setState(() => _payMethod = label),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: sel ? _kRed.withOpacity(0.15) : _kSurface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: sel ? _kRed : Colors.white12),
                ),
                child: Column(
                  children: [
                    Icon(m['icon'] as IconData, color: sel ? _kRed : Colors.grey, size: 24),
                    const SizedBox(height: 6),
                    Text(label, style: GoogleFonts.cairo(color: sel ? Colors.white : Colors.grey, fontSize: 12, fontWeight: sel ? FontWeight.w700 : FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _hero() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [_kRed.withOpacity(0.3), _kSurface], begin: Alignment.topRight, end: Alignment.bottomLeft),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: _kRed, shape: BoxShape.circle),
            child: Icon(widget.icon, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('اطلب ${widget.serviceType}', style: GoogleFonts.cairo(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('املأ البيانات وسيتواصل معك الكابتن قريباً', style: GoogleFonts.cairo(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(Map<String, dynamic> f) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(color: _kSurface, borderRadius: BorderRadius.circular(14)),
        child: TextField(
          controller: f['c'] as TextEditingController,
          textAlign: TextAlign.right,
          style: GoogleFonts.cairo(color: Colors.white),
          maxLines: f['label'].toString().contains('قائمة') ? 3 : 1,
          decoration: InputDecoration(
            hintText: f['label'] as String,
            hintStyle: GoogleFonts.cairo(color: Colors.grey, fontSize: 14),
            prefixIcon: Icon(f['icon'] as IconData, color: _kRed, size: 20),
            suffixIcon: (f['label'] as String).contains('من (')
                ? IconButton(
                    icon: const Icon(Icons.my_location, color: _kRed, size: 20),
                    onPressed: () {
                      (f['c'] as TextEditingController).text = 'موقعي الحالي';
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('تم تحديد موقعك', style: GoogleFonts.cairo(color: Colors.white)), backgroundColor: _kRed, duration: const Duration(seconds: 1)),
                      );
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    final sel = _option == label;
    return GestureDetector(
      onTap: () => setState(() => _option = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: sel ? _kRed : _kSurface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: sel ? _kRed : Colors.white12),
        ),
        child: Text(label, style: GoogleFonts.cairo(color: Colors.white, fontWeight: sel ? FontWeight.w700 : FontWeight.w500, fontSize: 13)),
      ),
    );
  }

  Widget _buildButton() {
    return GestureDetector(
      onTap: () => _showConfirmDialog(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: _kRed,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: _kRed.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6))],
        ),
        child: Center(child: Text('إرسال الطلب', style: GoogleFonts.cairo(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700))),
      ),
    );
  }
}
