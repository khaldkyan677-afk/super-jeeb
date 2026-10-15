import 'package:google_fonts/google_fonts.dart';
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

  void _showDetails(Map<String, dynamic> m) {
    final user = m['merchantId'] ?? {};
    final isActive = m['isActive'] == true;
    final logo = m['logoUrl']?.toString() ?? '';
    final cover = m['coverUrl']?.toString() ?? '';
    final name = m['name']?.toString() ?? '';
    final desc = m['description']?.toString() ?? '';
    final cat = m['category']?.toString() ?? '';
    final sub = m['subCategory']?.toString() ?? '';
    final phone = m['phone']?.toString() ?? user['phone']?.toString() ?? '';
    final userPhone = user['phone']?.toString() ?? '';
    final userName = user['name']?.toString() ?? '';
    final addr = m['location']?['address']?.toString() ?? '';
    final mapUrl = m['mapUrl']?.toString() ?? '';
    final hours = m['workingHours']?.toString() ?? '';

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1B26),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.store, color: Color(0xFFEF7E3C), size: 26),
                const SizedBox(width: 10),
                Expanded(child: Text('تفاصيل المتجر', style: GoogleFonts.cairo(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
                IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
              ]),
              const SizedBox(height: 10),
              if (cover.isNotEmpty) ...[
                ClipRRect(borderRadius: BorderRadius.circular(12), child: _imgWidget(cover, 140)),
                const SizedBox(height: 14),
              ],
              if (logo.isNotEmpty) ...[
                Row(children: [
                  ClipRRect(borderRadius: BorderRadius.circular(50), child: _imgWidget(logo, 70, width: 70)),
                  const SizedBox(width: 12),
                  Expanded(child: Text(name, style: GoogleFonts.cairo(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
                ]),
                const SizedBox(height: 14),
              ] else ...[
                Text(name, style: GoogleFonts.cairo(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
              ],
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isActive ? Colors.green.withValues(alpha: 0.2) : Colors.orange.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isActive ? Colors.green : Colors.orange),
                ),
                child: Text(isActive ? 'مفعّل' : 'قيد المراجعة', style: GoogleFonts.cairo(color: isActive ? Colors.green : Colors.orange, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
              const SizedBox(height: 16),
              _detailRow('المالك', userName),
              _detailRow('هاتف المالك', userPhone),
              _detailRow('هاتف المتجر', phone),
              _detailRow('القسم', cat),
              _detailRow('التخصص', sub),
              _detailRow('الوصف', desc),
              _detailRow('العنوان', addr),
              _detailRow('ساعات العمل', hours),
              _detailRow('رابط الخريطة', mapUrl),
              const SizedBox(height: 20),
              if (!isActive) Row(children: [
                Expanded(child: ElevatedButton.icon(
                  onPressed: () { Navigator.pop(context); _verify(m['_id'], 'accept'); },
                  icon: const Icon(Icons.check_circle, color: Colors.white, size: 18),
                  label: Text('قبول', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 14)),
                )),
                const SizedBox(width: 10),
                Expanded(child: ElevatedButton.icon(
                  onPressed: () { Navigator.pop(context); _verify(m['_id'], 'reject'); },
                  icon: const Icon(Icons.cancel, color: Colors.white, size: 18),
                  label: Text('رفض', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, padding: const EdgeInsets.symmetric(vertical: 14)),
                )),
              ]),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _imgWidget(String url, double h, {double? width}) {
    if (url.startsWith('data:image')) {
      try {
        final parts = url.split(',');
        return Image.memory(base64Decode(parts[1]), height: h, width: width, fit: BoxFit.cover);
      } catch (_) { return Container(height: h, width: width, color: Colors.grey); }
    }
    return Image.network(url, height: h, width: width, fit: BoxFit.cover, errorBuilder: (_, _, _) => Container(height: h, width: width, color: Colors.grey));
  }

  Widget _detailRow(String label, String value) {
    if (value.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(width: 100, child: Text(label, style: GoogleFonts.cairo(color: Colors.grey, fontSize: 13))),
        Expanded(child: Text(value, style: GoogleFonts.cairo(color: Colors.white, fontSize: 13))),
      ]),
    );
  }

  Widget _card(Map<String, dynamic> m) {
    final user = m['merchantId'] ?? {};
    final isActive = m['isActive'] == true;
    Color color = isActive ? Colors.green : Colors.orange;
    final nameStr = user['name']?.toString() ?? m['name']?.toString() ?? '';
    final phoneStr = user['phone']?.toString() ?? m['phone']?.toString() ?? '';

    return GestureDetector(
      onTap: () => _showDetails(m),
      child: Card(
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
                Expanded(child: Text(m['name'] ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
                  child: Text(isActive ? 'مفعّل' : 'قيد المراجعة', style: const TextStyle(color: Colors.white, fontSize: 11)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text('القسم: ${m['category'] ?? ''}', style: const TextStyle(color: Colors.white70, fontSize: 13)),
            if (nameStr.isNotEmpty)
              Text('صاحب الطلب: $nameStr', style: const TextStyle(color: Colors.white70, fontSize: 13)),
            if (phoneStr.isNotEmpty)
              Text('الهاتف: $phoneStr', style: const TextStyle(color: Colors.white70, fontSize: 13)),
            if (!isActive) ...[
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
