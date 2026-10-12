import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../services/api_service.dart';

class PendingOrdersScreen extends StatefulWidget {
  const PendingOrdersScreen({super.key});
  @override
  State<PendingOrdersScreen> createState() => _PendingOrdersScreenState();
}

class _PendingOrdersScreenState extends State<PendingOrdersScreen> {
  List<dynamic> _orders = [];
  bool _loading = true;

  Map<String, String> get _jsonH {
    final h = Map<String, String>.from(ApiService.get_headers);
    h['Content-Type'] = 'application/json';
    return h;
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final r = await http.get(
        Uri.parse('${ApiService.baseUrl}/api/orders/all?verificationStatus=pending'),
        headers: ApiService.get_headers,
      );
      if (r.statusCode == 200) {
        setState(() => _orders = jsonDecode(r.body));
      }
    } catch (e) { debugPrint('ERR: $e'); }
    setState(() => _loading = false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B0013),
      appBar: AppBar(
        backgroundColor: const Color(0xFF660F24),
        title: const Text('الطلبات المعلقة', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _loading
        ? const Center(child: CircularProgressIndicator(color: Colors.white))
        : _orders.isEmpty
          ? const Center(child: Text('لا توجد طلبات معلقة', style: TextStyle(color: Colors.white70)))
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _orders.length,
                itemBuilder: (_, i) => _orderCard(_orders[i]),
              ),
            ),
    );
  }

  Widget _orderCard(Map<String, dynamic> o) {
    final storeName = o['storeId']?['name'] ?? 'متجر';
    final customer = o['customerId']?['name'] ?? 'عميل';
    final phone = o['customerId']?['phone'] ?? '';
    final total = o['total'] ?? 0;
    final address = o['address'] ?? '';
    final notes = o['notes'] ?? '';
    final method = o['paymentMethod'] ?? 'cash';
    final createdAt = o['createdAt'] ?? '';
    final hasReceipt = (o['receiptImage'] ?? '').toString().isNotEmpty;
    final items = (o['items'] as List?) ?? [];

    return Card(
      color: const Color(0xFF3D0018),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.store, color: Colors.amber),
                const SizedBox(width: 8),
                Expanded(child: Text(storeName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                Text('$total ر.ي', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(color: Colors.white24, height: 16),
            Text('العميل: $customer${phone.isNotEmpty ? " • $phone" : ""}',
              style: const TextStyle(color: Colors.white70, fontSize: 13)),
            if (address.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text('العنوان: $address', style: const TextStyle(color: Colors.white70, fontSize: 13)),
            ],
            const SizedBox(height: 4),
            Text('الدفع: $method', style: const TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 4),
            Text('التاريخ: $createdAt', style: const TextStyle(color: Colors.white54, fontSize: 11)),
            if (items.isNotEmpty) ...[
              const SizedBox(height: 10),
              const Text('المنتجات:', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 4),
              ...items.map((it) => Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Row(
                  children: [
                    Expanded(child: Text('• ${it['name'] ?? ''}',
                      style: const TextStyle(color: Colors.white, fontSize: 12))),
                    Text('x${it['quantity'] ?? 1}',
                      style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    const SizedBox(width: 8),
                    Text('${it['price'] ?? 0}',
                      style: const TextStyle(color: Colors.amber, fontSize: 12)),
                  ],
                ),
              )),
            ],
            if (notes.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('ملاحظات: $notes',
                style: const TextStyle(color: Colors.white60, fontSize: 12, fontStyle: FontStyle.italic)),
            ],
            const SizedBox(height: 10),
            if (hasReceipt)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  base64Decode(o['receiptImage']),
                  height: 180, fit: BoxFit.contain,
                  errorBuilder: (_, e, st) => const Text('صورة غير صالحة', style: TextStyle(color: Colors.red)),
                ),
              ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () => _verify(o['_id'], 'accept'),
                    icon: const Icon(Icons.check, color: Colors.white, size: 18),
                    label: const Text('قبول', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () => _reject(o['_id']),
                    icon: const Icon(Icons.close, color: Colors.white, size: 18),
                    label: const Text('رفض', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _verify(String id, String action) async {
    try {
      final r = await http.put(
        Uri.parse('${ApiService.baseUrl}/api/orders/$id/verify'),
        headers: _jsonH,
        body: jsonEncode({'action': action}),
      );
      if (r.statusCode == 200) _load();
    } catch (e) { debugPrint('VERIFY_ERR: $e'); }
  }

  Future<void> _reject(String id) async {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF3D0018),
        title: const Text('سبب الرفض', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: ctrl,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'اكتب السبب...',
            hintStyle: TextStyle(color: Colors.white54),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                await http.put(
                  Uri.parse('${ApiService.baseUrl}/api/orders/$id/verify'),
                  headers: _jsonH,
                  body: jsonEncode({'action': 'reject', 'reason': ctrl.text.trim()}),
                );
                if (ctx.mounted) Navigator.pop(ctx);
                _load();
              } catch (e) { debugPrint('REJ_ERR: $e'); }
            },
            child: const Text('رفض', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
