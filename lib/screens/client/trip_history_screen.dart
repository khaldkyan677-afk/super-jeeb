import 'package:flutter/material.dart';

class TripHistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> trips;
  const TripHistoryScreen({super.key, required this.trips});

  static const Color navy = Color(0xFF2B2D42);
  static const Color red = Color(0xFFEF233C);
  static const Color white = Color(0xFFFFFFFF);
  static const Color green = Color(0xFF25D366);
  static const Color yellow = Color(0xFFF0C107);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: navy,
        title: const Text('📜 سجل الرحلات', style: TextStyle(color: white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: white),
      ),
      body: trips.isEmpty ? _buildEmpty() : _buildList(context),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.history, size: 80, color: Colors.grey.shade300),
        const SizedBox(height: 15),
        const Text('لا توجد رحلات سابقة', style: TextStyle(fontWeight: FontWeight.bold, color: navy, fontSize: 16)),
        const SizedBox(height: 5),
        const Text('ستظهر رحلاتك هنا بعد إتمامها', style: TextStyle(color: Colors.grey, fontSize: 13)),
      ]),
    );
  }

  Widget _buildList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: trips.length,
      itemBuilder: (_, i) => _tripCard(context, trips[i]),
    );
  }

  Widget _tripCard(BuildContext context, Map<String, dynamic> trip) {
    final cancelled = trip['status'] == 'cancelled';
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () => _showInvoice(context, trip),
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: (cancelled ? red : green).withOpacity(0.15), shape: BoxShape.circle), child: Icon(cancelled ? Icons.cancel : Icons.check_circle, color: cancelled ? red : green, size: 20)),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('رحلة #${trip['id']}', style: const TextStyle(fontWeight: FontWeight.bold, color: navy, fontSize: 14)),
                Text('${trip['date']} • ${trip['time']}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ])),
              Text('${(trip['fare'] as double).toStringAsFixed(0)} YER', style: TextStyle(fontWeight: FontWeight.bold, color: cancelled ? Colors.grey : red, fontSize: 15)),
            ]),
            const SizedBox(height: 10),
            _row(Icons.radio_button_checked, green, trip['from'] ?? '--'),
            const SizedBox(height: 5),
            _row(Icons.location_on, red, trip['to'] ?? '--'),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.person, size: 14, color: Colors.grey),
              const SizedBox(width: 5),
              Text(trip['driver'] ?? '--', style: const TextStyle(fontSize: 12, color: navy)),
              const Spacer(),
              if (trip['rating'] != null)
                Row(children: List.generate(5, (i) => Icon(i < (trip['rating'] as int) ? Icons.star : Icons.star_border, color: yellow, size: 14))),
            ]),
          ]),
        ),
      ),
    );
  }

  Widget _row(IconData icon, Color color, String text) {
    return Row(children: [
      Icon(icon, color: color, size: 16),
      const SizedBox(width: 8),
      Expanded(child: Text(text, style: const TextStyle(fontSize: 12, color: navy), overflow: TextOverflow.ellipsis)),
    ]);
  }

  void _showInvoice(BuildContext context, Map<String, dynamic> trip) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(children: [const Icon(Icons.receipt_long, color: navy), const SizedBox(width: 8), Text('فاتورة #${trip['id']}')]),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            _invoiceRow('التاريخ', '${trip['date']} ${trip['time']}'),
            _invoiceRow('من', trip['from'] ?? '--'),
            _invoiceRow('إلى', trip['to'] ?? '--'),
            _invoiceRow('المسافة', '${((trip['distance'] as double?) ?? 0).toStringAsFixed(1)} كم'),
            _invoiceRow('النوع', trip['carType'] ?? '--'),
            const Divider(),
            _invoiceRow('سعر الفتح', '${((trip['baseFare'] as double?) ?? 0).toStringAsFixed(0)} YER'),
            _invoiceRow('تكلفة الكيلو', '${((trip['kmCost'] as double?) ?? 0).toStringAsFixed(0)} YER'),
            if (((trip['extras'] as double?) ?? 0) > 0) _invoiceRow('إضافات', '${(trip['extras'] as double).toStringAsFixed(0)} YER'),
            const Divider(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('الإجمالي', style: TextStyle(fontWeight: FontWeight.bold, color: navy, fontSize: 15)),
              Text('${(trip['fare'] as double).toStringAsFixed(0)} YER', style: const TextStyle(fontWeight: FontWeight.bold, color: red, fontSize: 16)),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              const Icon(Icons.payment, size: 14, color: Colors.grey),
              const SizedBox(width: 5),
              Text(trip['payment'] ?? 'كاش', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ]),
          ]),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إغلاق'))],
      ),
    );
  }

  Widget _invoiceRow(String label, String value) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 3), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      Flexible(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500, color: navy, fontSize: 12), textAlign: TextAlign.end)),
    ]));
  }
}
