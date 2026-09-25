import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../supermarket/services/supermarket_service.dart';
import '../supermarket/widgets/store_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';
  List<Map<String, dynamic>> _all = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final s = await SupermarketService().getStoresByCategory('');
    if (mounted) setState(() { _all = s; _loading = false; });
  }

  List<Map<String, dynamic>> get _results => _query.isEmpty ? []
    : _all.where((s) => (s['name'] ?? '').toString().contains(_query)).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D12),
      appBar: AppBar(backgroundColor: const Color(0xFF0D0D12), elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context)),
        title: Text('البحث', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.w600)),
        centerTitle: true),
      body: Column(children: [
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            onChanged: (v) => setState(() => _query = v),
            textAlign: TextAlign.right, autofocus: true,
            style: GoogleFonts.cairo(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'ابحث عن متجر أو مطعم...',
              hintStyle: GoogleFonts.cairo(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true, fillColor: const Color(0xFF1A1B26),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none)))),
        Expanded(child: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFEF233C)))
          : _query.isEmpty
            ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.search, size: 60, color: Colors.grey.shade800),
                const SizedBox(height: 12),
                Text('ابحث عن متجر أو مطعم', style: GoogleFonts.cairo(color: Colors.grey))]))
            : _results.isEmpty
              ? Center(child: Text('لا توجد نتائج', style: GoogleFonts.cairo(color: Colors.grey)))
              : ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: _results.length,
                  itemBuilder: (c, i) { final s = _results[i];
                    return StoreCard(name: s['name'] ?? '',
                      imageUrl: s['coverUrl'] ?? s['imageUrl'] ?? '',
                      isOpen: s['isActive'] ?? true,
                      location: (s['location'] is Map) ? (s['location']['address'] ?? '') : '',
                      rating: (s['rating'] ?? 5).toDouble(),
                      deliveryFee: (s['deliveryFee'] ?? 0).toDouble(),
                      minimumOrder: (s['minimumOrder'] ?? 0).toDouble(),
                      onTap: () {}, onReport: () {}, onRate: () {}, onFavorite: () {}); })),
      ]));
  }
}
