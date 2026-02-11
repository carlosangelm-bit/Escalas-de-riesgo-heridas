import 'package:flutter/material.dart';
import '../models/escala_kura_lpp.dart';

class EscalaKuraResultScreen extends StatelessWidget {
  final EscalaKuraLpp escala;
  final String nombrePaciente;
  final String edad;
  final String diagnosis;

  const EscalaKuraResultScreen({
    super.key,
    required this.escala,
    required this.nombrePaciente,
    required this.edad,
    required this.diagnosis,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoria = escala.categoria;
    final Color categoriaColor = _getCategoriaColor(categoria);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados - Escala Kura+'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Patient Info Card
              _buildPatientInfoCard(theme),
              
              const SizedBox(height: 24),
              
              // Main Score Card
              _buildMainScoreCard(categoria, categoriaColor),
              
              const SizedBox(height: 24),
              
              // Component Breakdown
              _buildComponentBreakdown(theme),
              
              const SizedBox(height: 24),
              
              // Clinical Interpretation
              _buildSection(
                'Interpretación Clínica',
                Icons.medical_information,
                escala.interpretacionClinica,
                theme,
              ),
              
              const SizedBox(height: 16),
              
              // Treatment Recommendations
              _buildSection(
                'Tratamiento Recomendado',
                Icons.medication_liquid,
                escala.tratamientoRecomendado,
                theme,
              ),
              
              const SizedBox(height: 24),
              
              // Action Buttons
              _buildActionButtons(context, theme),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildPatientInfoCard(ThemeData theme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                  child: Icon(
                    Icons.person,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nombrePaciente,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Edad: $edad años',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (diagnosis.isNotEmpty) ...[
              const Divider(height: 24),
              Text(
                'Diagnóstico',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                diagnosis,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildMainScoreCard(String categoria, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.1),
            color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        children: [
          Text(
            'PUNTAJE TOTAL',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${escala.puntajeTotal}',
            style: TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.bold,
              color: color,
              height: 1,
            ),
          ),
          Text(
            '/ 15 puntos',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              categoria.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildComponentBreakdown(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Desglose por Dominios',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildComponentBar('1. NUTRICIÓN', escala.dominioNutricion, 3, Colors.green),
        _buildComponentBar('2. PERFUSIÓN', escala.dominioPerfusion, 3, Colors.blue),
        _buildComponentBar('3. HERIDA', escala.dominioHerida, 3, Colors.red),
        _buildComponentBar('4. PRESIÓN', escala.dominioPresion, 3, Colors.orange),
        _buildComponentBar('5. CLÍNICO', escala.dominioClinico, 3, Colors.purple),
      ],
    );
  }
  
  Widget _buildComponentBar(String label, int score, int max, Color color) {
    final percentage = (score / max * 100).clamp(0, 100);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$score / $max',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 12,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSection(String title, IconData icon, String content, ThemeData theme) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildActionButtons(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement save functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Función de guardar próximamente'),
                ),
              );
            },
            icon: const Icon(Icons.save),
            label: const Text('Guardar Evaluación'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            icon: const Icon(Icons.home),
            label: const Text('Volver al Inicio'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Color _getCategoriaColor(String categoria) {
    switch (categoria) {
      case 'Favorable':
        return Colors.green;
      case 'Intermedio':
        return Colors.orange;
      case 'Desfavorable':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
