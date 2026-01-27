import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/pressure_injury_scales.dart';
import '../models/infection_scales.dart';
import '../utils/app_theme.dart';

class ResultScreen extends StatelessWidget {
  final String assessmentType;
  final String scaleId;
  final String scaleName;
  final String patientName;
  final String patientId;
  final dynamic totalScore;
  final String riskLevel;
  final Map<String, dynamic> answers;

  const ResultScreen({
    super.key,
    required this.assessmentType,
    required this.scaleId,
    required this.scaleName,
    required this.patientName,
    required this.patientId,
    required this.totalScore,
    required this.riskLevel,
    required this.answers,
  });

  String _getRiskDescription() {
    switch (scaleId) {
      case 'braden':
        return BradenScale.getRiskDescription(riskLevel);
      case 'evaruci':
        return EVARUCIScale.getRiskDescription(riskLevel);
      case 'norton':
        return NortonScale.getRiskDescription(riskLevel);
      case 'nnis':
        return NNISScale.getRiskDescription(riskLevel);
      case 'senic':
        return SENICScale.getRiskDescription(riskLevel);
      case 'rac':
        return RACScale.getRiskDescription(riskLevel);
      case 'cpis':
        return CPISScale.getRiskDescription(riskLevel);
      default:
        return 'Descripción no disponible';
    }
  }

  List<String> _getRecommendations() {
    // Recomendaciones según nivel de riesgo
    if (assessmentType == 'pressure_injury') {
      switch (riskLevel) {
        case 'muy_alto':
        case 'alto':
          return [
            'Implementar medidas preventivas intensivas inmediatamente',
            'Cambios posturales cada 2 horas',
            'Uso de superficies especiales de redistribución de presión',
            'Valoración nutricional y optimización proteica',
            'Mantener piel limpia y seca',
            'Inspección diaria de zonas de presión',
            'Documentar hallazgos y plan de cuidados',
          ];
        case 'moderado':
          return [
            'Implementar protocolo de prevención estándar',
            'Cambios posturales cada 2-3 horas',
            'Uso de colchón antiescaras si está disponible',
            'Mantener hidratación y nutrición adecuada',
            'Inspección regular de la piel',
          ];
        case 'bajo':
        case 'minimo':
          return [
            'Mantener medidas preventivas básicas',
            'Cambios posturales regulares',
            'Mantener higiene de la piel',
            'Vigilar cambios en el estado del paciente',
          ];
        default:
          return [
            'Continuar con cuidados rutinarios',
            'Mantener vigilancia del estado del paciente',
          ];
      }
    } else {
      // Infección quirúrgica
      switch (riskLevel) {
        case 'alto':
        case 'grave':
        case 'muy_alto':
          return [
            'Vigilancia intensiva postoperatoria',
            'Aplicar bundle de prevención de ISQ',
            'Considerar profilaxis antibiótica extendida',
            'Monitoreo de signos vitales estrecho',
            'Evaluación diaria de herida quirúrgica',
            'Control glucémico estricto',
            'Documentar evolución clínica detallada',
          ];
        case 'moderado':
        case 'moderado_alto':
        case 'sospecha':
          return [
            'Aplicar medidas estándar de prevención de infección',
            'Asepsia y antisepsia rigurosa',
            'Profilaxis antibiótica según protocolo',
            'Monitoreo de signos de infección',
            'Control de factores de riesgo modificables',
          ];
        default:
          return [
            'Mantener medidas preventivas estándar',
            'Vigilancia habitual de herida',
            'Educación al paciente sobre signos de alarma',
          ];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final riskColor = AppTheme.getRiskColor(riskLevel);
    final riskIcon = AppTheme.getRiskIcon(riskLevel);
    final riskLabel = AppTheme.getRiskLabel(riskLevel);
    final recommendations = _getRecommendations();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Implementar compartir resultados
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          // Header con resultado principal
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  riskColor,
                  riskColor.withOpacity( 0.7),
                ],
              ),
            ),
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(
                  riskIcon,
                  size: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                Text(
                  riskLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  scaleName,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Puntuación Total: ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        totalScore is double
                            ? totalScore.toStringAsFixed(1)
                            : totalScore.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        ' puntos',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Datos del paciente
          Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Datos de la Evaluación',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(Icons.person, 'Paciente', patientName),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.badge, 'ID Paciente', patientId),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.event,
                      'Fecha de Evaluación',
                      DateFormat('dd/MM/yyyy').format(DateTime.now()),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.schedule,
                      'Hora de Evaluación',
                      DateFormat('HH:mm:ss').format(DateTime.now()),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.medical_information,
                      'Escala Aplicada',
                      scaleName,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Interpretación clínica
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: riskColor),
                        const SizedBox(width: 12),
                        const Text(
                          'Interpretación Clínica',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Text(
                      _getRiskDescription(),
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Recomendaciones
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: AppTheme.primaryBase),
                        SizedBox(width: 12),
                        Text(
                          'Recomendaciones',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    ...recommendations.map((rec) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryBase,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              rec,
                              style: const TextStyle(fontSize: 15, height: 1.5),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Botones de acción
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  icon: const Icon(Icons.home),
                  label: const Text('Volver al Inicio'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBase,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    // Implementar nueva evaluación
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Nueva Evaluación'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.black54),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black54,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
