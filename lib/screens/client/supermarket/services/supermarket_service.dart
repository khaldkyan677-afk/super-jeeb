import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../services/api_service.dart';

class SupermarketService {
  Future<List<Map<String, dynamic>>> getStoresByCategory(String category) async {
    try {
      final uri = Uri.parse('${ApiService.baseUrl}/api/stores');
      final r = await http.get(uri);
      if (r.statusCode == 200) {
        final d = jsonDecode(r.body) as List;
        if (category.isEmpty) return d.cast<Map<String, dynamic>>();
        return d.where((s) => s['category'] == category).cast<Map<String, dynamic>>().toList();
      }
    } catch (_) {}
    return [];
  }

  Future<List<Map<String, dynamic>>> getProductsByStore(String storeId) async {
    try {
      final uri = Uri.parse('${ApiService.baseUrl}/api/products/store/$storeId');
      final r = await http.get(uri);
      if (r.statusCode == 200) {
        final d = jsonDecode(r.body) as List;
        return d.cast<Map<String, dynamic>>();
      }
    } catch (_) {}
    return [];
  }

  Future<bool> toggleFavorite(String storeId) async {
    try {
      final token = ApiService.authToken;
      final r = await http.post(
        Uri.parse('${ApiService.baseUrl}/api/favorites/$storeId'),
        headers: { if (token != null) 'Authorization': 'Bearer $token' },
      );
      return r.statusCode == 200 || r.statusCode == 201;
    } catch (_) { return false; }
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    try {
      final token = ApiService.authToken;
      final r = await http.get(
        Uri.parse('${ApiService.baseUrl}/api/favorites'),
        headers: { if (token != null) 'Authorization': 'Bearer $token' },
      );
      if (r.statusCode == 200) {
        final d = jsonDecode(r.body) as List;
        return d.cast<Map<String, dynamic>>();
      }
    } catch (_) {}
    return [];
  }
}
