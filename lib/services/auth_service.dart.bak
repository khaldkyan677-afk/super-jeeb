import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// خدمة المصادقة — Firebase Auth
class AuthService extends ChangeNotifier {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ---------- الحالة ----------
  User? _firebaseUser;
  String? _verificationId;
  int? _resendToken;
  bool _loading = false;
  String? _error;
  String? _pendingPhone;

  // ---------- Getters ----------
  User? get firebaseUser => _firebaseUser;
  String? get verificationId => _verificationId;
  bool get loading => _loading;
  String? get error => _error;
  String? get pendingPhone => _pendingPhone;
  bool get isLoggedIn => _firebaseUser != null;
  String getUserName() => _firebaseUser?.displayName ?? 'مستخدم';
  String getUserPhone() => _firebaseUser?.phoneNumber ?? '';
  String getUserEmail() => _firebaseUser?.email ?? '';
  String get userId => _firebaseUser?.uid ?? '';

  // ============================================================
  // 1) إرسال OTP
  // ============================================================
  Future<bool> sendOtp(String phone) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final normalized = _normalizePhone(phone);
      _pendingPhone = normalized;

      await _auth.verifyPhoneNumber(
        phoneNumber: normalized,
        timeout: const Duration(seconds: 60),
        forceResendingToken: _resendToken,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // دخول تلقائي (Android فقط)
          await _auth.signInWithCredential(credential);
          _firebaseUser = _auth.currentUser;
          _loading = false;
          notifyListeners();
        },
        verificationFailed: (FirebaseAuthException e) {
          _error = _mapError(e.code);
          _loading = false;
          notifyListeners();
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _resendToken = resendToken;
          _loading = false;
          notifyListeners();
          debugPrint('📱 OTP sent. ID: $verificationId');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          _loading = false;
          notifyListeners();
        },
      );
      return true;
    } catch (e) {
      _error = 'فشل الإرسال: $e';
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  // ============================================================
  // 2) التحقق من OTP
  // ============================================================
  Future<bool> verifyOtp(String phone, String code) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      if (_verificationId == null) {
        _error = 'لم يتم إرسال كود';
        _loading = false;
        notifyListeners();
        return false;
      }

      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: code.trim(),
      );

      final result = await _auth.signInWithCredential(credential);
      _firebaseUser = result.user;
      _loading = false;
      notifyListeners();

      debugPrint('✅ Login: ${_firebaseUser?.uid}');
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _mapError(e.code);
      _loading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'خطأ: $e';
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  // ============================================================
  // 3) تسجيل Google
  // ============================================================
  Future<bool> signInWithGoogle() async {
    _loading = true;
    _error = 'Google Sign-In يحتاج إعداد إضافي';
    _loading = false;
    notifyListeners();
    return false;
  }

  // ============================================================
  // 4) تسجيل خروج
  // ============================================================
  Future<void> signOut() async {
    await _auth.signOut();
    _firebaseUser = null;
    _verificationId = null;
    _resendToken = null;
    _pendingPhone = null;
    _error = null;
    notifyListeners();
  }

  // ============================================================
  // أدوات مساعدة
  // ============================================================
  String _normalizePhone(String phone) {
    var p = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    if (p.startsWith('0')) p = p.substring(1);
    if (!p.startsWith('+')) {
      if (p.startsWith('967')) {
        p = '+$p';
      } else {
        p = '+967$p';
      }
    }
    return p;
  }

  String _mapError(String code) {
    switch (code) {
      case 'invalid-phone-number':
        return 'رقم الهاتف غير صحيح';
      case 'too-many-requests':
        return 'محاولات كثيرة. حاول لاحقًا';
      case 'invalid-verification-code':
        return 'الكود غير صحيح';
      case 'session-expired':
        return 'انتهت صلاحية الكود';
      case 'quota-exceeded':
        return 'تم استنفاد الحصة اليومية';
      case 'network-request-failed':
        return 'تحقق من الإنترنت';
      default:
        return 'خطأ: $code';
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
