import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../services/api_service.dart';
import 'merchant_theme.dart';

class MerchantProductsScreen extends StatefulWidget {
  const MerchantProductsScreen({super.key});
  @override
  State<MerchantProductsScreen> createState() => _MerchantProductsScreenState();
}

class _MerchantProductsScreenState extends State<MerchantProductsScreen> {
  List<dynamic> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final r = await http.get(
        Uri.parse('${ApiService.baseUrl}/api/products/my'),
        headers: ApiService.get_headers,
      );
      if (r.statusCode == 200) {
        final d = jsonDecode(r.body);
        setState(() => _products = d is List ? d : []);
      }
    } catch (e) { debugPrint('LOAD_ERR: $e'); }
    setState(() => _loading = false);
  }

  Future<void> _delete(String id) async {
    try {
      await http.delete(
        Uri.parse('${ApiService.baseUrl}/api/products/$id'),
        headers: ApiService.get_headers,
      );
      _load();
    } catch (e) { debugPrint('DEL_ERR: $e'); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MJ.bg,
      appBar: AppBar(
        backgroundColor: MJ.bg,
        elevation: 0,
        title: Text('المنتجات', style: GoogleFonts.cairo(color: MJ.text, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(null),
        backgroundColor: MJ.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('إضافة منتج', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: _loading
        ? const Center(child: CircularProgressIndicator(color: MJ.primary))
        : _products.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text('لا توجد منتجات', style: GoogleFonts.cairo(color: MJ.textMuted, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('اضغط + لإضافة منتج', style: GoogleFonts.cairo(color: MJ.textMuted, fontSize: 13)),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: _products.length,
                itemBuilder: (_, i) => _card(_products[i]),
              ),
            ),
    );
  }

  Widget _card(dynamic p) {
    final m = p is Map ? p as Map<String, dynamic> : <String, dynamic>{};
    final name = (m['name'] ?? '').toString();
    final price = m['price'] ?? 0;
    final oldPrice = m['oldPrice'] ?? 0;
    final stock = m['stock'] ?? 0;
    final isAvail = m['isAvailable'] == true;
    final cat = (m['category'] ?? '').toString();
    final id = (m['_id'] ?? '').toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6)],
      ),
      child: Row(
        children: [
          Container(
            width: 55, height: 55,
            decoration: BoxDecoration(color: MJ.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.fastfood, color: MJ.primary, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.cairo(color: MJ.text, fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text('$price ر.ي', style: GoogleFonts.cairo(color: MJ.primary, fontSize: 13, fontWeight: FontWeight.bold)),
                    if (oldPrice is num && oldPrice > 0) ...[
                      const SizedBox(width: 6),
                      Text('$oldPrice', style: GoogleFonts.cairo(color: MJ.textMuted, fontSize: 11, decoration: TextDecoration.lineThrough)),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text('مخزون: $stock', style: GoogleFonts.cairo(color: MJ.textMuted, fontSize: 11)),
                    if (cat.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text('• $cat', style: GoogleFonts.cairo(color: MJ.textMuted, fontSize: 11)),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                onPressed: () => _openEditor(m),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                onPressed: () => _confirmDelete(id, name),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: isAvail ? Colors.green.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(isAvail ? 'متاح' : 'مخفي',
              style: GoogleFonts.cairo(color: isAvail ? Colors.green : Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(String id, String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('حذف "$name"؟', style: GoogleFonts.cairo()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('إلغاء', style: GoogleFonts.cairo())),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () { Navigator.pop(ctx); _delete(id); },
            child: Text('حذف', style: GoogleFonts.cairo(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _openEditor(Map<String, dynamic>? product) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => _ProductEditor(product: product, onSaved: _load),
    ));
  }
}

class _ProductEditor extends StatefulWidget {
  final Map<String, dynamic>? product;
  final VoidCallback onSaved;
  const _ProductEditor({this.product, required this.onSaved});
  @override
  State<_ProductEditor> createState() => _ProductEditorState();
}

class _ProductEditorState extends State<_ProductEditor> {
  late TextEditingController _name, _price, _oldPrice, _stock;
  bool _isAvailable = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _name = TextEditingController(text: p?['name']?.toString() ?? '');
    _price = TextEditingController(text: p?['price']?.toString() ?? '');
    _oldPrice = TextEditingController(text: (p?['oldPrice'] ?? 0).toString());
    _stock = TextEditingController(text: (p?['stock'] ?? 0).toString());
    _isAvailable = p?['isAvailable'] == true;
  }

  @override
  void dispose() {
    _name.dispose(); _price.dispose(); _oldPrice.dispose(); _stock.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty || _price.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('املأ الاسم والسعر', style: GoogleFonts.cairo(color: Colors.white)), backgroundColor: Colors.red),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final body = jsonEncode({
        'name': _name.text.trim(),
        'price': double.tryParse(_price.text) ?? 0,
        'oldPrice': double.tryParse(_oldPrice.text) ?? 0,
        'stock': int.tryParse(_stock.text) ?? 0,
        'isAvailable': _isAvailable,
      });
      http.Response r;
      if (widget.product == null) {
        r = await http.post(
          Uri.parse('${ApiService.baseUrl}/api/products'),
          headers: {...ApiService.get_headers, 'Content-Type': 'application/json'},
          body: body,
        );
      } else {
        r = await http.put(
          Uri.parse('${ApiService.baseUrl}/api/products/${widget.product!['_id']}'),
          headers: {...ApiService.get_headers, 'Content-Type': 'application/json'},
          body: body,
        );
      }
      if (mounted) {
        if (r.statusCode < 300) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم الحفظ بنجاح', style: GoogleFonts.cairo(color: Colors.white)), backgroundColor: Colors.green),
          );
          widget.onSaved();
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('فشل: ${r.statusCode}', style: GoogleFonts.cairo(color: Colors.white)), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e', style: GoogleFonts.cairo(color: Colors.white)), backgroundColor: Colors.red),
        );
      }
    }
    if (mounted) setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MJ.bg,
      appBar: AppBar(
        backgroundColor: MJ.bg,
        leading: const BackButton(color: Colors.white),
        title: Text(widget.product == null ? 'إضافة منتج' : 'تعديل منتج',
          style: GoogleFonts.cairo(color: MJ.text, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _field('اسم المنتج', _name, Icons.title),
            const SizedBox(height: 12),
            _field('السعر', _price, Icons.attach_money, number: true),
            const SizedBox(height: 12),
            _field('السعر القديم (اختياري)', _oldPrice, Icons.money_off, number: true),
            const SizedBox(height: 12),
            _field('المخزون', _stock, Icons.inventory, number: true),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text('متاح للبيع', style: GoogleFonts.cairo(color: MJ.text)),
              value: _isAvailable,
              activeThumbColor: MJ.primary,
              onChanged: (v) => setState(() => _isAvailable = v),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: MJ.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _saving ? null : _save,
                child: _saving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text('حفظ', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String hint, TextEditingController c, IconData ic, {bool number = false}) {
    return TextField(
      controller: c,
      keyboardType: number ? TextInputType.number : TextInputType.text,
      style: GoogleFonts.cairo(color: MJ.text),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.cairo(color: MJ.textMuted),
        prefixIcon: Icon(ic, color: MJ.primary),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }
}
