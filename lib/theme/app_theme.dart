import 'package:flutter/material.dart';

class AppTheme {
  // Colores corporativos KURA+
  static const Color primaryKura = Color(0xFFE91E63); // Rosa KURA+
  static const Color primaryDark = Color(0xFFC2185B);
  static const Color primaryLight = Color(0xFFF8BBD0);
  
  // Tonos piel para contexto médico
  static const Color skinTone1 = Color(0xFFFFF0E1); // Piel clara
  static const Color skinTone2 = Color(0xFFFFE4C4); // Piel media-clara
  static const Color skinTone3 = Color(0xFFDEB887); // Piel media
  static const Color skinTone4 = Color(0xFFD2691E); // Piel media-oscura
  static const Color skinTone5 = Color(0xFF8B4513); // Piel oscura
  
  // Colores de estado médico
  static const Color curable = Color(0xFF4CAF50); // Verde - Curable
  static const Color mantenimiento = Color(0xFFFF9800); // Naranja - Mantenimiento
  static const Color noCurable = Color(0xFFF44336); // Rojo - No curable
  
  // Colores de la interfaz
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: primaryKura,
        onPrimary: Colors.white,
        secondary: primaryLight,
        onSecondary: textPrimary,
        surface: surface,
        onSurface: textPrimary,
        error: noCurable,
        onError: Colors.white,
      ),
      
      // Scaffold
      scaffoldBackgroundColor: background,
      
      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      // Card
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: surface,
      ),
      
      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryKura,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      
      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryKura,
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryKura, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      
      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryKura,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryKura,
        unselectedItemColor: textSecondary,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      
      // Text Theme
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: textPrimary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: textSecondary,
        ),
      ),
    );
  }
  
  // Método helper para obtener color según capacidad de curación
  static Color getCapacityColor(String capacity) {
    switch (capacity.toLowerCase()) {
      case 'curable':
        return curable;
      case 'mantenimiento':
        return mantenimiento;
      case 'no curable':
        return noCurable;
      default:
        return textSecondary;
    }
  }
  
  // Método helper para obtener tono de piel según índice
  static Color getSkinTone(int index) {
    switch (index) {
      case 1:
        return skinTone1;
      case 2:
        return skinTone2;
      case 3:
        return skinTone3;
      case 4:
        return skinTone4;
      case 5:
        return skinTone5;
      default:
        return skinTone3;
    }
  }
}
