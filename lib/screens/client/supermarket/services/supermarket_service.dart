import 'dart:convert';
import 'package:http/http.dart' as http;

class SupermarketService {
  Future<List<Map<String, dynamic>>> getStoresByCategory(String category) async {
    try {
      final uri = Uri.base.resolve('/api/stores');
      final r = await http.get(uri);
      if (r.statusCode == 200) {
        final d = jsonDecode(r.body) as List;
        if (category.isEmpty) return d.cast<Map<String, dynamic>>();
        return d.where((s) => s['category'] == category).cast<Map<String, dynamic>>().toList();
      }
    } catch (_) {}
    return [];
  }

  Future<bool> toggleFavorite(String storeId) async {
    try {
      final uri = Uri.base.resolve('/api/favorites/$storeId');
      final r = await http.post(uri);
      return r.statusCode == 200 || r.statusCode == 201;
    } catch (_) { return false; }
  }
}
