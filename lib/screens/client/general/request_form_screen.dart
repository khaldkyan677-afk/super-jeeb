import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          const SizedBox(height: 20),
          Text('الخيارات', style: GoogleFonts.cairo(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: _options.map((o) => _buildChip(o)).toList(),
          ),
          const SizedBox(height: 30),
          _buildButton(),
          const SizedBox(height: 30),
        ],
      ),
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
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم إرسال طلب ${widget.serviceType} بنجاح', style: GoogleFonts.cairo(color: Colors.white)),
            backgroundColor: _kRed,
          ),
        );
      },
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
