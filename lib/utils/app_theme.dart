import 'package:flutter/material.dart';

class AppTheme {
  // Color base principal #F43058 (Rosa/Rojo vibrante)
  static const Color primaryBase = Color(0xFFF43058);
  
  // Paleta de colores derivados del color base #F43058
  static const Color primaryLight = Color(0xFFFF6B8A);  // Versión más clara
  static const Color primaryDark = Color(0xFFD81B43);   // Versión más oscura
  static const Color primaryDeep = Color(0xFFC41144);   // Versión profunda
  
  // Colores complementarios basados en #F43058
  static const Color accentPurple = Color(0xFFB430F4); // Púrpura (complementario)
  static const Color accentOrange = Color(0xFFF47430); // Naranja cálido
  static const Color accentPink = Color(0xFFF430B4);   // Rosa magenta
  
  // Gradientes para las tarjetas basados en #F43058
  static const Color pressureStart = Color(0xFFF43058);  // Base principal
  static const Color pressureEnd = Color(0xFFFF6B8A);    // Rosa claro
  
  static const Color infectionStart = Color(0xFFF43058); // Base principal
  static const Color infectionEnd = Color(0xFFB430F4);   // Púrpura
  
  static const Color greenStart = Color(0xFF4CAF50);     // Verde para bajo riesgo
  static const Color greenEnd = Color(0xFF81C784);       // Verde claro
  
  static const Color redStart = Color(0xFFF43058);       // Base principal
  static const Color redEnd = Color(0xFFD81B43);         // Rojo oscuro
  
  // Gradiente principal de la app (Rosa a Púrpura)
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBase, accentPurple],
  );
  
  // Gradiente para Lesiones por Presión (Rosa a Rosa claro)
  static const LinearGradient pressureInjuryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [pressureStart, pressureEnd],
  );
  
  // Gradiente para Infección Quirúrgica (Rosa a Púrpura)
  static const LinearGradient surgicalInfectionGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [infectionStart, infectionEnd],
  );
  
  // Gradientes de riesgo
  static const LinearGradient lowRiskGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [greenStart, greenEnd],
  );
  
  static const LinearGradient highRiskGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [redStart, redEnd],
  );
  
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBase,
        primary: primaryBase,
        secondary: accentPurple,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      cardTheme: const CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
      ),
    );
  }
  
  // Colores para los niveles de riesgo
  static Color getRiskColor(String riskLevel) {
    switch (riskLevel) {
      case 'sin_riesgo':
      case 'minimo':
      case 'muy_bajo':
        return const Color(0xFF4CAF50); // Verde
      case 'bajo':
      case 'bajo_moderado':
        return const Color(0xFF81C784); // Verde claro
      case 'moderado':
      case 'moderado_alto':
      case 'intermedio':
        return const Color(0xFFFF9800); // Naranja
      case 'alto':
      case 'sospecha':
        return const Color(0xFFFF6B8A); // Rosa claro (del gradiente)
      case 'muy_alto':
      case 'grave':
        return const Color(0xFFF43058); // Rosa base principal
      default:
        return const Color(0xFF9E9E9E); // Gris
    }
  }
  
  // Iconos para los niveles de riesgo
  static IconData getRiskIcon(String riskLevel) {
    switch (riskLevel) {
      case 'sin_riesgo':
      case 'minimo':
      case 'muy_bajo':
        return Icons.check_circle;
      case 'bajo':
      case 'bajo_moderado':
        return Icons.info;
      case 'moderado':
      case 'moderado_alto':
      case 'intermedio':
        return Icons.warning_amber;
      case 'alto':
      case 'sospecha':
        return Icons.warning;
      case 'muy_alto':
      case 'grave':
        return Icons.error;
      default:
        return Icons.help;
    }
  }
  
  // Texto legible para niveles de riesgo
  static String getRiskLabel(String riskLevel) {
    switch (riskLevel) {
      case 'sin_riesgo':
        return 'Sin Riesgo';
      case 'minimo':
      case 'muy_bajo':
        return 'Riesgo Mínimo';
      case 'bajo':
        return 'Riesgo Bajo';
      case 'bajo_moderado':
        return 'Riesgo Bajo-Moderado';
      case 'moderado':
        return 'Riesgo Moderado';
      case 'moderado_alto':
        return 'Riesgo Moderado-Alto';
      case 'intermedio':
        return 'Riesgo Intermedio';
      case 'alto':
        return 'Riesgo Alto';
      case 'sospecha':
        return 'Sospecha de Infección';
      case 'muy_alto':
        return 'Riesgo Muy Alto';
      case 'grave':
        return 'Riesgo Grave';
      default:
        return 'Desconocido';
    }
  }
}
