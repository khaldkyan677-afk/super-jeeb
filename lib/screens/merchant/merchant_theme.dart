// Super Jeeb — Merchant Theme (Light Beige + Burgundy)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MJ {
  // 🎨 الألوان
  static const Color bg = Color(0xFFF5EFE6);
  static const Color card = Color(0xFFFFFFFF);
  static const Color primary = Color(0xFF7B1E3A);
  static const Color primaryLight = Color(0xFFA3264A);
  static const Color softPink = Color(0xFFF8E9EE);
  static const Color text = Color(0xFF2B2D42);
  static const Color textMuted = Color(0xFF8B8578);
  static const Color success = Color(0xFF25D366);
  static const Color warning = Color(0xFFF0C107);
  static const Color danger = Color(0xFFEF233C);
  static const Color border = Color(0xFFEDE4D6);

  // ✨ الظلال
  static List<BoxShadow> get shadowSoft => [
        BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 3)),
      ];
  static List<BoxShadow> get shadow => [
        BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 18, offset: const Offset(0, 6)),
      ];

  // 📝 النصوص
  static TextStyle get h1 => GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.w800, color: text);
  static TextStyle get h2 => GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w700, color: text);
  static TextStyle get h3 => GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w700, color: text);
  static TextStyle get body => GoogleFonts.cairo(fontSize: 13, color: text, height: 1.5);
  static TextStyle get muted => GoogleFonts.cairo(fontSize: 12, color: textMuted);
  static TextStyle get tiny => GoogleFonts.cairo(fontSize: 10, color: textMuted);
  static TextStyle get price => GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w800, color: primary);

  // 🎯 الثيم العام
  static ThemeData theme() => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: bg,
        primaryColor: primary,
        fontFamily: GoogleFonts.cairo().fontFamily,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          primary: primary,
          secondary: primaryLight,
          surface: card,
        ),
      );
}
