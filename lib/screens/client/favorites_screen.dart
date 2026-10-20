import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'supermarket/services/supermarket_service.dart';
import 'supermarket/store_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final _svc = SupermarketService();
  List<Map<String, dynamic>> _favorites = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final list = await _svc.getFavorites();
      if (mounted) setState(() { _favorites = list; _loading = false; });
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _remove(String storeId) async {
    await _svc.toggleFavorite(storeId);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2D42),
        leading: const BackButton(color: Colors.white),
        title: Row(
          children: [
            const Icon(Icons.favorite, color: Color(0xFFFFE233), size: 22),
            const SizedBox(width: 8),
            Text('المفضلة', style: GoogleFonts.cairo(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: const Color(0xFFFFE233), borderRadius: BorderRadius.circular(10)),
              child: Text('${_favorites.length}', style: GoogleFonts.cairo(color: Colors.black, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
      body: _loading
        ? const Center(child: CircularProgressIndicator())
        : _favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                  const SizedBox(height: 15),
                  Text('لا توجد متاجر في المفضلة', style: GoogleFonts.cairo(color: Colors.grey, fontSize: 14)),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: _favorites.length,
                itemBuilder: (_, i) => _card(_favorites[i]),
              ),
            ),
    );
  }

  Widget _card(Map<String, dynamic> s) {
    final store = s['storeId'] is Map ? s['storeId'] as Map<String, dynamic> : s;
    final name = (store['name'] ?? '').toString();
    final rating = (store['rating'] ?? 4.5).toString();
    final id = (store['_id'] ?? s['storeId'] ?? '').toString();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Container(
            width: 70, height: 70,
            decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.storefront, color: Color(0xFF2B2D42), size: 32),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.cairo(color: const Color(0xFF2B2D42), fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.star, color: Color(0xFFFFE233), size: 14),
                  const SizedBox(width: 4),
                  Text(rating, style: GoogleFonts.cairo(color: Colors.grey, fontSize: 12)),
                ]),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => _remove(id),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
            onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => StoreDetailScreen(store: store))),
          ),
        ],
      ),
    );
  }
}
