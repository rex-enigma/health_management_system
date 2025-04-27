import 'package:flutter/material.dart';
import 'package:health_managment_system/ui/common/ui_helpers.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal,
        brightness: Brightness.light,
        primary: Colors.teal,
        secondary: Colors.tealAccent,
        surface: Colors.white,
        onSurface: Colors.black87,
        error: Colors.redAccent,
      ),
      scaffoldBackgroundColor: Colors.grey[100],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.teal,
          textStyle: TextStyle(fontSize: getResponsiveMediumFontSize(context)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          textStyle: TextStyle(fontSize: getResponsiveMediumFontSize(context)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.teal, width: 2),
        ),
        labelStyle: TextStyle(fontSize: getResponsiveSmallFontSize(context)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      iconTheme: IconThemeData(
        color: Colors.teal,
        size: getResponsiveMediumFontSize(context) * 1.5,
      ),
      typography: Typography(
        white: TextTheme(
          headlineLarge: TextStyle(
            fontSize: getResponsiveMassiveFontSize(context),
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          headlineMedium: TextStyle(
            fontSize: getResponsiveExtraLargeFontSize(context),
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          bodyLarge: TextStyle(
            fontSize: getResponsiveLargeFontSize(context),
            color: Colors.black87,
          ),
          bodyMedium: TextStyle(
            fontSize: getResponsiveMediumFontSize(context),
            color: Colors.black54,
          ),
          bodySmall: TextStyle(
            fontSize: getResponsiveSmallFontSize(context),
            color: Colors.black54,
          ),
        ),
        black: TextTheme(
          headlineLarge: TextStyle(
            fontSize: getResponsiveMassiveFontSize(context),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headlineMedium: TextStyle(
            fontSize: getResponsiveExtraLargeFontSize(context),
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            fontSize: getResponsiveLargeFontSize(context),
            color: Colors.white70,
          ),
          bodyMedium: TextStyle(
            fontSize: getResponsiveMediumFontSize(context),
            color: Colors.white60,
          ),
          bodySmall: TextStyle(
            fontSize: getResponsiveSmallFontSize(context),
            color: Colors.white60,
          ),
        ),
      ),
    );
  }

  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal,
        brightness: Brightness.dark,
        primary: Colors.teal,
        secondary: Colors.tealAccent,
        surface: Colors.grey[900]!,
        onSurface: Colors.white70,
        error: Colors.redAccent,
      ),
      scaffoldBackgroundColor: Colors.grey[850],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: Colors.grey[800],
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.tealAccent,
          textStyle: TextStyle(fontSize: getResponsiveMediumFontSize(context)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          textStyle: TextStyle(fontSize: getResponsiveMediumFontSize(context)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[600]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.teal, width: 2),
        ),
        labelStyle: TextStyle(fontSize: getResponsiveSmallFontSize(context)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      iconTheme: IconThemeData(
        color: Colors.tealAccent,
        size: getResponsiveMediumFontSize(context) * 1.5,
      ),
      typography: Typography(
        white: TextTheme(
          headlineLarge: TextStyle(
            fontSize: getResponsiveMassiveFontSize(context),
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          headlineMedium: TextStyle(
            fontSize: getResponsiveExtraLargeFontSize(context),
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          bodyLarge: TextStyle(
            fontSize: getResponsiveLargeFontSize(context),
            color: Colors.black87,
          ),
          bodyMedium: TextStyle(
            fontSize: getResponsiveMediumFontSize(context),
            color: Colors.black54,
          ),
          bodySmall: TextStyle(
            fontSize: getResponsiveSmallFontSize(context),
            color: Colors.black54,
          ),
        ),
        black: TextTheme(
          headlineLarge: TextStyle(
            fontSize: getResponsiveMassiveFontSize(context),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headlineMedium: TextStyle(
            fontSize: getResponsiveExtraLargeFontSize(context),
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            fontSize: getResponsiveLargeFontSize(context),
            color: Colors.white70,
          ),
          bodyMedium: TextStyle(
            fontSize: getResponsiveMediumFontSize(context),
            color: Colors.white60,
          ),
          bodySmall: TextStyle(
            fontSize: getResponsiveSmallFontSize(context),
            color: Colors.white60,
          ),
        ),
      ),
    );
  }
}
