import 'package:flutter/material.dart';
import '../../services/camera_service.dart';

class MerchantProductsScreen extends StatefulWidget {
  const MerchantProductsScreen({super.key});

  @override
  State<MerchantProductsScreen> createState() =>
      _MerchantProductsScreenState();
}

class _MerchantProductsScreenState extends State<MerchantProductsScreen> {
  String _filter = 'الكل';
  final _filters = ['الكل', 'نشط', 'موقوف', 'نفذ'];

  final List<Map<String, dynamic>> _products = [
    {'name': 'قميص رجالي', 'price': 8000, 'stock': 50, 'status': 'active', 'icon': Icons.checkroom},
    {'name': 'بنطلون جينز', 'price': 12000, 'stock': 30, 'status': 'active', 'icon': Icons.checkroom},
    {'name': 'حزام جلد', 'price': 3500, 'stock': 5, 'status': 'active', 'icon': Icons.checkroom},
    {'name': 'جاكيت شتوي', 'price': 25000, 'stock': 0, 'status': 'out', 'icon': Icons.checkroom},
    {'name': 'ربطة عنق', 'price': 2000, 'stock': 100, 'status': 'inactive', 'icon': Icons.checkroom},
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_filter == 'الكل') return _products;
    if (_filter == 'نشط') {
      return _products.where((p) => p['status'] == 'active').toList();
    }
    if (_filter == 'موقوف') {
      return _products.where((p) => p['status'] == 'inactive').toList();
    }
    return _products.where((p) => p['status'] == 'out').toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1C2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2D42),
        title: const Text('إدارة المنتجات',
            style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold)),
        leading: const BackButton(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle,
                color: Color(0xFF25D366), size: 28),
            onPressed: () => _openEditor(context, null),
          ),
        ],
      ),
      body: Column(
        children: [
          _filterBar(),
          _statsBar(),
          Expanded(
            child: _filtered.isEmpty
                ? _emptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: _filtered.length,
                    itemBuilder: (context, i) =>
                        _productCard(_filtered[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _filterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      color: const Color(0xFF2B2D42).withValues(alpha: 0.5),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filters.map((f) {
            final sel = _filter == f;
            return Padding(
              padding: const EdgeInsets.only(left: 8),
              child: InkWell(
                onTap: () => setState(() => _filter = f),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: sel
                        ? const Color(0xFFEF233C)
                        : Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(f,
                      style: TextStyle(
                          color: sel ? Colors.white : Colors.white60,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _statsBar() {
    final total = _products.length;
    final active =
        _products.where((p) => p['status'] == 'active').length;
    final out = _products.where((p) => p['status'] == 'out').length;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      color: Colors.white.withValues(alpha: 0.02),
      child: Row(
        children: [
          _statItem(Icons.inventory, '$total', 'إجمالي',
              const Color(0xFFEF233C)),
          const SizedBox(width: 15),
          _statItem(Icons.check_circle, '$active', 'نشط',
              const Color(0xFF25D366)),
          const SizedBox(width: 15),
          _statItem(Icons.warning, '$out', 'نفذ', Colors.orange),
        ],
      ),
    );
  }

  Widget _statItem(IconData icon, String value, String label, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Text('$value $label',
            style: TextStyle(
                color: color, fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _emptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined,
              size: 80, color: Colors.white24),
          SizedBox(height: 15),
          Text('لا توجد منتجات',
              style: TextStyle(color: Colors.white54, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _productCard(Map<String, dynamic> p) {
    final stock = p['stock'] as int;
    final status = p['status'] as String;
    final lowStock = stock < 10 && stock > 0;
    final isOut = stock == 0;

    Color statusColor;
    String statusText;
    if (status == 'inactive') {
      statusColor = Colors.grey;
      statusText = 'موقوف';
    } else if (isOut) {
      statusColor = const Color(0xFFEF233C);
      statusText = 'نفذ';
    } else {
      statusColor = const Color(0xFF25D366);
      statusText = 'نشط';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(p['icon'] as IconData,
                color: Colors.white60, size: 32),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p['name'],
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text('${p['price']} YER',
                    style: const TextStyle(
                        color: Color(0xFFEF233C),
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.inventory_2,
                        color: lowStock
                            ? Colors.orange
                            : isOut
                                ? const Color(0xFFEF233C)
                                : Colors.white38,
                        size: 12),
                    const SizedBox(width: 4),
                    Text('$stock قطعة',
                        style: TextStyle(
                            color: lowStock
                                ? Colors.orange
                                : isOut
                                    ? const Color(0xFFEF233C)
                                    : Colors.white38,
                            fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(statusText,
                    style: TextStyle(
                        color: statusColor,
                        fontSize: 9,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 6),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert,
                    color: Colors.white54, size: 20),
                color: const Color(0xFF2B2D42),
                onSelected: (v) {
                  if (v == 'edit') {
                    _openEditor(context, p);
                  } else if (v == 'delete') {
                    _confirmDelete(p);
                  } else if (v == 'toggle') {
                    setState(() {
                      p['status'] = status == 'active'
                          ? 'inactive'
                          : 'active';
                    });
                  }
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit,
                            color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text('تعديل',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'toggle',
                    child: Row(
                      children: [
                        Icon(Icons.toggle_on,
                            color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text('تفعيل/إيقاف',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete,
                            color: Color(0xFFEF233C), size: 18),
                        SizedBox(width: 8),
                        Text('حذف',
                            style: TextStyle(
                                color: Color(0xFFEF233C))),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openEditor(BuildContext context, Map<String, dynamic>? product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductEditorScreen(product: product),
      ),
    );
  }

  void _confirmDelete(Map<String, dynamic> p) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF2B2D42),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text('حذف المنتج',
            style: TextStyle(color: Colors.white, fontSize: 15)),
        content: Text('هل تريد حذف "${p['name']}"؟',
            style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء',
                style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF233C)),
            onPressed: () {
              setState(() => _products.remove(p));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('🗑️ تم حذف المنتج'),
                    backgroundColor: Color(0xFFEF233C)),
              );
            },
            child: const Text('حذف',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class ProductEditorScreen extends StatefulWidget {
  final Map<String, dynamic>? product;
  const ProductEditorScreen({super.key, this.product});

  @override
  State<ProductEditorScreen> createState() => _ProductEditorScreenState();
}

class _ProductEditorScreenState extends State<ProductEditorScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _stockCtrl;
  String? _image;
  bool _available = true;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameCtrl = TextEditingController(text: p?['name'] ?? '');
    _priceCtrl =
        TextEditingController(text: p?['price']?.toString() ?? '');
    _stockCtrl =
        TextEditingController(text: p?['stock']?.toString() ?? '');
    _image = p?['image'];
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.product != null;
    return Scaffold(
      backgroundColor: const Color(0xFF1B1C2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2D42),
        title: Text(isEdit ? 'تعديل منتج' : 'منتج جديد',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold)),
        leading: const BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('صورة المنتج (بدون خلفية)',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: ImageUploadBox(
                label: _image == null
                    ? 'اضغط لإضافة صورة'
                    : 'تم رفع الصورة',
                icon: Icons.add_photo_alternate,
                activeColor: const Color(0xFF25D366),
                onUploaded: (url) {
                  setState(() => _image = url);
                  if (url != null) {
                    BackgroundRemover.showRemoveDialog(
                      context,
                      url,
                      (newUrl) => setState(() => _image = newUrl),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            _field(_nameCtrl, 'اسم المنتج', Icons.title),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _field(_priceCtrl, 'السعر', Icons.attach_money,
                      keyboard: TextInputType.number),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _field(
                      _stockCtrl, 'المخزون', Icons.inventory_2,
                      keyboard: TextInputType.number),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
              ),
              child: Row(
                children: [
                  Icon(
                    _available
                        ? Icons.check_circle
                        : Icons.cancel,
                    color: _available
                        ? const Color(0xFF25D366)
                        : const Color(0xFFEF233C),
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _available
                          ? 'المنتج متاح'
                          : 'المنتج غير متاح',
                      style: const TextStyle(
                          color: Colors.white, fontSize: 13),
                    ),
                  ),
                  Switch(
                    value: _available,
                    activeThumbColor: const Color(0xFF25D366),
                    onChanged: (v) => setState(() => _available = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () {
                  if (_nameCtrl.text.isEmpty ||
                      _priceCtrl.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('⚠️ املأ الحقول'),
                          backgroundColor: Color(0xFFEF233C)),
                    );
                    return;
                  }
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(isEdit
                            ? '✅ تم حفظ التعديلات'
                            : '✅ تم إضافة المنتج'),
                        backgroundColor: const Color(0xFF25D366)),
                  );
                },
                icon: const Icon(Icons.save, color: Colors.white),
                label: Text(isEdit ? 'حفظ التعديلات' : 'إضافة المنتج',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String label, IconData icon,
      {TextInputType? keyboard}) {
    return TextField(
      controller: c,
      keyboardType: keyboard,
      style: const TextStyle(color: Colors.white, fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54, fontSize: 12),
        prefixIcon:
            Icon(icon, color: const Color(0xFFEF233C), size: 20),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.03),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF233C)),
        ),
      ),
    );
  }
}
