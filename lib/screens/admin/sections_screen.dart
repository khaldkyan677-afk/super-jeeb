import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../services/api_service.dart';

class SectionsScreen extends StatefulWidget {
  const SectionsScreen({super.key});
  @override
  State<SectionsScreen> createState() => _SectionsScreenState();
}

class _SectionsScreenState extends State<SectionsScreen> {
  List<dynamic> _sections = [];
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
        Uri.parse('${ApiService.baseUrl}/api/sections/all'),
        headers: ApiService.get_headers,
      );
      if (r.statusCode == 200) {
        setState(() => _sections = jsonDecode(r.body));
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
        title: const Text('إدارة الأقسام', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF660F24),
        onPressed: () => _showDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _loading
        ? const Center(child: CircularProgressIndicator(color: Colors.white))
        : _sections.isEmpty
          ? const Center(child: Text('لا توجد أقسام', style: TextStyle(color: Colors.white70)))
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _sections.length,
                itemBuilder: (_, i) {
                  final s = _sections[i];
                  return Card(
                    color: const Color(0xFF3D0018),
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: const Icon(Icons.category, color: Colors.amber, size: 32),
                      title: Text(s['name'] ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: Text('order: ${s['order'] ?? 0} | active: ${s['isActive'] == true}',
                        style: const TextStyle(color: Colors.white54)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: const Icon(Icons.edit, color: Colors.lightBlueAccent),
                            onPressed: () => _showDialog(section: s)),
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

  void _showDialog({Map<String, dynamic>? section}) {
    final nameCtrl = TextEditingController(text: section?['name'] ?? '');
    final orderCtrl = TextEditingController(text: (section?['order'] ?? 0).toString());
    bool isActive = section?['isActive'] ?? true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          backgroundColor: const Color(0xFF3D0018),
          title: Text(section == null ? 'Add Section' : 'Edit Section',
            style: const TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: orderCtrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Order',
                  labelStyle: TextStyle(color: Colors.white70),
                ),
              ),
              SwitchListTile(
                title: const Text('Active', style: TextStyle(color: Colors.white)),
                value: isActive,
                activeThumbColor: Colors.amber,
                onChanged: (v) => setS(() => isActive = v),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF660F24)),
              onPressed: () async {
                final body = jsonEncode({
                  'name': nameCtrl.text.trim(),
                  'order': int.tryParse(orderCtrl.text) ?? 0,
                  'isActive': isActive,
                });
                try {
                  http.Response r;
                  if (section == null) {
                    r = await http.post(
                      Uri.parse('${ApiService.baseUrl}/api/sections'),
                      headers: _jsonH, body: body);
                  } else {
                    r = await http.put(
                      Uri.parse('${ApiService.baseUrl}/api/sections/${section['_id']}'),
                      headers: _jsonH, body: body);
                  }
                  if (r.statusCode < 300) {
                    if (ctx.mounted) Navigator.pop(ctx);
                    _load();
                  }
                } catch (e) { debugPrint('SAVE_ERR: $e'); }
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
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
        title: const Text('Confirm Delete', style: TextStyle(color: Colors.white)),
        content: Text('Delete "${s['name']}"?', style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                await http.delete(
                  Uri.parse('${ApiService.baseUrl}/api/sections/${s['_id']}'),
                  headers: ApiService.get_headers,
                );
                if (ctx.mounted) Navigator.pop(ctx);
                _load();
              } catch (e) { debugPrint('DEL_ERR: $e'); }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
