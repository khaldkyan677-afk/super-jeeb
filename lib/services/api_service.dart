import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  ApiService._();
  static final ApiService instance = ApiService._();

  static const String baseUrl =
      'https://5000-cs-9c3821e8-581e-43e4-85a2-54d427329293.cs-europe-west1-iuzs.cloudshell.dev';

  static String? _authToken;
  static String? _deviceId;

  static void setToken(String? token) => _authToken = token;
  static void setDeviceId(String id) => _deviceId = id;
  static String? get deviceId => _deviceId;

  static Map<String, String> get _headers {
    final h = <String, String>{'Content-Type': 'application/json'};
    if (_authToken != null) h['Authorization'] = 'Bearer $_authToken';
    if (_deviceId != null) h['x-device-id'] = _deviceId!;
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
}
