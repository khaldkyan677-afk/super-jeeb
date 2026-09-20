import 'package:flutter/material.dart';

class TransportScreen extends StatefulWidget {
  const TransportScreen({super.key});

  @override
  State<TransportScreen> createState() => _TransportScreenState();
}

class _TransportScreenState extends State<TransportScreen> {
  final _fromCtrl = TextEditingController();
  final _toCtrl = TextEditingController();
  String _selected = 'economy';

  final _carTypes = [
    {'id': 'economy', 'name': 'اقتصادي', 'price': 1500, 'icon': Icons.directions_car, 'eta': '5 دقائق'},
    {'id': 'comfort', 'name': 'مريح', 'price': 2500, 'icon': Icons.local_taxi, 'eta': '3 دقائق'},
    {'id': 'moto', 'name': 'دباب', 'price': 800, 'icon': Icons.two_wheeler, 'eta': '2 دقيقة'},
  ];

  @override
  void dispose() {
    _fromCtrl.dispose();
    _toCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2D42),
        title: const Text('تاكسي',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        leading: const BackButton(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(flex: 5, child: _buildMap()),
          Expanded(flex: 4, child: _buildBottom()),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return Stack(
      children: [
        Container(
          color: const Color(0xFFE8EDF2),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map, size: 80, color: Color(0xFF2B2D42)),
                SizedBox(height: 10),
                Text('📍 الخريطة الحية',
                    style: TextStyle(
                        fontSize: 14, color: Color(0xFF2B2D42))),
              ],
            ),
          ),
        ),
        Positioned(
          top: 15,
          left: 15,
          right: 15,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1), blurRadius: 10),
              ],
            ),
            child: Column(
              children: [
                _field(_fromCtrl, Icons.my_location, 'موقع الانطلاق',
                    const Color(0xFF25D366)),
                const Divider(height: 15),
                _field(_toCtrl, Icons.location_on, 'وجهة الوصول',
                    const Color(0xFFEF233C)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottom() {
    return Container(
      padding: const EdgeInsets.all(15),
      color: Colors.white,
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerRight,
            child: Text('اختر نوع السيارة:',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2B2D42))),
          ),
          const SizedBox(height: 12),
          ..._carTypes.map((c) => _carCard(c)),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF233C),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () {
                if (_fromCtrl.text.isEmpty || _toCtrl.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('⚠️ أدخل موقع الانطلاق والوجهة')),
                  );
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('🚕 جاري البحث عن كابتن...'),
                      backgroundColor: Color(0xFF25D366)),
                );
              },
              icon: const Icon(Icons.local_taxi, color: Colors.white),
              label: const Text('اطلب الكابتن الآن',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(TextEditingController c, IconData icon, String label,
      Color color) {
    return TextField(
      controller: c,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        icon: Icon(icon, color: color, size: 22),
        hintText: label,
        hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
        border: InputBorder.none,
      ),
    );
  }

  Widget _carCard(Map<String, dynamic> c) {
    final selected = _selected == c['id'];
    return InkWell(
      onTap: () => setState(() => _selected = c['id'] as String),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFEF233C).withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: selected
                  ? const Color(0xFFEF233C)
                  : Colors.grey.shade300,
              width: selected ? 2 : 1),
        ),
        child: Row(
          children: [
            Icon(c['icon'] as IconData,
                color: selected
                    ? const Color(0xFFEF233C)
                    : const Color(0xFF2B2D42),
                size: 30),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c['name'] as String,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold)),
                  Text('الوصول: ${c['eta']}',
                      style: const TextStyle(
                          fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
            Text('${c['price']} YER',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: selected
                        ? const Color(0xFFEF233C)
                        : const Color(0xFF2B2D42))),
          ],
        ),
      ),
    );
  }
}
