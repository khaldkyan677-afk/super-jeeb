import 'package:flutter/material.dart';

/// خدمة إدارة إعدادات المستخدم (الوضع الليلي، اللغة، ...)
class SettingsService extends ChangeNotifier {
  SettingsService._();
  static final SettingsService instance = SettingsService._();

  bool _darkMode = false;
  String _language = 'ar';
  bool _notifications = true;
  String _currency = 'YER';
  bool _sound = true;

  bool get darkMode => _darkMode;
  String get language => _language;
  bool get notificationsEnabled => _notifications;
  String get currency => _currency;
  bool get sound => _sound;

  void toggleDarkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }

  void setLanguage(String lang) {
    _language = lang;
    notifyListeners();
  }

  void toggleNotifications(bool value) {
    _notifications = value;
    notifyListeners();
  }

  void setCurrency(String curr) {
    _currency = curr;
    notifyListeners();
  }

  void toggleSound(bool value) {
    _sound = value;
    notifyListeners();
  }

  /// Light Theme
  static ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      primaryColor: const Color(0xFF2B2D42),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2B2D42),
        secondary: const Color(0xFFEF233C),
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF2B2D42),
        foregroundColor: Colors.white,
      ),
    );
  }

  /// Dark Theme
  static ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF1B1C2A),
      primaryColor: const Color(0xFF2B2D42),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2B2D42),
        secondary: const Color(0xFFEF233C),
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF2B2D42),
        foregroundColor: Colors.white,
      ),
    );
  }
}
