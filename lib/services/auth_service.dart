import 'package:flutter/foundation.dart';

import 'api_service.dart';

/// خدمة المصادقة - تدير تسجيل الدخول والخروج والأدوار
class AuthService extends ChangeNotifier {
  AuthService._();
  static final AuthService instance = AuthService._();

  // ---------- الحالة ----------
  Map<String, dynamic>? _currentUser;
  String? _token;
  bool _loading = false;
  String? _error;

  // ---------- Getters ----------
  Map<String, dynamic>? get currentUser => _currentUser;
  String? get token => _token;
  bool get loading => _loading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;

  String get userRole => _currentUser?['role'] ?? 'guest';
  String getUserName() => _currentUser?['name'] ?? 'زائر';
  String getUserEmail() => _currentUser?['email'] ?? '';
  String getUserPhone() => _currentUser?['phone'] ?? '';
  int get userId => _currentUser?['id'] ?? 0;

  // ============================================================
  // تسجيل الدخول بـ Google
  // ============================================================
  Future<bool> signInWithGoogle() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      // محاكاة تسجيل Google
      await Future.delayed(const Duration(seconds: 1));

      // عند التفعيل الحقيقي: استخدم google_sign_in + firebase_auth
      final result = await ApiService.login(
        email: 'user@gmail.com',
        password: 'google_token',
      );

      if (result['status'] == 'success') {
        _currentUser = result['user'];
        _token = result['token'];
        ApiService.setToken(_token);
        _loading = false;
        notifyListeners();
        return true;
      } else {
        _error = result['error'] ?? 'فشل تسجيل الدخول';
        _loading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'حدث خطأ: $e';
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  // ============================================================
  // إرسال OTP
  // ============================================================
  Future<bool> sendOtp(String phone) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await ApiService.sendOtp(phone);
      _loading = false;
      notifyListeners();

      if (result['status'] == 'success') {
        return true;
      } else {
        _error = result['error'] ?? 'فشل إرسال الرمز';
        return false;
      }
    } catch (e) {
      _error = 'حدث خطأ: $e';
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  // ============================================================
  // التحقق من OTP وتسجيل الدخول
  // ============================================================
  Future<bool> verifyOtp(String phone, String code) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await ApiService.verifyOtp(phone: phone, code: code);
      _loading = false;

      if (result['status'] == 'success') {
        _currentUser = result['user'];
        _token = result['token'];
        ApiService.setToken(_token);
        notifyListeners();
        return true;
      } else {
        _error = 'الرمز غير صحيح';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'حدث خطأ: $e';
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  // ============================================================
  // تسجيل مستخدم جديد
  // ============================================================
  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await ApiService.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );
      _loading = false;

      if (result['status'] == 'success') {
        _currentUser = result['user'];
        _token = result['token'];
        ApiService.setToken(_token);
        notifyListeners();
        return true;
      } else {
        _error = result['error'] ?? 'فشل التسجيل';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'حدث خطأ: $e';
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  // ============================================================
  // تسجيل الدخول كأدمن (بالبريدين + كلمة السر)
  // ============================================================
  Future<bool> signInAsAdmin({
    required String email1,
    required String email2,
    required String password,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      const adminEmail1 = 'khaled20010405@gmail.com';
      const adminEmail2 = 'khaldkyan677@gmail.com';
      const adminPass = 'SJ2026KHALED';

      final e1 = email1.trim().toLowerCase();
      final e2 = email2.trim().toLowerCase();
      final validEmail =
          (e1 == adminEmail1 && e2 == adminEmail2) ||
          (e1 == adminEmail2 && e2 == adminEmail1);

      if (validEmail && password == adminPass) {
        _currentUser = {
          'id': 0,
          'name': 'المالك العام',
          'email': adminEmail1,
          'role': 'super_admin',
        };
        _token = 'admin_token_${DateTime.now().millisecondsSinceEpoch}';
        _loading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'البيانات غير صحيحة';
        _loading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'حدث خطأ: $e';
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  // ============================================================
  // ترقية الدور (تاجر / مندوب)
  // ============================================================
  Future<bool> requestRoleUpgrade(String newRole) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      // في التطبيق الحقيقي: إرسال طلب للأدمن
      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'فشل الإرسال';
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  // ============================================================
  // تحديث الدور بعد الموافقة
  // ============================================================
  void updateRole(String newRole) {
    if (_currentUser != null) {
      _currentUser!['role'] = newRole;
      notifyListeners();
    }
  }

  // ============================================================
  // تحديث الملف الشخصي
  // ============================================================
  Future<bool> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? bio,
  }) async {
    _loading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      if (_currentUser != null) {
        if (name != null) _currentUser!['name'] = name;
        if (email != null) _currentUser!['email'] = email;
        if (phone != null) _currentUser!['phone'] = phone;
        if (bio != null) _currentUser!['bio'] = bio;
      }
      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'فشل التحديث';
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  // ============================================================
  // تغيير كلمة السر
  // ============================================================
  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'فشل تغيير كلمة السر';
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  // ============================================================
  // تسجيل الخروج
  // ============================================================
  Future<void> signOut() async {
    _currentUser = null;
    _token = null;
    _error = null;
    ApiService.setToken(null);
    notifyListeners();
  }

  // ============================================================
  // استعادة الجلسة
  // ============================================================
  Future<bool> restoreSession() async {
    // في التطبيق الحقيقي: قراءة من SharedPreferences
    // حالياً: نرجع false دائماً
    await Future.delayed(const Duration(milliseconds: 200));
    return false;
  }

  // ============================================================
  // التحقق من الصلاحيات
  // ============================================================
  bool hasRole(String role) => userRole == role;
  bool isAdmin() => userRole == 'super_admin' || userRole == 'admin';
  bool isMerchant() => userRole == 'merchant';
  bool isCourier() => userRole == 'courier';
  bool isClient() => userRole == 'client';

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
