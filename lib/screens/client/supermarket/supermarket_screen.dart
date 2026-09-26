import 'widgets/report_sheet.dart';
import 'widgets/rating_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/search_bar.dart';
import 'widgets/category_chips.dart';
import 'widgets/store_card.dart';
import 'store_detail_screen.dart';
import 'services/supermarket_service.dart';

class SupermarketScreen extends StatefulWidget {
  const SupermarketScreen({super.key});
  @override
  State<SupermarketScreen> createState() => _SupermarketScreenState();
}

class _SupermarketScreenState extends State<SupermarketScreen> {
  int _sel = 0;
  String _query = '';
  List<Map<String, dynamic>> _all = [];
  bool _loading = true;
  final Set<String> _favorites = {};
  final List<String> _cats = ['الكل', 'قريب منك', 'هايبر ماركت', 'سوبرماركت كبير'];

  @override
  void initState() { super.initState(); _load(); }

  void _toggleFavorite(String id) {
    setState(() {
      if (_favorites.contains(id)) { _favorites.remove(id); } else { _favorites.add(id); }
    });
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final s = await SupermarketService().getStoresByCategory('سوبرماركت');
    if (mounted) setState(() { _all = s; _loading = false; });
  }

  List<Map<String, dynamic>> get _filtered {
    var list = _all;
    if (_sel > 1) {
      final cat = _cats[_sel];
      list = list.where((s) => (s['subCategory'] ?? '') == cat).toList();
    }
    if (_query.isNotEmpty) {
      list = list.where((s) => (s['name'] ?? '').toString().contains(_query)).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D12),
      appBar: AppBar(backgroundColor: const Color(0xFF0D0D12), elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context)),
        title: Text('سوبرماركت', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.w600)),
        centerTitle: true),
      body: Column(children: [
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SmSearchBar(hint: 'ابحث عن سوبرماركت...', onChanged: (v) => setState(() => _query = v))),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: CategoryChips(categories: _cats, selectedIndex: _sel,
            onSelected: (i) => setState(() => _sel = i))),
        Expanded(child: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFEF233C)))
          : _filtered.isEmpty
            ? Center(child: Text('لا توجد نتائج', style: GoogleFonts.cairo(color: Colors.grey)))
            : ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _filtered.length,
                itemBuilder: (c, i) { final s = _filtered[i];
                  return StoreCard(storeId: s['_id'] ?? '', isNew: s['createdAt'] != null && (DateTime.now().difference(DateTime.parse(s['createdAt'])).inDays < 3), name: s['name'] ?? '', imageUrl: s['coverUrl'] ?? s['imageUrl'] ?? '',
                    isOpen: s['isActive'] ?? true, deliveryFee: (s['deliveryFee'] ?? 0).toDouble(), minimumOrder: (s['minimumOrder'] ?? 0).toDouble(),
                    location: (s['location'] is Map) ? (s['location']['address'] ?? '') : '',
                    rating: (s['rating'] ?? 5).toDouble(),
                    isFavorite: _favorites.contains(s['_id']), onFavorite: () => _toggleFavorite(s['_id']), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StoreDetailScreen(store: s))), onReport: () => showReportSheet(context, s['_id'] ?? '', s['name'] ?? ''), onRate: () => showRatingSheet(context, s['_id'] ?? '', s['name'] ?? '', () {})); })),
      ]));
  }
}
