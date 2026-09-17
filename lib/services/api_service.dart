import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';

/// خدمة الاتصال بالسيرفر (server.js)
/// تعمل حالياً في الوضع التجريبي (Mock)
class ApiService {
  ApiService._();
  static final ApiService instance = ApiService._();

  // ---------- الإعدادات ----------
  // عند تشغيل server.js على Cloud Shell:
  // غيّر هذا الرابط إلى الرابط العام
  static const String baseUrl = 'https://5000-cs-9c3821e8-581e-43e4-85a2-54d427329293.cs-europe-west1-iuzs.cloudshell.dev';

  static bool _mockMode = true; // الوضع التجريبي
  static String? _authToken;

  // ---------- إعدادات ----------
  static void setToken(String? token) {
    _authToken = token;
  }

  static String? _deviceId;

  static void setDeviceId(String id) {
    _deviceId = id;
  }

  static String? get deviceId => _deviceId;

  static Map<String, String> get headers {
    final h = <String, String>{
      'Content-Type': 'application/json',
    };
    if (_authToken != null) h['Authorization'] = 'Bearer $_authToken';
    if (_deviceId != null) h['x-device-id'] = _deviceId!;
    return h;
  }

  static void setMockMode(bool value) {
    _mockMode = value;
  }

  static bool get isMockMode => _mockMode;

  // ---------- المحاكاة ----------
  static Future<Map<String, dynamic>> _simulate(
      Map<String, dynamic> response,
      {Duration delay = const Duration(milliseconds: 500)}) async {
    await Future.delayed(delay);
    return response;
  }

  // ---------- Health Check ----------
  static Future<bool> checkHealth() async {
    if (_mockMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      return true;
    }
    try {
      // عند التفعيل الحقيقي، سيكون هنا استدعاء http
      return true;
    } catch (e) {
      debugPrint('❌ Health check failed: $e');
      return false;
    }
  }

