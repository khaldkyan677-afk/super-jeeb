import 'package:flutter/material.dart';

class ServicesScreen extends StatefulWidget {
  final String serviceType; // 'fazaa' أو 'parcel'

  const ServicesScreen({super.key, required this.serviceType});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final _descCtrl = TextEditingController();
  final _fromCtrl = TextEditingController();
  final _toCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String _size = 'small';

  bool get isFazaa => widget.serviceType == 'fazaa';

  @override
  void dispose() {
    _descCtrl.dispose();
    _fromCtrl.dispose();
    _toCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2D42),
        title: Text(isFazaa ? 'فزعة' : 'طرود',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        leading: const BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: isFazaa ? _fazaaFields() : _parcelFields(),
        ),
      ),
    );
  }

  // ============================================================
  // فزعة: صندوق نصي كبير
  // ============================================================
  List<Widget> _fazaaFields() {
    return [
      _header(
        icon: Icons.support_agent,
        title: 'اطلب فزعتك',
        subtitle: 'اكتب تفاصيل طلبك بحرية وسنوصلها لك',
        color: const Color(0xFFEF233C),
      ),
      const SizedBox(height: 25),
      const Text('تفاصيل الطلب:',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2B2D42))),
      const SizedBox(height: 10),
      TextField(
        controller: _descCtrl,
        maxLines: 6,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: 'مثال: أحتاج شراء دواء من صيدلية النور، أو إحضار غرض معين من مكان محدد...',
          hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.all(15),
        ),
      ),
      const SizedBox(height: 20),
      _phoneField(),
      const SizedBox(height: 25),
      _submitButton('إرسال الطلب'),
    ];
  }

  // ============================================================
  // طرود: مكان + تسليم + حجم
  // ============================================================
  List<Widget> _parcelFields() {
    return [
      _header(
        icon: Icons.local_shipping,
        title: 'أرسل طردك',
        subtitle: 'حدد مكان الاستلام والتسليم وحجم الطرد',
        color: const Color(0xFF25D366),
      ),
      const SizedBox(height: 25),
      _iconField(_fromCtrl, Icons.my_location, 'مكان استلام الطرد',
          const Color(0xFF25D366)),
      const SizedBox(height: 12),
      _iconField(_toCtrl, Icons.location_on, 'مكان تسليم الطرد',
          const Color(0xFFEF233C)),
      const SizedBox(height: 25),
      const Text('حجم الطرد:',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2B2D42))),
      const SizedBox(height: 10),
      Row(
        children: [
          _sizeCard('small', 'صغير', Icons.inventory_2, 'سعر 1000'),
          const SizedBox(width: 8),
          _sizeCard('medium', 'متوسط', Icons.inventory, 'سعر 1800'),
          const SizedBox(width: 8),
          _sizeCard('large', 'كبير', Icons.local_shipping, 'سعر 3000'),
        ],
      ),
      const SizedBox(height: 20),
      _phoneField(),
      const SizedBox(height: 25),
      _submitButton('أرسل الطرد الآن'),
    ];
  }

  // ============================================================
  // مكونات مساعدة
  // ============================================================
  Widget _header({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconField(
      TextEditingController c, IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: c,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          icon: Icon(icon, color: color, size: 22),
          hintText: label,
          hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _phoneField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: _phoneCtrl,
        keyboardType: TextInputType.phone,
        style: const TextStyle(fontSize: 14),
        decoration: const InputDecoration(
          icon: Icon(Icons.phone, color: Color(0xFF2B2D42), size: 22),
          hintText: 'رقم هاتفك للتواصل',
          hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _sizeCard(
      String id, String label, IconData icon, String price) {
    final selected = _size == id;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _size = id),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF25D366).withOpacity(0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: selected
                    ? const Color(0xFF25D366)
                    : Colors.grey.shade300,
                width: selected ? 2 : 1),
          ),
          child: Column(
            children: [
              Icon(icon,
                  color: selected
                      ? const Color(0xFF25D366)
                      : const Color(0xFF2B2D42),
                  size: 28),
              const SizedBox(height: 6),
              Text(label,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 3),
              Text(price,
                  style: const TextStyle(
                      fontSize: 10, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _submitButton(String text) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: isFazaa
              ? const Color(0xFFEF233C)
              : const Color(0xFF25D366),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: () {
          if (isFazaa && _descCtrl.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('⚠️ اكتب تفاصيل طلبك')),
            );
            return;
          }
          if (!isFazaa && (_fromCtrl.text.isEmpty || _toCtrl.text.isEmpty)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('⚠️ أدخل مكان الاستلام والتسليم')),
            );
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isFazaa
                  ? '✅ تم إرسال طلبك'
                  : '📦 تم إرسال الطرد'),
              backgroundColor: const Color(0xFF25D366),
            ),
          );
        },
        icon: Icon(
            isFazaa ? Icons.send : Icons.local_shipping,
            color: Colors.white),
        label: Text(text,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
