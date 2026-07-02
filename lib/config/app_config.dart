// lib/config/app_config.dart
import 'package:flutter/material.dart';

class AppConfig {
  static const String appName = 'SkillLink';

  // Brand colors
  static const Color primaryBlue = Color(0xFF1A6BFF);
  static const Color primaryBlueDark = Color(0xFF0047CC);
  static const Color accentGreen = Color(0xFF00C896);
  static const Color background = Color(0xFFF5F7FA);

  static const Color textDark = Color(0xFF0F172A);
  static const Color textMid = Color(0xFF334155);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textFaint = Color(0xFF94A3B8);

  static const Color border = Color(0xFFE2E8F0);
  static const Color cardBorder = Color(0xFFE8EDF2);
  static const Color chipBg = Color(0xFFF1F5F9);

  static ThemeData theme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
        secondary: accentGreen,
        surface: background,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.white,
        titleSpacing: 0,
      ),
      drawerTheme: const DrawerThemeData(backgroundColor: Colors.white),
    );
  }
}
