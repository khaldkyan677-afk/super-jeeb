import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// خدمة الأمان - تمنع التسجيل الوهمي وتحد من المحاولات
class SecurityService {
  SecurityService._();
  static final SecurityService instance = SecurityService._();

  // ---------- الإعدادات ----------
  static const int maxLoginAttempts = 5;
  static const int maxOtpAttempts = 3;
  static const int lockDurationMinutes = 15;
  static const int maxRegistrationsPerDevice = 2;

  // ---------- التخزين في الذاكرة ----------
  final Map<String, _AttemptRecord> _attempts = {};
  final List<String> _blacklistedDevices = [];
  final Set<String> _registeredDevices = {};

  // ---------- معلومات الجهاز ----------
  String? _deviceId;
  String? _deviceFingerprint;

  // ============================================================
  // 1. توليد بصمة الجهاز
  // ============================================================
  String generateDeviceId() {
    if (_deviceId != null) return _deviceId!;
    final rand = Random.secure();
    final bytes = List<int>.generate(32, (_) => rand.nextInt(256));
    _deviceId = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    debugPrint('🔒 Device ID: $_deviceId');
    return _deviceId!;
  }

  String generateFingerprint({
    required String platform,
    required String model,
    required String appVersion,
  }) {
    _deviceFingerprint =
        '${platform}_${model}_${appVersion}_${generateDeviceId().substring(0, 8)}';
    return _deviceFingerprint!;
  }

  String? get deviceId => _deviceId;
  String? get deviceFingerprint => _deviceFingerprint;

  // ============================================================
  // 2. فحص الحظر
  // ============================================================
  bool isDeviceBlacklisted() {
    if (_deviceId == null) return false;
    return _blacklistedDevices.contains(_deviceId);
  }

  bool isDeviceRegistered() {
    if (_deviceId == null) return false;
    return _registeredDevices.contains(_deviceId);
  }

  int get registeredCount => _registeredDevices.length;

  // ============================================================
  // 3. حد المحاولات
  // ============================================================
  bool canAttempt(String key) {
    final rec = _attempts[key];
    if (rec == null) return true;

    // تحقق من القفل
    if (rec.lockedUntil != null && DateTime.now().isBefore(rec.lockedUntil!)) {
      return false;
    }

    // انتهى القفل - أعد التصفير
    if (rec.lockedUntil != null && DateTime.now().isAfter(rec.lockedUntil!)) {
      _attempts.remove(key);
      return true;
    }

    return rec.count < maxLoginAttempts;
  }

  int getRemainingAttempts(String key) {
    final rec = _attempts[key];
    if (rec == null) return maxLoginAttempts;
    if (rec.lockedUntil != null && DateTime.now().isBefore(rec.lockedUntil!)) {
      return 0;
    }
    return maxLoginAttempts - rec.count;
  }

  Duration? getLockRemaining(String key) {
    final rec = _attempts[key];
    if (rec?.lockedUntil == null) return null;
    if (DateTime.now().isAfter(rec!.lockedUntil!)) return null;
    return rec.lockedUntil!.difference(DateTime.now());
  }

  // ============================================================
  // 4. تسجيل المحاولات
  // ============================================================
  void recordAttempt(String key, {bool success = false}) {
    if (success) {
      _attempts.remove(key);
      return;
    }

    final rec = _attempts[key] ?? _AttemptRecord();
    rec.count++;
    rec.lastAttempt = DateTime.now();

    if (rec.count >= maxLoginAttempts) {
      rec.lockedUntil =
          DateTime.now().add(const Duration(minutes: lockDurationMinutes));
      debugPrint('🚫 $key مقفول لمدة $lockDurationMinutes دقيقة');
    }

    _attempts[key] = rec;
  }

  // ============================================================
  // 5. التحقق من كلمة السر
  // ============================================================
  Map<String, dynamic> validatePassword(String password) {
    if (password.length < 8) {
      return {'valid': false, 'error': 'كلمة السر يجب أن تكون 8 أحرف على الأقل'};
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return {'valid': false, 'error': 'يجب أن تحتوي على حرف كبير واحد'};
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return {'valid': false, 'error': 'يجب أن تحتوي على رقم واحد'};
    }
    return {'valid': true};
  }

  // ============================================================
  // 6. التحقق من رقم الهاتف
  // ============================================================
  bool isValidYemeniPhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[^0-9]'), '');
    // الأرقام اليمنية تبدأ بـ 7 وتكون 9 أرقام
    return RegExp(r'^7[0-9]{8}$').hasMatch(cleaned);
  }

  String normalizePhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[^0-9]'), '');
    return cleaned;
  }

  // ============================================================
  // 7. التحقق من البريد الإلكتروني
  // ============================================================
  bool isValidEmail(String email) {
    return RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(email);
  }

  bool isDisposableEmail(String email) {
    // قائمة بالبريد المؤقت
    const disposables = [
      'tempmail.com',
      'guerrillamail.com',
      '10minutemail.com',
      'throwaway.com',
      'mailinator.com',
      'yopmail.com',
      'temp-mail.org',
    ];
    final domain = email.split('@').last.toLowerCase();
    return disposables.contains(domain);
  }

  // ============================================================
  // 8. التحقق من التسجيل السريع
  // ============================================================
  bool isSuspiciousRegistration() {
    // إذا سجل نفس الجهاز أكثر من الحد
    if (registeredCount >= maxRegistrationsPerDevice) {
      return true;
    }
    return false;
  }

  void markDeviceAsRegistered() {
    if (_deviceId != null) {
      _registeredDevices.add(_deviceId!);
      debugPrint('📱 أجهزة مسجلة: ${_registeredDevices.length}');
    }
  }

  // ============================================================
  // 9. الحظر
  // ============================================================
  void blacklistCurrentDevice(String reason) {
    if (_deviceId != null) {
      _blacklistedDevices.add(_deviceId!);
      debugPrint('🚫 الجهاز محظور: $reason');
    }
  }

  // ============================================================
  // 10. تحقق شامل من التسجيل
  // ============================================================
  Map<String, dynamic> validateRegistration({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) {
    if (name.trim().length < 3) {
      return {'valid': false, 'error': 'الاسم قصير جداً'};
    }
    if (name.trim().split(' ').length < 2) {
      return {'valid': false, 'error': 'أدخل الاسم الكامل'};
    }
    if (!isValidEmail(email)) {
      return {'valid': false, 'error': 'البريد الإلكتروني غير صحيح'};
    }
    if (isDisposableEmail(email)) {
      return {'valid': false, 'error': 'البريد المؤقت غير مدعوم'};
    }
    if (!isValidYemeniPhone(phone)) {
      return {'valid': false, 'error': 'رقم الهاتف غير صحيح (يبدأ بـ 7، 9 أرقام)'};
    }
    final passCheck = validatePassword(password);
    if (passCheck['valid'] == false) {
      return passCheck;
    }
    if (isDeviceBlacklisted()) {
      return {'valid': false, 'error': 'هذا الجهاز محظور'};
    }
    if (isSuspiciousRegistration()) {
      return {'valid': false, 'error': 'تم تسجيل حد أقصى من الحسابات من هذا الجهاز'};
    }
    return {'valid': true};
  }

  // ============================================================
  // 11. تصفير (للتجربة)
  // ============================================================
  void reset() {
    _attempts.clear();
    _registeredDevices.clear();
    _blacklistedDevices.clear();
  }
}

class _AttemptRecord {
  int count = 0;
  DateTime? lastAttempt;
  DateTime? lockedUntil;
}
