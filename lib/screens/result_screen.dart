import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/assessment_result.dart';
import '../theme/app_theme.dart';

class ResultScreen extends StatelessWidget {
  final AssessmentResult result;

  const ResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final Color capacityColor = AppTheme.getCapacityColor(result.capacityString);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado de Evaluación'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implementar compartir resultado
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Función de compartir próximamente')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarjeta de información del paciente
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person, color: AppTheme.primaryKura),
                        const SizedBox(width: 8),
                        Text(
                          'Información del Paciente',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    _InfoRow(label: 'Nombre', value: result.patientName),
                    _InfoRow(label: 'Edad', value: '${result.patientAge} años'),
                    _InfoRow(label: 'Peso', value: '${result.weight} kg'),
                    _InfoRow(label: 'Talla', value: '${result.height} cm'),
                    _InfoRow(label: 'Diagnóstico', value: result.diagnosis),
                    _InfoRow(
                      label: 'Fecha',
                      value: DateFormat('dd/MM/yyyy HH:mm').format(result.assessmentDate),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Tarjeta de resultado principal
            Card(
              color: capacityColor.withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      _getCapacityIcon(result.capacityString),
                      size: 64,
                      color: capacityColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Capacidad de Curación',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      result.capacityString.toUpperCase(),
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: capacityColor,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: capacityColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getCapacitySubtitle(result.capacityString),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Tarjeta de tratamiento recomendado
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.medical_services, color: capacityColor),
                        const SizedBox(width: 8),
                        Text(
                          'Tratamiento Recomendado',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Text(
                      result.treatment,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Objetivos según capacidad
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.flag, color: AppTheme.primaryKura),
                        const SizedBox(width: 8),
                        Text(
                          'Objetivo del Tratamiento',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Text(
                      _getObjective(result.capacityString),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.home),
                    label: const Text('Volver al Inicio'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Guardar en historial
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Guardado en historial')),
                      );
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Guardar'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Nota informativa
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info, color: Colors.blue[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Este resultado es una herramienta de apoyo clínico. '
                      'La decisión final sobre el tratamiento debe ser tomada '
                      'por un profesional de la salud cualificado.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[900],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCapacityIcon(String capacity) {
    switch (capacity.toLowerCase()) {
      case 'curable':
        return Icons.check_circle;
      case 'mantenimiento':
        return Icons.healing;
      case 'no curable':
        return Icons.favorite;
      default:
        return Icons.help;
    }
  }

  String _getCapacitySubtitle(String capacity) {
    switch (capacity.toLowerCase()) {
      case 'curable':
        return 'Pronóstico Favorable';
      case 'mantenimiento':
        return 'Control y Seguimiento';
      case 'no curable':
        return 'Cuidados Paliativos';
      default:
        return '';
    }
  }

  String _getObjective(String capacity) {
    switch (capacity.toLowerCase()) {
      case 'curable':
        return 'Curación completa de la herida. Se espera cierre total con '
               'tratamiento adecuado y seguimiento periódico.';
      case 'mantenimiento':
        return 'Evitar deterioro y controlar síntomas. Prevención de complicaciones '
               'mediante cuidados continuos.';
      case 'no curable':
        return 'Proporcionar confort al paciente. Enfoque en calidad de vida '
               'y manejo de síntomas.';
      default:
        return 'Consulte con el especialista para determinar objetivos específicos.';
    }
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
