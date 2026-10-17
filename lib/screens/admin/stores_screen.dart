import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../services/api_service.dart';

class StoresScreen extends StatefulWidget {
  const StoresScreen({super.key});
  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  List<dynamic> _stores = [];
  List<dynamic> _sections = [];
  bool _loading = true;

  Map<String, String> get _jsonH {
    final h = Map<String, String>.from(ApiService.getHeaders);
    h['Content-Type'] = 'application/json';
    return h;
  }

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() => _loading = true);
    await Future.wait([_loadStores(), _loadSections()]);
    setState(() => _loading = false);
  }

  Future<void> _loadStores() async {
    try {
      final r = await http.get(
        Uri.parse('${ApiService.baseUrl}/api/stores/all'),
        headers: ApiService.getHeaders,
      );
      if (r.statusCode == 200) {
        setState(() => _stores = jsonDecode(r.body));
      }
    } catch (e) { debugPrint('ERR: $e'); }
  }

  Future<void> _loadSections() async {
    try {
      final r = await http.get(
        Uri.parse('${ApiService.baseUrl}/api/sections/all'),
        headers: ApiService.getHeaders,
      );
      if (r.statusCode == 200) {
        setState(() => _sections = jsonDecode(r.body));
      }
    } catch (e) { debugPrint('ERR: $e'); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B0013),
      appBar: AppBar(
        backgroundColor: const Color(0xFF660F24),
        title: const Text('إدارة المتاجر', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF660F24),
        onPressed: () => _showDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _loading
        ? const Center(child: CircularProgressIndicator(color: Colors.white))
        : _stores.isEmpty
          ? const Center(child: Text('لا توجد متاجر', style: TextStyle(color: Colors.white70)))
          : RefreshIndicator(
              onRefresh: _loadAll,
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _stores.length,
                itemBuilder: (_, i) {
                  final s = _stores[i];
                  final secName = _sectionName(s['sectionId']);
                  return Card(
                    color: const Color(0xFF3D0018),
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: const Icon(Icons.store, color: Colors.amber, size: 32),
                      title: Text(s['name'] ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: Text('$secName • ${s['isActive'] == true ? "نشط" : "معطل"}',
                        style: const TextStyle(color: Colors.white54)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: const Icon(Icons.edit, color: Colors.lightBlueAccent),
                            onPressed: () => _showDialog(store: s)),
                          IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () => _confirmDelete(s)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  String _sectionName(String? id) {
    if (id == null) return 'بدون قسم';
    for (final sec in _sections) {
      if (sec['_id'] == id) return sec['name'] ?? '';
    }
    return 'بدون قسم';
  }

  void _showDialog({Map<String, dynamic>? store}) {
    final nameCtrl = TextEditingController(text: store?['name'] ?? '');
    final feeCtrl = TextEditingController(text: (store?['deliveryFee'] ?? 0).toString());
    final minCtrl = TextEditingController(text: (store?['minimumOrder'] ?? 0).toString());
    final addrCtrl = TextEditingController(text: store?['location']?['address'] ?? '');
    String? sectionId = store?['sectionId'];
    bool isActive = store?['isActive'] ?? true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          backgroundColor: const Color(0xFF3D0018),
          title: Text(store == null ? 'إضافة متجر' : 'تعديل متجر',
            style: const TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'اسم المتجر',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: sectionId,
                  dropdownColor: const Color(0xFF3D0018),
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'القسم',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                  items: _sections.map<DropdownMenuItem<String>>((sec) {
                    return DropdownMenuItem<String>(
                      value: sec['_id'] as String,
                      child: Text(sec['name'] ?? '', style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (v) => setS(() => sectionId = v),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: feeCtrl,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'قيمة التوصيل',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: minCtrl,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'أقل مبلغ للطلب',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: addrCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'العنوان',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 10),
                SwitchListTile(
                  title: const Text('نشط', style: TextStyle(color: Colors.white)),
                  value: isActive,
                  activeThumbColor: Colors.amber,
                  onChanged: (v) => setS(() => isActive = v),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF660F24)),
              onPressed: () async {
                final body = jsonEncode({
                  'name': nameCtrl.text.trim(),
                  'sectionId': sectionId,
                  'deliveryFee': double.tryParse(feeCtrl.text) ?? 0,
                  'minimumOrder': double.tryParse(minCtrl.text) ?? 0,
                  'location': {'address': addrCtrl.text.trim()},
                  'isActive': isActive,
                });
                try {
                  http.Response r;
                  if (store == null) {
                    r = await http.post(
                      Uri.parse('${ApiService.baseUrl}/api/stores'),
                      headers: _jsonH, body: body);
                  } else {
                    r = await http.put(
                      Uri.parse('${ApiService.baseUrl}/api/stores/${store['_id']}'),
                      headers: _jsonH, body: body);
                  }
                  if (r.statusCode < 300) {
                    if (ctx.mounted) Navigator.pop(ctx);
                    _loadStores();
                  }
                } catch (e) { debugPrint('SAVE_ERR: $e'); }
              },
              child: const Text('حفظ', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(Map<String, dynamic> s) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF3D0018),
        title: const Text('تأكيد الحذف', style: TextStyle(color: Colors.white)),
        content: Text('حذف المتجر "${s['name']}"؟', style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                await http.delete(
                  Uri.parse('${ApiService.baseUrl}/api/stores/${s['_id']}'),
                  headers: ApiService.getHeaders,
                );
                if (ctx.mounted) Navigator.pop(ctx);
                _loadStores();
              } catch (e) { debugPrint('DEL_ERR: $e'); }
            },
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
