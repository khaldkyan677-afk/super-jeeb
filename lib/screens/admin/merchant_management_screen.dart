import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../services/api_service.dart';

class MerchantManagementScreen extends StatefulWidget {
  const MerchantManagementScreen({super.key});
  @override
  State<MerchantManagementScreen> createState() => _MerchantManagementScreenState();
}

class _MerchantManagementScreenState extends State<MerchantManagementScreen> {
  List<dynamic> _list = [];
  bool _loading = true;
  int _filter = 0;

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
      String url = '${ApiService.baseUrl}/api/merchants/all';
      if (_filter != 3) {
        final st = ['pending', 'verified', 'rejected'][_filter];
        url += '?verificationStatus=$st';
      }
      final r = await http.get(Uri.parse(url), headers: ApiService.get_headers);
      if (r.statusCode == 200) {
        setState(() => _list = jsonDecode(r.body));
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
        title: const Text('طلبات التجار', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFF660F24).withValues(alpha: 0.3),
            child: Row(
              children: [
                _tab(0, 'معلق'),
                const SizedBox(width: 8),
                _tab(1, 'مقبول'),
                const SizedBox(width: 8),
                _tab(2, 'مرفوض'),
                const SizedBox(width: 8),
                _tab(3, 'الكل'),
              ],
            ),
          ),
          Expanded(
            child: _loading
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : _list.isEmpty
                ? const Center(child: Text('لا توجد طلبات', style: TextStyle(color: Colors.white70)))
                : RefreshIndicator(
                    onRefresh: _load,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: _list.length,
                      itemBuilder: (_, i) => _card(_list[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _tab(int idx, String label) {
    final sel = _filter == idx;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() => _filter = idx);
          _load();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: sel ? const Color(0xFFFFE233) : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(label, textAlign: TextAlign.center,
            style: TextStyle(color: sel ? Colors.white : Colors.white60, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _card(Map<String, dynamic> m) {
    final user = m['userId'] ?? {};
    final verif = m['verificationStatus'] ?? 'pending';
    Color color;
    if (verif == 'verified') {
      color = Colors.green;
    } else if (verif == 'rejected') {
      color = Colors.red;
    } else {
      color = Colors.orange;
    }
    final nameStr = user['name']?.toString() ?? '';
    final phoneStr = user['phone']?.toString() ?? '';

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
                Expanded(child: Text(m['storeName'] ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
                  child: Text(verif, style: const TextStyle(color: Colors.white, fontSize: 11)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text('القسم: ${m['category'] ?? ''}', style: const TextStyle(color: Colors.white70, fontSize: 13)),
            if (nameStr.isNotEmpty)
              Text('صاحب الطلب: $nameStr', style: const TextStyle(color: Colors.white70, fontSize: 13)),
            if (phoneStr.isNotEmpty)
              Text('الهاتف: $phoneStr', style: const TextStyle(color: Colors.white70, fontSize: 13)),
            if (verif == 'pending') ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () => _verify(m['_id'], 'accept'),
                    icon: const Icon(Icons.check, color: Colors.white, size: 18),
                    label: const Text('قبول', style: TextStyle(color: Colors.white)),
                  )),
                  const SizedBox(width: 8),
                  Expanded(child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () => _verify(m['_id'], 'reject'),
                    icon: const Icon(Icons.close, color: Colors.white, size: 18),
                    label: const Text('رفض', style: TextStyle(color: Colors.white)),
                  )),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _verify(String id, String action) async {
    try {
      final r = await http.patch(
        Uri.parse('${ApiService.baseUrl}/api/merchants/$id/verify'),
        headers: _jsonH,
        body: jsonEncode({'action': action}),
      );
      if (r.statusCode == 200) {
        _load();
      }
    } catch (e) { debugPrint('VERIFY_ERR: $e'); }
  }
}
