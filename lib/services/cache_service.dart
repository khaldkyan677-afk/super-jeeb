import 'dart:convert';

/// خدمة التخزين المؤقت داخل التطبيق
/// تعمل بدون مكتبات خارجية - تحفظ في الذاكرة
class CacheService {
  // Singleton
  CacheService._();
  static final CacheService instance = CacheService._();

  // التخزين في الذاكرة
  final Map<String, _CacheEntry> _memory = {};

  // ---------- الحفظ ----------
  void set(String key, dynamic value, {Duration? ttl}) {
    final expiresAt = ttl != null
        ? DateTime.now().add(ttl)
        : DateTime.now().add(const Duration(hours: 24));
    _memory[key] = _CacheEntry(
      value: jsonEncode(value),
      expiresAt: expiresAt,
    );
  }

  // ---------- القراءة ----------
  dynamic get(String key) {
    final entry = _memory[key];
    if (entry == null) return null;

    // تحقق من انتهاء الصلاحية
    if (DateTime.now().isAfter(entry.expiresAt)) {
      _memory.remove(key);
      return null;
    }

    try {
      return jsonDecode(entry.value);
    } catch (e) {
      return entry.value;
    }
  }

  // ---------- الحذف ----------
  void remove(String key) => _memory.remove(key);

  // ---------- مسح الكل ----------
  void clear() => _memory.clear();

  // ---------- مسح حسب النمط ----------
  void clearPattern(String prefix) {
    _memory.removeWhere((k, v) => k.startsWith(prefix));
  }

  // ---------- الإحصائيات ----------
  Map<String, dynamic> stats() {
    final now = DateTime.now();
    int active = 0;
    int expired = 0;
    int totalBytes = 0;

    for (var e in _memory.entries) {
      if (now.isAfter(e.value.expiresAt)) {
        expired++;
      } else {
        active++;
      }
      totalBytes += e.value.value.length;
    }

    return {
      'total_keys': _memory.length,
      'active': active,
      'expired': expired,
      'size_kb': (totalBytes / 1024).toStringAsFixed(2),
    };
  }

  // ---------- أنواع مساعدة ----------
  void cacheSearch(String query) {
    set('search_$query', {'query': query, 'ts': DateTime.now().toIso8601String()},
        ttl: const Duration(minutes: 30));
  }

  void cacheApi(String endpoint, dynamic data) {
    set('api_$endpoint', data, ttl: const Duration(minutes: 15));
  }

  void cacheProducts(List products) {
    set('products_list', products, ttl: const Duration(hours: 1));
  }

  void cacheMerchants(List merchants) {
    set('merchants_list', merchants, ttl: const Duration(hours: 2));
  }

  void cacheCategories(List categories) {
    set('categories_list', categories, ttl: const Duration(hours: 6));
  }
}

class _CacheEntry {
  final String value;
  final DateTime expiresAt;

  _CacheEntry({required this.value, required this.expiresAt});
}
