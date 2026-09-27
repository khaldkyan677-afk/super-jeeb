import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'merchant_theme.dart';

class MerchantProductsScreen extends StatefulWidget {
  const MerchantProductsScreen({super.key});
  @override
  State<MerchantProductsScreen> createState() => _MerchantProductsScreenState();
}

class _MerchantProductsScreenState extends State<MerchantProductsScreen> {
  final _cats = ['الكل', 'فواكه', 'خضروات', 'عروض'];
  int _catIdx = 0;

  final _products = [
    _P('طماطم طازجة', '1,200', '1,500', 24, 'خضروات', true),
    _P('موز', '900', '0', 15, 'فواكه', true),
    _P('تفاح أحمر', '1,500', '1,800', 0, 'فواكه', false),
    _P('خيار', '800', '0', 40, 'خضروات', true),
    _P('برتقال', '1,100', '1,400', 8, 'فواكه', true),
    _P('جزر', '700', '0', 3, 'خضروات', true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MJ.bg,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(null),
        backgroundColor: MJ.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text('إضافة منتج', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.w800)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Text('المنتجات', style: MJ.h1),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: MJ.softPink, borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        Icon(Icons.search_rounded, color: MJ.primary, size: 16),
                        const SizedBox(width: 4),
                        Text('بحث', style: GoogleFonts.cairo(color: MJ.primary, fontSize: 12, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 38,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _cats.length,
                itemBuilder: (_, i) {
                  final sel = _catIdx == i;
                  return GestureDetector(
                    onTap: () => setState(() => _catIdx = i),
                    child: Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: sel ? MJ.primary : MJ.card,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: MJ.shadowSoft,
                      ),
                      child: Text(_cats[i], style: GoogleFonts.cairo(
                        color: sel ? Colors.white : MJ.text,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      )),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                itemCount: _products.length,
                separatorBuilder: (_, i) => const SizedBox(height: 10),
                itemBuilder: (_, i) => _productCard(_products[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productCard(_P p) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: MJ.card, borderRadius: BorderRadius.circular(18), boxShadow: MJ.shadowSoft),
      child: Row(
        children: [
          Container(
            width: 70, height: 70,
            decoration: BoxDecoration(color: MJ.softPink, borderRadius: BorderRadius.circular(14)),
            child: Icon(Icons.eco_rounded, color: MJ.primary, size: 36),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(p.name, style: MJ.body.copyWith(fontWeight: FontWeight.w800, fontSize: 13))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: p.available ? MJ.success.withValues(alpha: 0.15) : MJ.danger.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(p.available ? 'متوفر' : 'نفذ',
                        style: GoogleFonts.cairo(color: p.available ? MJ.success : MJ.danger, fontSize: 10, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(p.cat, style: MJ.tiny),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text('${p.price} ري', style: MJ.price),
                    if (p.oldPrice != '0') ...[
                      const SizedBox(width: 8),
                      Text('${p.oldPrice} ري', style: GoogleFonts.cairo(fontSize: 11, color: MJ.textMuted, decoration: TextDecoration.lineThrough)),
                    ],
                    const Spacer(),
                    Icon(Icons.inventory_2_rounded, color: MJ.textMuted, size: 14),
                    const SizedBox(width: 3),
                    Text('${p.stock}', style: MJ.tiny),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, color: MJ.textMuted),
            onSelected: (v) {
              if (v == 'edit') _openEditor(p);
              if (v == 'delete') _confirmDelete(p);
            },
            itemBuilder: (_) => [
              _menuItem('edit', Icons.edit_rounded, 'تعديل'),
              _menuItem('hide', Icons.visibility_off_rounded, 'إخفاء'),
              _menuItem('price', Icons.attach_money_rounded, 'تغيير السعر'),
              _menuItem('stock', Icons.inventory_rounded, 'إدارة المخزون'),
              _menuItem('delete', Icons.delete_rounded, 'حذف'),
            ],
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _menuItem(String v, IconData ic, String label) {
    return PopupMenuItem(
      value: v,
      child: Row(
        children: [
          Icon(ic, color: MJ.primary, size: 18),
          const SizedBox(width: 10),
          Text(label, style: GoogleFonts.cairo(fontSize: 13)),
        ],
      ),
    );
  }

  void _confirmDelete(_P p) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: MJ.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('حذف المنتج', style: MJ.h3),
        content: Text('هل تريد حذف "${p.name}"؟', style: MJ.body),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('إلغاء', style: GoogleFonts.cairo(color: MJ.textMuted))),
          TextButton(onPressed: () { Navigator.pop(context); }, child: Text('حذف', style: GoogleFonts.cairo(color: MJ.danger, fontWeight: FontWeight.w800))),
        ],
      ),
    );
  }

  void _openEditor(_P? p) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProductEditor(product: p),
    );
  }
}

class _ProductEditor extends StatefulWidget {
  final _P? product;
  const _ProductEditor({this.product});
  @override
  State<_ProductEditor> createState() => _ProductEditorState();
}

class _ProductEditorState extends State<_ProductEditor> {
  late TextEditingController _name, _desc, _price, _oldPrice, _stock;
  String _cat = 'فواكه';
  bool _available = true;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _name = TextEditingController(text: p?.name ?? '');
    _desc = TextEditingController();
    _price = TextEditingController(text: p?.price ?? '');
    _oldPrice = TextEditingController(text: p?.oldPrice == '0' ? '' : p?.oldPrice ?? '');
    _stock = TextEditingController(text: p?.stock.toString() ?? '');
    _cat = p?.cat ?? 'فواكه';
    _available = p?.available ?? true;
  }

  @override
  void dispose() {
    _name.dispose(); _desc.dispose(); _price.dispose(); _oldPrice.dispose(); _stock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNew = widget.product == null;
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      minChildSize: 0.6,
      builder: (_, scroll) => Container(
        decoration: const BoxDecoration(color: MJ.bg, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
        child: ListView(
          controller: scroll,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: MJ.border, borderRadius: BorderRadius.circular(4)))),
            const SizedBox(height: 16),
            Text(isNew ? 'إضافة منتج جديد' : 'تعديل المنتج', style: MJ.h2),
            const SizedBox(height: 18),

            _imagePicker(),
            const SizedBox(height: 16),

            _field('اسم المنتج', _name, Icons.label_rounded),
            const SizedBox(height: 10),
            _field('الوصف', _desc, Icons.description_rounded, maxLines: 3),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _field('السعر', _price, Icons.attach_money_rounded)),
                const SizedBox(width: 10),
                Expanded(child: _field('السعر بعد الخصم', _oldPrice, Icons.local_offer_rounded)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _field('المخزون', _stock, Icons.inventory_2_rounded)),
                const SizedBox(width: 10),
                Expanded(child: _dropdown()),
              ],
            ),
            const SizedBox(height: 14),
            _switchAvail(),
            const SizedBox(height: 20),

            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isNew ? 'تم نشر المنتج' : 'تم حفظ التعديلات', style: GoogleFonts.cairo()), backgroundColor: MJ.success),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MJ.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text(isNew ? 'نشر المنتج' : 'حفظ التعديلات', style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePicker() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 140,
        decoration: BoxDecoration(color: MJ.softPink, borderRadius: BorderRadius.circular(18), border: Border.all(color: MJ.primary.withValues(alpha: 0.2))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate_rounded, color: MJ.primary, size: 40),
            const SizedBox(height: 8),
            Text('إضافة صورة المنتج', style: GoogleFonts.cairo(color: MJ.primary, fontSize: 13, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget _field(String hint, TextEditingController c, IconData ic, {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(color: MJ.card, borderRadius: BorderRadius.circular(14), boxShadow: MJ.shadowSoft),
      child: TextField(
        controller: c,
        maxLines: maxLines,
        style: GoogleFonts.cairo(),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.cairo(color: MJ.textMuted),
          prefixIcon: Icon(ic, color: MJ.primary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _dropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(color: MJ.card, borderRadius: BorderRadius.circular(14), boxShadow: MJ.shadowSoft),
      child: DropdownButton<String>(
        value: _cat,
        isExpanded: true,
        underline: const SizedBox.shrink(),
        style: GoogleFonts.cairo(color: MJ.text),
        items: ['فواكه', 'خضروات', 'عروض'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
        onChanged: (v) => setState(() => _cat = v!),
      ),
    );
  }

  Widget _switchAvail() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(color: MJ.card, borderRadius: BorderRadius.circular(14), boxShadow: MJ.shadowSoft),
      child: Row(
        children: [
          Icon(_available ? Icons.check_circle_rounded : Icons.cancel_rounded, color: _available ? MJ.success : MJ.danger),
          const SizedBox(width: 10),
          Expanded(child: Text('متوفر للبيع', style: MJ.body.copyWith(fontWeight: FontWeight.w700))),
          Switch(value: _available, activeThumbColor: MJ.primary, onChanged: (v) => setState(() => _available = v)),
        ],
      ),
    );
  }
}

class _P {
  final String name, price, oldPrice, cat;
  final int stock;
  final bool available;
  _P(this.name, this.price, this.oldPrice, this.stock, this.cat, this.available);
}
