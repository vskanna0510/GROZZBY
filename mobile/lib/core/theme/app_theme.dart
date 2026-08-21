import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

abstract final class AppTheme {
  static ThemeData get light => getTheme(isDark: false);
  static ThemeData get dark => getTheme(isDark: true);

  static ThemeData getTheme({required bool isDark, bool highContrast = false}) {
    if (isDark) {
      final scaffoldBg = highContrast ? const Color(0xFF000000) : const Color(0xFF0B1120);
      final surfaceColor = highContrast ? const Color(0xFF111827) : const Color(0xFF1E293B);
      final borderColor = highContrast ? const Color(0xFF475569) : const Color(0xFF334155);

      return ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: scaffoldBg,
        cardColor: surfaceColor,
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF3B82F6),
          secondary: const Color(0xFF60A5FA),
          surface: surfaceColor,
          onSurface: Colors.white,
          onPrimary: Colors.white,
          outline: borderColor,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: surfaceColor,
          elevation: 0,
          scrolledUnderElevation: 1,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        cardTheme: CardThemeData(
          color: surfaceColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: borderColor, width: highContrast ? 1.5 : 1),
          ),
        ),
        dividerColor: borderColor,
        dividerTheme: DividerThemeData(
          color: borderColor,
          thickness: 1,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF0F172A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          hintStyle: GoogleFonts.inter(color: const Color(0xFF94A3B8), fontSize: 13),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
            elevation: 0,
          ),
        ),
        textTheme: GoogleFonts.interTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ),
      );
    } else {
      final scaffoldBg = highContrast ? const Color(0xFFFFFFFF) : AppColors.background;
      final surfaceColor = AppColors.white;
      final borderColor = highContrast ? const Color(0xFF94A3B8) : AppColors.neutral200;

      return ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: scaffoldBg,
        cardColor: surfaceColor,
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF2563EB),
          secondary: AppColors.secondary,
          surface: surfaceColor,
          onSurface: AppColors.neutral900,
          onPrimary: Colors.white,
          outline: borderColor,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: surfaceColor,
          elevation: 0,
          scrolledUnderElevation: 1,
          iconTheme: const IconThemeData(color: AppColors.neutral900),
          titleTextStyle: GoogleFonts.inter(
            color: AppColors.neutral900,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        cardTheme: CardThemeData(
          color: surfaceColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: borderColor, width: highContrast ? 1.5 : 1),
          ),
        ),
        dividerColor: borderColor,
        dividerTheme: DividerThemeData(
          color: borderColor,
          thickness: 1,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.input,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          hintStyle: AppTextStyles.labelBold12,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            foregroundColor: AppColors.white,
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: AppTextStyles.bodySemiBold16,
            elevation: 0,
          ),
        ),
        textTheme: GoogleFonts.interTextTheme(
          ThemeData(brightness: Brightness.light).textTheme,
        ),
      );
    }
  }
}
