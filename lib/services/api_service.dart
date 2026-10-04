import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  ApiService._();
  static final ApiService instance = ApiService._();

  static String get baseUrl {
    if (kIsWeb) return Uri.base.origin;
    return '';
  }

  static String? _authToken;
  static String? _deviceId;

  static void setToken(String? token) => _authToken = token;
  static void setDeviceId(String id) => _deviceId = id;
  static String? get deviceId => _deviceId;

  static Map<String, String> get _headers {
    final h = <String, String>{};
    if (_authToken != null) h['Authorization'] = 'Bearer $_authToken';
    if (_deviceId != null) h['x-device-id'] = _deviceId!;
    return h;
  }

  static Map<String, String> get _jsonHeaders {
    final h = _headers;
    h['Content-Type'] = 'application/json';
    return h;
  }

  static Future<bool> checkHealth() async {
    try {
      final r = await http
          .get(Uri.parse('$baseUrl/'))
          .timeout(const Duration(seconds: 10));
      debugPrint('✅ Health: ${r.statusCode}');
      return r.statusCode == 200;
    } catch (e) {
      debugPrint('❌ Health: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    String role = 'client',
  }) async {
    try {
      final r = await http
          .post(
            Uri.parse('$baseUrl/api/auth/register'),
            headers: _headers,
            body: jsonEncode({
              'name': name,
              'email': email,
              'phone': phone,
              'password': password,
              'role': role,
            }),
          )
          .timeout(const Duration(seconds: 15));
      debugPrint('📤 Register: ${r.body}');
      return jsonDecode(r.body);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final r = await http
          .post(
            Uri.parse('$baseUrl/api/auth/login'),
            headers: _headers,
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 15));
      debugPrint('📤 Login: ${r.body}');
      return jsonDecode(r.body);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> getSecurityStats() async {
    try {
      final r = await http
          .get(Uri.parse('$baseUrl/api/security/stats'), headers: _headers)
          .timeout(const Duration(seconds: 10));
      return jsonDecode(r.body);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> createOrder({
    required List<Map<String, dynamic>> items,
    required Map<String, dynamic> address,
    required String paymentMethod,
  }) async {
    try {
      final r = await http
          .post(
            Uri.parse('$baseUrl/api/shipping/package/create'),
            headers: _headers,
            body: jsonEncode({
              'clientId': '000000000000000000000000',
              'fromProvince': address['governorate'] ?? 'صنعاء',
              'toProvince': address['governorate'] ?? 'صنعاء',
              'recipientName': address['name'] ?? 'عميل',
              'recipientPhone': address['phone'] ?? '777000000',
              'recipientNationalId': '0000000000',
              'deliveryFee': 1500,
              'currency': 'yer_old',
            }),
          )
          .timeout(const Duration(seconds: 15));
      debugPrint('📤 Order: ${r.body}');
      return jsonDecode(r.body);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // ============= OTP =============
  static Future<Map<String, dynamic>> sendOtp(String phone) async {
    try {
      final r = await http
          .post(
            Uri.parse('$baseUrl/api/auth/otp'),
            headers: _headers,
            body: jsonEncode({'phone': phone}),
          )
          .timeout(const Duration(seconds: 15));
      debugPrint('📤 SendOTP: ${r.body}');
      return jsonDecode(r.body);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String code,
  }) async {
    try {
      final r = await http
          .post(
            Uri.parse('$baseUrl/api/auth/verify-otp'),
            headers: _headers,
            body: jsonEncode({'phone': phone, 'code': code}),
          )
          .timeout(const Duration(seconds: 15));
      debugPrint('📤 VerifyOTP: ${r.body}');
      return jsonDecode(r.body);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // ═══════════════ MERCHANT ═══════════════

  // طلبات المتجر
  static Future<List<dynamic>> getMerchantOrders() async {
    try {
      final r = await http
          .get(Uri.parse('$baseUrl/api/orders/merchant'), headers: _headers)
          .timeout(const Duration(seconds: 15));
      if (r.statusCode == 200) {
        return jsonDecode(r.body) as List<dynamic>;
      }
      return [];
    } catch (e) {
      debugPrint('❌ getMerchantOrders: $e');
      return [];
    }
  }

  // تحديث حالة طلب
  static Future<Map<String, dynamic>> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    try {
      final r = await http
          .patch(
            Uri.parse('$baseUrl/api/orders/$orderId/status'),
            headers: _headers,
            body: jsonEncode({'status': status}),
          )
          .timeout(const Duration(seconds: 15));
      return jsonDecode(r.body);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // تعيين مندوب
  static Future<Map<String, dynamic>> assignDriver({
    required String orderId,
    required String driverId,
  }) async {
    try {
      final r = await http
          .patch(
            Uri.parse('$baseUrl/api/orders/$orderId/assign-driver'),
            headers: _headers,
            body: jsonEncode({'driverId': driverId}),
          )
          .timeout(const Duration(seconds: 15));
      return jsonDecode(r.body);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // منتجات المتجر
  static Future<List<dynamic>> getMerchantProducts(String storeId) async {
    try {
      final r = await http
          .get(Uri.parse('$baseUrl/api/products/store/$storeId'), headers: _headers)
          .timeout(const Duration(seconds: 15));
      if (r.statusCode == 200) {
        return jsonDecode(r.body) as List<dynamic>;
      }
      return [];
    } catch (e) {
      debugPrint('❌ getMerchantProducts: $e');
      return [];
    }
  }


  // ═══════════════ FIREBASE LOGIN ═══════════════

  static Future<Map<String, dynamic>> firebaseLogin({
    required String email,
    required String uid,
    String? name,
    String? phone,
  }) async {
    try {
      final r = await http
          .post(
            Uri.parse('$baseUrl/api/auth/firebase-login'),
            headers: _headers,
            body: jsonEncode({
              'email': email,
              'uid': uid,
              'name': ?name,
              'phone': ?phone,
            }),
          )
          .timeout(const Duration(seconds: 15));
      final data = jsonDecode(r.body);
      if (r.statusCode == 200 && data['token'] != null) {
        _authToken = data['token'];
      }
      return data;
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // ═══════════════ DRIVER ═══════════════

  static Future<List<dynamic>> getDriverOrders() async {
    try {
      final r = await http
          .get(Uri.parse('$baseUrl/api/orders/driver'), headers: _headers)
          .timeout(const Duration(seconds: 15));
      if (r.statusCode == 200) {
        return jsonDecode(r.body) as List<dynamic>;
      }
      return [];
    } catch (e) {
      debugPrint('❌ getDriverOrders: $e');
      return [];
    }
  }

  static Future<List<dynamic>> getAvailableOrders() async {
    try {
      final r = await http
          .get(Uri.parse('$baseUrl/api/orders/recent'), headers: _headers)
          .timeout(const Duration(seconds: 15));
      if (r.statusCode == 200) {
        return jsonDecode(r.body) as List<dynamic>;
      }
      return [];
    } catch (e) {
      debugPrint('❌ getAvailableOrders: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> acceptOrder(String orderId) async {
    try {
      final r = await http
          .patch(
            Uri.parse('$baseUrl/api/orders/$orderId/accept'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 15));
      return jsonDecode(r.body);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> rejectOrder(String orderId) async {
    try {
      final r = await http
          .patch(Uri.parse('$baseUrl/api/orders/$orderId/reject'), headers: _headers)
          .timeout(const Duration(seconds: 15));
      return jsonDecode(r.body);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> updateTripStage({
    required String orderId,
    required String stage,
  }) async {
    try {
      final r = await http
          .patch(
            Uri.parse('$baseUrl/api/orders/$orderId/stage'),
            headers: _headers,
            body: jsonEncode({'stage': stage}),
          )
          .timeout(const Duration(seconds: 15));
      return jsonDecode(r.body);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // ═══════════════ ORDERS — EXTRA ═══════════════

  static Future<Map<String, dynamic>> cancelOrder(String orderId) async {
    try {
      final r = await http.patch(
        Uri.parse('$baseUrl/api/orders/$orderId/cancel'),
        headers: _headers,
      ).timeout(const Duration(seconds: 15));
      return jsonDecode(r.body);
    } catch (e) { return {'error': e.toString()}; }
  }

  static Future<Map<String, dynamic>> getOrderById(String orderId) async {
    try {
      final r = await http.get(
        Uri.parse('$baseUrl/api/orders/$orderId'),
        headers: _headers,
      ).timeout(const Duration(seconds: 15));
      return jsonDecode(r.body);
    } catch (e) { return {'error': e.toString()}; }
  }

  // ═══════════════ USERS — ADMIN ═══════════════

  static Future<List<dynamic>> listUsers({String? role, String? status}) async {
    try {
      var url = '$baseUrl/api/users';
      final params = <String>[];
      if (role != null) params.add('role=$role');
      if (status != null) params.add('status=$status');
      if (params.isNotEmpty) url += '?${params.join('&')}';
      final r = await http.get(Uri.parse(url), headers: _headers).timeout(const Duration(seconds: 15));
      if (r.statusCode == 200) return jsonDecode(r.body) as List<dynamic>;
      return [];
    } catch (e) { return []; }
  }

  static Future<Map<String, dynamic>> approveUser(String userId) async {
    try {
      final r = await http.patch(
        Uri.parse('$baseUrl/api/users/$userId/approve'),
        headers: _headers,
      ).timeout(const Duration(seconds: 15));
      return jsonDecode(r.body);
    } catch (e) { return {'error': e.toString()}; }
  }

  static Future<Map<String, dynamic>> rejectUser(String userId) async {
    try {
      final r = await http.patch(
        Uri.parse('$baseUrl/api/users/$userId/reject'),
        headers: _headers,
      ).timeout(const Duration(seconds: 15));
      return jsonDecode(r.body);
    } catch (e) { return {'error': e.toString()}; }
  }

  static Future<Map<String, dynamic>> changeUserRole({
    required String userId,
    required String role,
  }) async {
    try {
      final r = await http.patch(
        Uri.parse('$baseUrl/api/users/$userId/role'),
        headers: _headers,
        body: jsonEncode({'role': role}),
      ).timeout(const Duration(seconds: 15));
      return jsonDecode(r.body);
    } catch (e) { return {'error': e.toString()}; }
  }

  // ═══════════════ PRODUCTS — MERCHANT ═══════════════

  static Future<Map<String, dynamic>> addProduct({
    required String name,
    required num price,
    required String storeId,
    String? category,
    String? imageUrl,
  }) async {
    try {
      final r = await http.post(
        Uri.parse('$baseUrl/api/products'),
        headers: _headers,
        body: jsonEncode({
          'name': name,
          'price': price,
          'storeId': storeId,
          'category': category,
          'imageUrl': imageUrl,
        }),
      ).timeout(const Duration(seconds: 15));
      return jsonDecode(r.body);
    } catch (e) { return {'error': e.toString()}; }
  }

  static Future<Map<String, dynamic>> updateProduct({
    required String productId,
    Map<String, dynamic>? data,
  }) async {
    try {
      final r = await http.patch(
        Uri.parse('$baseUrl/api/products/$productId'),
        headers: _headers,
        body: jsonEncode(data ?? {}),
      ).timeout(const Duration(seconds: 15));
      return jsonDecode(r.body);
    } catch (e) { return {'error': e.toString()}; }
  }

  static Future<Map<String, dynamic>> deleteProduct(String productId) async {
    try {
      final r = await http.delete(
        Uri.parse('$baseUrl/api/products/$productId'),
        headers: _headers,
      ).timeout(const Duration(seconds: 15));
      return jsonDecode(r.body);
    } catch (e) { return {'error': e.toString()}; }
  }

  // ═══════════════ DRIVER EARNINGS ═══════════════

  static Future<Map<String, dynamic>> getDriverEarnings() async {
    try {
      final r = await http.get(
        Uri.parse('$baseUrl/api/driver/earnings'),
        headers: _headers,
      ).timeout(const Duration(seconds: 15));
      return jsonDecode(r.body);
    } catch (e) { return {'error': e.toString()}; }
  }

  // ═══════════════ PAYMENTS ═══════════════

  static Future<List<dynamic>> listPaymentMethods() async {
    try {
      final r = await http.get(Uri.parse('$baseUrl/api/payments/methods'), headers: _headers)
          .timeout(const Duration(seconds: 15));
      if (r.statusCode == 200) return jsonDecode(r.body) as List<dynamic>;
      return [];
    } catch (e) { return []; }
  }

  static Future<Map<String, dynamic>> addPaymentMethod(Map<String, dynamic> data) async {
    try {
      final r = await http.post(Uri.parse('$baseUrl/api/payments/methods'),
          headers: _jsonHeaders, body: jsonEncode(data))
          .timeout(const Duration(seconds: 15));
      return jsonDecode(r.body);
    } catch (e) { return {'error': e.toString()}; }
  }

  static Future<Map<String, dynamic>> updatePaymentMethod(String id, Map<String, dynamic> data) async {
    try {
      final r = await http.patch(Uri.parse('$baseUrl/api/payments/methods/$id'),
          headers: _jsonHeaders, body: jsonEncode(data))
          .timeout(const Duration(seconds: 15));
      return jsonDecode(r.body);
    } catch (e) { return {'error': e.toString()}; }
  }

  static Future<List<dynamic>> listTransactions({String? status, String? type}) async {
    try {
      var url = '$baseUrl/api/payments/transactions';
      final params = <String>[];
      if (status != null) params.add('status=$status');
      if (type != null) params.add('type=$type');
      if (params.isNotEmpty) url += '?${params.join('&')}';
      final r = await http.get(Uri.parse(url), headers: _headers)
          .timeout(const Duration(seconds: 15));
      if (r.statusCode == 200) return jsonDecode(r.body) as List<dynamic>;
      return [];
    } catch (e) { return []; }
  }

  static Future<Map<String, dynamic>> paymentStats() async {
    try {
      final r = await http.get(Uri.parse('$baseUrl/api/payments/stats'), headers: _headers)
          .timeout(const Duration(seconds: 15));
      return jsonDecode(r.body);
    } catch (e) { return {'error': e.toString()}; }
  }

  static Future<List<dynamic>> listAllWithdrawals({String? status}) async {
    try {
      var url = '$baseUrl/api/withdrawals/admin/all';
      if (status != null) url += '?status=$status';
      final r = await http.get(Uri.parse(url), headers: _headers)
          .timeout(const Duration(seconds: 15));
      if (r.statusCode == 200) return jsonDecode(r.body) as List<dynamic>;
      return [];
    } catch (e) { return []; }
  }

  static Future<Map<String, dynamic>> processWithdrawal(String id, Map<String, dynamic> data) async {
    try {
      final r = await http.patch(Uri.parse('$baseUrl/api/withdrawals/admin/$id/process'),
          headers: _jsonHeaders, body: jsonEncode(data))
          .timeout(const Duration(seconds: 15));
      return jsonDecode(r.body);
    } catch (e) { return {'error': e.toString()}; }
  }
}
