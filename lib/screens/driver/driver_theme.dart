// Super Jeeb — Driver Theme (Burnt Wood Identity)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DJ {
  static const Color bg = Color(0xFFF0EDDE);
  static const Color card = Color(0xFFFFFFFF);
  static const Color primary = Color(0xFF770101);
  static const Color primaryLight = Color(0xFF9C1A1A);
  static const Color secondary = Color(0xFF023048);
  static const Color softRed = Color(0xFFF6E7E7);
  static const Color softNavy = Color(0xFFE5EBEF);
  static const Color text = Color(0xFF1A1A1A);
  static const Color textMuted = Color(0xFF7A7A7A);
  static const Color success = Color(0xFF25D366);
  static const Color warning = Color(0xFFF0C107);
  static const Color danger = Color(0xFFEF233C);
  static const Color border = Color(0xFFE5DECA);

  static const Color radarBg = Color(0xFF0A0F14);
  static const Color radarSurface = Color(0xFF1A1F26);
  static const Color radarRed = Color(0xFFEF233C);

  static List<BoxShadow> get shadowSoft => [
        BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 3)),
      ];
  static List<BoxShadow> get shadow => [
        BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 18, offset: const Offset(0, 6)),
      ];

  static TextStyle get h1 => GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.w800, color: text);
  static TextStyle get h2 => GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w700, color: text);
  static TextStyle get h3 => GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w700, color: text);
  static TextStyle get body => GoogleFonts.cairo(fontSize: 13, color: text, height: 1.5);
  static TextStyle get muted => GoogleFonts.cairo(fontSize: 12, color: textMuted);
  static TextStyle get tiny => GoogleFonts.cairo(fontSize: 10, color: textMuted);
  static TextStyle get price => GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w800, color: primary);

  static ThemeData theme() => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: bg,
        primaryColor: primary,
        fontFamily: GoogleFonts.cairo().fontFamily,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          primary: primary,
          secondary: secondary,
          surface: card,
        ),
      );
}
