import 'package:flutter/material.dart';
import 'utils/app_theme.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Hive para almacenamiento local (futuro)
  // await Hive.initFlutter();
  
  runApp(const MedicalRiskAnalyzerApp());
}

class MedicalRiskAnalyzerApp extends StatelessWidget {
  const MedicalRiskAnalyzerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical Risk Analyzer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const HomeScreen(),
    );
  }
}
