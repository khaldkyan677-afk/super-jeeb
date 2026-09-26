import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../supermarket/store_detail_screen.dart';

const _kRed = Color(0xFFEF233C);
const _kBg = Color(0xFF0D0D12);
const _kSurface = Color(0xFF1A1B26);
const _kGold = Color(0xFFF0C107);

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  List<Map<String, dynamic>> _allStores = [];
  bool _loading = true;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _loadStores();
  }

  Future<void> _loadStores() async {
    try {
      final uri = Uri.base.resolve('/api/stores');
      final r = await http.get(uri);
      if (r.statusCode == 200) {
        final data = jsonDecode(r.body) as List;
        if (mounted) setState(() { _allStores = data.cast<Map<String, dynamic>>(); _loading = false; });
      } else {
        if (mounted) setState(() => _loading = false);
      }
    } catch (_) { if (mounted) setState(() => _loading = false); }
  }

  List<Map<String, dynamic>> get _results {
    if (_query.isEmpty) return [];
    final q = _query.toLowerCase();
    return _allStores.where((s) {
      final name = (s['name'] ?? '').toString().toLowerCase();
      final sub = (s['subCategory'] ?? '').toString().toLowerCase();
      final cat = (s['category'] ?? '').toString().toLowerCase();
      return name.contains(q) || sub.contains(q) || cat.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Container(
        decoration: BoxDecoration(
          color: _kSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _kRed.withOpacity(0.3), width: 1.5),
        ),
        child: TextField(
          controller: _controller,
          autofocus: false,
          onChanged: (v) => setState(() => _query = v),
          textAlign: TextAlign.right,
          style: GoogleFonts.cairo(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            hintText: 'ابحث عن متجر أو منتج...',
            hintStyle: GoogleFonts.cairo(color: Colors.grey, fontSize: 14),
            prefixIcon: const Icon(Icons.search, color: _kRed),
            suffixIcon: _query.isNotEmpty
                ? GestureDetector(
                    onTap: () { _controller.clear(); setState(() => _query = ''); },
                    child: const Icon(Icons.close, color: Colors.grey, size: 20),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: _kRed));
    }
    if (_query.isEmpty) return _buildEmpty();
    final results = _results;
    if (results.isEmpty) return _buildNoResults();
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _buildStoreCard(results[i]),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: _kSurface, shape: BoxShape.circle),
            child: const Icon(Icons.search, color: _kRed, size: 48),
          ),
          const SizedBox(height: 20),
          Text('ابحث عن متجر أو منتج', style: GoogleFonts.cairo(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text('اكتب اسم المتجر أو التصنيف', style: GoogleFonts.cairo(color: Colors.grey, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, color: Colors.grey, size: 56),
          const SizedBox(height: 12),
          Text('لا نتائج لـ "$_query"', style: GoogleFonts.cairo(color: Colors.white, fontSize: 15)),
        ],
      ),
    );
  }

  Widget _buildStoreCard(Map<String, dynamic> s) {
    final rating = (s['rating'] ?? 4.5).toString();
    final sub = (s['subCategory'] ?? s['category'] ?? '').toString();
    final loc = s['location'];
    final address = (loc is Map ? loc['address'] : null)?.toString() ?? '';
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StoreDetailScreen(store: s))),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _kSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _kRed.withOpacity(0.15)),
        ),
        child: Row(
          children: [
            Container(
              width: 60, height: 60,
              decoration: BoxDecoration(
                color: _kBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _kRed, width: 1.5),
              ),
              child: const Icon(Icons.storefront, color: _kRed, size: 26),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text((s['name'] ?? '').toString(), style: GoogleFonts.cairo(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: _kGold, size: 14),
                      const SizedBox(width: 4),
                      Text(rating, style: GoogleFonts.cairo(color: Colors.white, fontSize: 12)),
                      const SizedBox(width: 10),
                      Expanded(child: Text(address, style: GoogleFonts.cairo(color: Colors.grey, fontSize: 11), overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: _kRed.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                    child: Text(sub, style: GoogleFonts.cairo(color: _kRed, fontSize: 11, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }
}
