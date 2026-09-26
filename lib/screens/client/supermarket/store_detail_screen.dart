import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/product.dart';
import 'services/supermarket_service.dart';

const _kRed = Color(0xFFEF233C);
const _kBg = Color(0xFF0D0D12);
const _kSurface = Color(0xFF1A1B26);
const _kGold = Color(0xFFF0C107);

class StoreDetailScreen extends StatefulWidget {
  final Map<String, dynamic> store;
  const StoreDetailScreen({super.key, required this.store});

  @override
  State<StoreDetailScreen> createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  final _service = SupermarketService();
  List<Product> _products = [];
  bool _loading = true;
  String _query = '';
  int _selCat = 0;
  final List<String> _cats = ['الكل'];
  final Map<String, int> _cart = {};
  final Set<String> _favorites = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final storeId = widget.store['_id']?.toString() ?? '';
    final data = await _service.getProductsByStore(storeId);
    final products = data.map((j) => Product.fromJson(j)).toList();
    final catsSet = <String>{'الكل'};
    for (final p in products) {
      if (p.category.isNotEmpty) catsSet.add(p.category);
    }
    if (!mounted) return;
    setState(() {
      _products = products;
      _cats..clear()..addAll(catsSet);
      _loading = false;
    });
  }

  List<Product> get _visible {
    var list = _products;
    if (_selCat > 0 && _selCat < _cats.length) {
      final cat = _cats[_selCat];
      list = list.where((p) => p.category == cat).toList();
    }
    if (_query.isNotEmpty) {
      list = list.where((p) => p.name.contains(_query)).toList();
    }
    return list;
  }

  int get _cartCount => _cart.values.fold(0, (a, b) => a + b);
  double get _cartTotal {
    double t = 0;
    _cart.forEach((id, qty) {
      final match = _products.where((x) => x.id == id);
      if (match.isNotEmpty) t += match.first.price * qty;
    });
    return t;
  }

  void _addToCart(Product p) => setState(() => _cart[p.id] = (_cart[p.id] ?? 0) + 1);
  void _removeFromCart(Product p) {
    setState(() {
      final q = _cart[p.id] ?? 0;
      if (q <= 1) { _cart.remove(p.id); } else { _cart[p.id] = q - 1; }
    });
  }
  void _toggleFav(Product p) {
    setState(() {
      if (_favorites.contains(p.id)) { _favorites.remove(p.id); } else { _favorites.add(p.id); }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: _cartCount > 0 ? 100 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCover(),
                _buildStoreInfo(),
                _buildQuickInfo(),
                _buildSearchBar(),
                _buildCategoryChips(),
                _buildProductsGrid(),
              ],
            ),
          ),
          if (_cartCount > 0) _buildCartBar(),
        ],
      ),
    );
  }

  Widget _buildCover() {
    final coverUrl = (widget.store['coverUrl'] ?? '').toString();
    return Stack(
      children: [
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [_kRed.withOpacity(0.45), _kSurface],
            ),
          ),
          child: coverUrl.isNotEmpty
              ? Image.network(coverUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox())
              : null,
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, _kBg],
              ),
            ),
          ),
        ),
        Positioned(
          top: 40, left: 16, right: 16,
          child: Row(
            children: [
              _circleBtn(Icons.arrow_back, () => Navigator.pop(context)),
              const Spacer(),
              _circleBtn(Icons.share_outlined, () {}),
              const SizedBox(width: 8),
              _circleBtn(Icons.favorite_border, () {}),
            ],
          ),
        ),
      ],
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildStoreInfo() {
    final name = (widget.store['name'] ?? 'متجر').toString();
    final rating = (widget.store['rating'] ?? 4.5).toString();
    final loc = widget.store['location'];
    final address = (loc is Map ? loc['address'] : null)?.toString()
        ?? (widget.store['address'] ?? 'صنعاء').toString();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          Container(
            width: 70, height: 70,
            decoration: BoxDecoration(
              color: _kSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _kRed, width: 2),
            ),
            child: const Icon(Icons.storefront, color: _kRed, size: 32),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.cairo(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star, color: _kGold, size: 16),
                    const SizedBox(width: 4),
                    Text(rating, style: GoogleFonts.cairo(color: Colors.white, fontSize: 13)),
                    const SizedBox(width: 10),
                    const Icon(Icons.location_on, color: Colors.grey, size: 14),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(address, style: GoogleFonts.cairo(color: Colors.grey, fontSize: 12), overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _infoCard(Icons.access_time, '25-35 د', 'التوصيل'),
          const SizedBox(width: 8),
          _infoCard(Icons.delivery_dining, '500 ر.ي', 'الرسوم'),
          const SizedBox(width: 8),
          _infoCard(Icons.shopping_cart_outlined, '2000 ر.ي', 'الحد الأدنى'),
        ],
      ),
    );
  }

  Widget _infoCard(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: _kSurface, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Icon(icon, color: _kRed, size: 20),
            const SizedBox(height: 6),
            Text(value, style: GoogleFonts.cairo(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
            Text(label, style: GoogleFonts.cairo(color: Colors.grey, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Container(
        decoration: BoxDecoration(color: _kSurface, borderRadius: BorderRadius.circular(14)),
        child: TextField(
          onChanged: (v) => setState(() => _query = v),
          style: GoogleFonts.cairo(color: Colors.white),
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: 'ابحث في المتجر...',
            hintStyle: GoogleFonts.cairo(color: Colors.grey),
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _cats.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final active = i == _selCat;
          return GestureDetector(
            onTap: () => setState(() => _selCat = i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active ? _kRed : _kSurface,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Text(_cats[i], style: GoogleFonts.cairo(color: Colors.white, fontWeight: active ? FontWeight.w700 : FontWeight.w400, fontSize: 13)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductsGrid() {
    if (_loading) {
      return const Padding(padding: EdgeInsets.all(40), child: Center(child: CircularProgressIndicator(color: _kRed)));
    }
    final items = _visible;
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(40),
        child: Center(child: Text('لا توجد منتجات', style: GoogleFonts.cairo(color: Colors.grey))),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.72,
        ),
        itemCount: items.length,
        itemBuilder: (_, i) => _buildProductCard(items[i]),
      ),
    );
  }

  Widget _buildProductCard(Product p) {
    final qty = _cart[p.id] ?? 0;
    final isFav = _favorites.contains(p.id);
    return Container(
      decoration: BoxDecoration(color: _kSurface, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: p.imageUrl.isNotEmpty
                        ? Image.network(p.imageUrl, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.image, color: Colors.grey))
                        : const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
                Positioned(
                  top: 6, left: 6,
                  child: GestureDetector(
                    onTap: () => _toggleFav(p),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
                      child: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? _kRed : Colors.white, size: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.name, style: GoogleFonts.cairo(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text('${p.price.toStringAsFixed(0)} ر.ي', style: GoogleFonts.cairo(color: _kRed, fontSize: 14, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    if (qty == 0)
                      GestureDetector(
                        onTap: () => _addToCart(p),
                        child: Container(
                          width: 30, height: 30,
                          decoration: const BoxDecoration(color: _kRed, shape: BoxShape.circle),
                          child: const Icon(Icons.add, color: Colors.white, size: 18),
                        ),
                      )
                    else
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => _removeFromCart(p),
                            child: Container(
                              width: 26, height: 26,
                              decoration: BoxDecoration(color: _kSurface, shape: BoxShape.circle, border: Border.all(color: _kRed)),
                              child: const Icon(Icons.remove, color: _kRed, size: 14),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Text('$qty', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.w700)),
                          ),
                          GestureDetector(
                            onTap: () => _addToCart(p),
                            child: Container(
                              width: 26, height: 26,
                              decoration: const BoxDecoration(color: _kRed, shape: BoxShape.circle),
                              child: const Icon(Icons.add, color: Colors.white, size: 14),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartBar() {
    return Positioned(
      bottom: 16, left: 16, right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: _kRed,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: _kRed.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), borderRadius: BorderRadius.circular(10)),
              child: Text('$_cartCount', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 12),
            Text('عرض السلة', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
            const Spacer(),
            Text('${_cartTotal.toStringAsFixed(0)} ر.ي', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
