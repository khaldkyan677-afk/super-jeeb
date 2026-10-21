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

  Future<bool> addFavorite(String storeId) async {
    try {
      final token = ApiService.authToken;
      final r = await http.post(
        Uri.parse('${ApiService.baseUrl}/api/favorites/$storeId?t=${DateTime.now().millisecondsSinceEpoch}'),
        headers: { if (token != null) 'Authorization': 'Bearer $token' },
      );
      return r.statusCode == 200 || r.statusCode == 201;
    } catch (_) { return false; }
  }

  Future<bool> removeFavorite(String storeId) async {
    try {
      final token = ApiService.authToken;
      final r = await http.delete(
        Uri.parse('${ApiService.baseUrl}/api/favorites/$storeId?t=${DateTime.now().millisecondsSinceEpoch}'),
        headers: { if (token != null) 'Authorization': 'Bearer $token' },
      );
      return r.statusCode == 200;
    } catch (_) { return false; }
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final token = ApiService.authToken;
    final r = await http.get(
      Uri.parse('${ApiService.baseUrl}/api/favorites?t=${DateTime.now().millisecondsSinceEpoch}'),
      headers: { if (token != null) 'Authorization': 'Bearer $token' },
    );
    if (r.statusCode == 200) {
      final d = jsonDecode(r.body) as List;
      return d.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load favorites: ${r.statusCode}');
    }
  }
}