  // ============================================================
  // المصادقة
  // ============================================================
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    String role = 'client',
  }) async {
    if (_mockMode) {
      return _simulate({
        'status': 'success',
        'token': 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        'user': {
          'id': 1,
          'name': name,
          'email': email,
          'phone': phone,
          'role': role,
        },
      });
    }
    return {'error': 'not_implemented'};
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    if (_mockMode) {
      return _simulate({
        'status': 'success',
        'token': 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        'user': {
          'id': 1,
          'name': 'خالد',
          'email': email,
          'role': 'client',
        },
      });
    }
    return {'error': 'not_implemented'};
  }

  static Future<Map<String, dynamic>> sendOtp(String phone) async {
    if (_mockMode) {
      return _simulate({
        'status': 'success',
        'message': 'تم إرسال الرمز',
        'code': '123456', // للتجربة فقط
      });
    }
    return {'error': 'not_implemented'};
  }

  static Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String code,
  }) async {
    if (_mockMode) {
      return _simulate({
        'status': code == '123456' ? 'success' : 'error',
        'token': 'mock_token',
        'user': {
          'id': 1,
          'phone': phone,
          'role': 'client',
        },
      });
    }
    return {'error': 'not_implemented'};
  }

  // ============================================================
  // المنتجات
  // ============================================================
  static Future<List<Map<String, dynamic>>> getProducts({
    int? merchantId,
    String? category,
  }) async {
    if (_mockMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      return [
        {
          'id': 1,
          'name': 'قميص رجالي',
          'price': 8000,
          'merchant': 'متجر الأناقة',
          'stock': 50,
        },
        {
          'id': 2,
          'name': 'بنطلون جينز',
          'price': 12000,
          'merchant': 'متجر الأناقة',
          'stock': 30,
        },
        {
          'id': 3,
          'name': 'هاتف ذكي',
          'price': 150000,
          'merchant': 'متجر الإلكترونيات',
          'stock': 10,
        },
      ];
    }
    return [];
  }

  static Future<Map<String, dynamic>> getProductDetails(int id) async {
    if (_mockMode) {
      return _simulate({
        'id': id,
        'name': 'قميص رجالي',
        'price': 8000,
        'description': 'قميص قطن فاخر',
        'stock': 50,
      });
    }
    return {};
  }

  // ============================================================
  // المتاجر
  // ============================================================
  static Future<List<Map<String, dynamic>>> getMerchants({
    String? category,
    String? city,
  }) async {
    if (_mockMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      return [
        {
          'id': 1,
          'name': 'متجر الأناقة',
          'category': 'ملابس',
          'rating': 4.8,
          'city': 'صنعاء',
        },
        {
          'id': 2,
          'name': 'متجر الإلكترونيات',
          'category': 'إلكترونيات',
          'rating': 4.6,
          'city': 'صنعاء',
        },
      ];
    }
    return [];
  }

  // ============================================================
  // الطلبات
  // ============================================================
  static Future<Map<String, dynamic>> createOrder({
    required List<Map<String, dynamic>> items,
    required Map<String, dynamic> address,
    required String paymentMethod,
    String? notes,
    double? tip,
  }) async {
    if (_mockMode) {
      return _simulate({
        'status': 'success',
        'order_id': DateTime.now().millisecondsSinceEpoch % 10000,
        'total': 20000,
        'message': 'تم إنشاء الطلب بنجاح',
      });
    }
    return {'error': 'not_implemented'};
  }

  static Future<List<Map<String, dynamic>>> getOrders({
    String? status,
    int? limit,
  }) async {
    if (_mockMode) {
      await Future.delayed(const Duration(milliseconds: 400));
      return [
        {
          'id': '5021',
          'merchant': 'متجر الأناقة',
          'total': 20000,
          'status': 'in_progress',
          'date': 'اليوم 10:30 ص',
        },
        {
          'id': '5020',
          'merchant': 'متجر الإلكترونيات',
          'total': 150000,
          'status': 'delivered',
          'date': 'أمس',
        },
      ];
    }
    return [];
  }

  static Future<Map<String, dynamic>> getOrderDetails(String id) async {
    if (_mockMode) {
      return _simulate({
        'id': id,
        'status': 'in_progress',
        'items': [
          {'name': 'قميص رجالي', 'qty': 1, 'price': 8000},
          {'name': 'بنطلون جينز', 'qty': 1, 'price': 12000},
        ],
        'total': 20000,
        'otp': '4892',
      });
    }
    return {};
  }

  static Future<bool> cancelOrder(String id, {String? reason}) async {
    if (_mockMode) {
      await Future.delayed(const Duration(milliseconds: 400));
      return true;
    }
    return false;
  }

  // ============================================================
  // المحفظة
  // ============================================================
  static Future<Map<String, dynamic>> getWalletBalance() async {
    if (_mockMode) {
      return _simulate({
        'balance': 8500.0,
        'currency': 'YER',
        'points': 1250,
      });
    }
    return {};
  }

  static Future<List<Map<String, dynamic>>> getWalletTransactions() async {
    if (_mockMode) {
      await Future.delayed(const Duration(milliseconds: 400));
      return [
        {
          'type': 'in',
          'amount': 20000,
          'title': 'استرداد طلب ملغي',
          'date': 'اليوم',
        },
        {
          'type': 'out',
          'amount': -20000,
          'title': 'دفع طلب #5021',
          'date': 'أمس',
        },
        {
          'type': 'in',
          'amount': 50000,
          'title': 'شحن المحفظة',
          'date': 'منذ 3 أيام',
        },
      ];
    }
    return [];
  }

  static Future<Map<String, dynamic>> topupWallet({
    required double amount,
    required String method,
  }) async {
    if (_mockMode) {
      return _simulate({
        'status': 'success',
        'message': 'تم إرسال طلب الشحن',
      });
    }
    return {};
  }

  // ============================================================
  // التقييمات
  // ============================================================
  static Future<bool> submitReview({
    required int orderId,
    required int rating,
    String? comment,
  }) async {
    if (_mockMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      return true;
    }
    return false;
  }

  // ============================================================
  // الملاحة
  // ============================================================
  static Future<Map<String, dynamic>> updateLocation({
    required double lat,
    required double lng,
    required String role,
  }) async {
    if (_mockMode) {
      await Future.delayed(const Duration(milliseconds: 200));
      return {'status': 'success'};
    }
    return {};
  }

  // ============================================================
  // الإشعارات
  // ============================================================
  static Future<List<Map<String, dynamic>>> getNotifications() async {
    if (_mockMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      return [
        {
          'title': 'طلبك في الطريق',
          'body': 'الكابتن في طريقه إليك',
          'read': false,
          'time': 'منذ 5 دقائق',
        },
        {
          'title': 'خصم 20%',
          'body': 'على العطور',
          'read': true,
          'time': 'منذ ساعة',
        },
      ];
    }
    return [];
  }

  // ============================================================
  // البحث
  // ============================================================
  static Future<List<Map<String, dynamic>>> search(String query) async {
    if (_mockMode) {
      await Future.delayed(const Duration(milliseconds: 400));
      return [
        {'type': 'product', 'name': 'قميص رجالي', 'id': 1},
        {'type': 'merchant', 'name': 'متجر الأناقة', 'id': 1},
      ];
    }
    return [];
  }

  // ============================================================
  // الإحصائيات (للأدمن)
  // ============================================================
  static Future<Map<String, dynamic>> getDashboardStats() async {
    if (_mockMode) {
      return _simulate({
        'merchants': 142,
        'couriers': 385,
        'orders': 24,
        'sos': 3,
        'revenue': 1450000,
      });
    }
    return {};
  }

  // ============================================================
  // رفع الصور
  // ============================================================
  static Future<String?> uploadImage(String filePath) async {
    if (_mockMode) {
      await Future.delayed(const Duration(milliseconds: 800));
      return 'https://placeholder.superjeeb.com/image_${DateTime.now().millisecondsSinceEpoch}.jpg';
    }
    return null;
  }
}
