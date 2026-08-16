import 'package:flutter/material.dart';

/// Paleta inspirada en Windows XP — compatible con Material en Android/Web.
class XpColors {
  static const desktop = Color(0xFF3A6EA5);
  static const windowBg = Color(0xFFECE9D8);
  static const panelBg = Color(0xFFF1EFE2);
  static const titleStart = Color(0xFF0A246A);
  static const titleEnd = Color(0xFF0094FF);
  static const borderDark = Color(0xFF808080);
  static const borderLight = Color(0xFFFFFFFF);
  static const buttonFace = Color(0xFFECE9D8);
  static const selection = Color(0xFF316AC5);
  static const taskbar = Color(0xFF245EDC);
}

class AppTheme {
  static ThemeData get light {
    const cs = ColorScheme(
      brightness: Brightness.light,
      primary: XpColors.titleEnd,
      onPrimary: Colors.white,
      secondary: XpColors.taskbar,
      onSecondary: Colors.white,
      error: Color(0xFFB00020),
      onError: Colors.white,
      surface: XpColors.windowBg,
      onSurface: Color(0xFF1A1A1A),
    );

    return ThemeData(
      useMaterial3: false,
      colorScheme: cs,
      scaffoldBackgroundColor: XpColors.desktop,
      fontFamily: 'Segoe UI',
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: 'Tahoma',
        ),
      ),
      drawerTheme: const DrawerThemeData(backgroundColor: XpColors.panelBg),
      cardTheme: CardThemeData(
        color: XpColors.panelBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: XpColors.borderDark),
          borderRadius: BorderRadius.circular(2),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: const BorderSide(color: XpColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: const BorderSide(color: XpColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: const BorderSide(color: XpColors.selection, width: 2),
        ),
        labelStyle: const TextStyle(fontSize: 13),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: XpColors.buttonFace,
          foregroundColor: Colors.black87,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
            side: const BorderSide(color: XpColors.borderDark),
          ),
          textStyle: const TextStyle(fontFamily: 'Tahoma', fontSize: 13),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: XpColors.buttonFace,
          foregroundColor: Colors.black87,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          side: const BorderSide(color: XpColors.borderDark),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          textStyle: const TextStyle(fontFamily: 'Tahoma', fontSize: 13),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: XpColors.buttonFace,
          foregroundColor: Colors.black87,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
            side: const BorderSide(color: XpColors.borderDark),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Tahoma',
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: XpColors.buttonFace,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      listTileTheme: const ListTileThemeData(
        dense: true,
        iconColor: XpColors.titleStart,
        textColor: Color(0xFF1A1A1A),
      ),
      dividerTheme: const DividerThemeData(
        color: XpColors.borderDark,
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: XpColors.panelBg,
        contentTextStyle: const TextStyle(color: Colors.black87),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: XpColors.borderDark),
          borderRadius: BorderRadius.circular(2),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: XpColors.titleStart,
        unselectedLabelColor: Colors.black54,
        indicatorColor: XpColors.selection,
        labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }
}
