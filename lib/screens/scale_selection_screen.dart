import 'package:flutter/material.dart';
import '../models/eligibility_questions.dart';
import '../utils/app_theme.dart';
import 'assessment_screen.dart';

class ScaleSelectionScreen extends StatelessWidget {
  final String assessmentType;
  final Map<String, String> eligibilityAnswers;

  const ScaleSelectionScreen({
    super.key,
    required this.assessmentType,
    required this.eligibilityAnswers,
  });

  @override
  Widget build(BuildContext context) {
    List<String> availableScales;
    String recommendedScale;
    String recommendation;

    if (assessmentType == 'pressure_injury') {
      availableScales = PressureInjuryEligibility.getAvailableScales(eligibilityAnswers);
      recommendedScale = PressureInjuryEligibility.getRecommendedScale(eligibilityAnswers);
      recommendation = PressureInjuryEligibility.getScaleRecommendation(eligibilityAnswers);
    } else {
      availableScales = SurgicalInfectionEligibility.getAvailableScales(eligibilityAnswers);
      recommendedScale = SurgicalInfectionEligibility.getRecommendedScale(eligibilityAnswers);
      recommendation = SurgicalInfectionEligibility.getScaleRecommendation(eligibilityAnswers);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Selección de Escala'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: assessmentType == 'pressure_injury'
                ? AppTheme.pressureInjuryGradient
                : AppTheme.surgicalInfectionGradient,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Recomendación
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppTheme.lowRiskGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.lightbulb, color: Colors.white, size: 28),
                    SizedBox(width: 12),
                    Text(
                      'Recomendación',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  recommendation,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Escalas disponibles:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // Lista de escalas
          ...availableScales.map((scale) {
            bool isRecommended = scale == recommendedScale;
            return _buildScaleCard(
              context,
              scale,
              isRecommended,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildScaleCard(BuildContext context, String scaleId, bool isRecommended) {
    Map<String, Map<String, String>> scaleInfo = {
      'braden': {
        'name': 'Escala de Braden',
        'description': 'Estándar de oro internacional para úlceras por presión',
        'icon': '🏥',
      },
      'evaruci': {
        'name': 'Escala EVARUCI',
        'description': 'Específica para pacientes en UCI',
        'icon': '🚨',
      },
      'norton': {
        'name': 'Escala de Norton',
        'description': 'Específica para personas mayores (≥65 años)',
        'icon': '👴',
      },
      'nnis': {
        'name': 'Índice NNIS',
        'description': 'Para infección de sitio quirúrgico (ISQ)',
        'icon': '🔬',
      },
      'senic': {
        'name': 'Índice SENIC',
        'description': 'Predictor de sepsis nosocomial',
        'icon': '🦠',
      },
      'rac': {
        'name': 'Escala RAC',
        'description': 'Riesgo general de IAAS en adultos',
        'icon': '📊',
      },
      'cpis': {
        'name': 'Escala CPIS',
        'description': 'Neumonía asociada a ventilación mecánica',
        'icon': '🫁',
      },
    };

    final info = scaleInfo[scaleId]!;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isRecommended
            ? const BorderSide(color: AppTheme.greenStart, width: 3)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AssessmentScreen(
                assessmentType: assessmentType,
                scaleId: scaleId,
                eligibilityAnswers: eligibilityAnswers,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: assessmentType == 'pressure_injury'
                      ? AppTheme.pressureInjuryGradient
                      : AppTheme.surgicalInfectionGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    info['icon']!,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            info['name']!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (isRecommended)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.greenStart,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'RECOMENDADA',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      info['description']!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
