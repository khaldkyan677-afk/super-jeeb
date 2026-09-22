import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ═══ الألوان الأساسية ═══
  static const Color red = Color(0xFFEF233C);
  static const Color redGlow = Color(0x33EF233C);
  static const Color dark = Color(0xFF0D0D12);
  static const Color charcoal = Color(0xFF1A1B26);
  static const Color surface = Color(0xFF23242F);
  static const Color glass = Color(0x0DFFFFFF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF8F9FA);
  static const Color gray = Color(0xFF9E9E9E);
  static const Color yellow = Color(0xFFF0C107);
  static const Color green = Color(0xFF25D366);

  // ═══ الحواف ═══
  static const double radius = 20;
  static const double radiusSmall = 12;
  static const BorderRadius borderRadius = BorderRadius.all(Radius.circular(radius));
  static const BorderRadius borderRadiusSmall = BorderRadius.all(Radius.circular(radiusSmall));

  // ═══ الظلال الناعمة ═══
  static List<BoxShadow> softShadow = [
    BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 8)),
  ];
  static List<BoxShadow> redGlowShadow = [
    BoxShadow(color: redGlow, blurRadius: 24, offset: const Offset(0, 8)),
  ];

  // ═══ الأنماط النصية ═══
  static TextStyle title = GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.bold, color: dark);
  static TextStyle section = GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w600, color: dark);
  static TextStyle body = GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w400, color: dark);
  static TextStyle caption = GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w500, color: gray);

  static TextStyle titleWhite = GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.bold, color: white);
  static TextStyle sectionWhite = GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w600, color: white);
  static TextStyle bodyWhite = GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w400, color: white);
  static TextStyle captionWhite = GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white70);

  // ═══ ThemeData الموحد ═══
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: lightGray,
        primaryColor: red,
        colorScheme: ColorScheme.fromSeed(
          seedColor: red,
          primary: red,
          secondary: dark,
          surface: white,
        ),
        fontFamily: GoogleFonts.cairo().fontFamily,
        appBarTheme: AppBarTheme(
          backgroundColor: dark,
          foregroundColor: white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.bold, color: white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: red,
            foregroundColor: white,
            shape: const RoundedRectangleBorder(borderRadius: borderRadius),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            textStyle: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(borderRadius: borderRadiusSmall, borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: borderRadiusSmall, borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: borderRadiusSmall, borderSide: const BorderSide(color: red, width: 1.5)),
          hintStyle: GoogleFonts.cairo(color: gray, fontSize: 14),
        ),
        cardTheme: CardThemeData(
          color: white,
          elevation: 0,
          shape: const RoundedRectangleBorder(borderRadius: borderRadius),
          margin: EdgeInsets.zero,
        ),
      );
}
