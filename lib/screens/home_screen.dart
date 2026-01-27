import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import 'eligibility_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header con saludo
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Buenos días',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Dr. Profesional',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.person, color: Colors.white),
                            onPressed: () {
                              // Navegar a perfil
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Estadísticas rápidas
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                            icon: Icons.assessment,
                            label: 'Evaluaciones',
                            value: '0',
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.white30,
                          ),
                          _buildStatItem(
                            icon: Icons.people,
                            label: 'Pacientes',
                            value: '0',
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.white30,
                          ),
                          _buildStatItem(
                            icon: Icons.today,
                            label: 'Hoy',
                            value: '0',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Contenido principal con tarjetas
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      const Text(
                        'Selecciona tipo de evaluación',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Tarjeta Lesiones por Presión
                      _buildAssessmentCard(
                        context: context,
                        gradient: AppTheme.pressureInjuryGradient,
                        icon: Icons.airline_seat_flat,
                        title: 'Lesiones por Presión',
                        subtitle: 'Escalas: Braden, EVARUCI, Norton',
                        assessmentType: 'pressure_injury',
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Tarjeta Infección Quirúrgica
                      _buildAssessmentCard(
                        context: context,
                        gradient: AppTheme.surgicalInfectionGradient,
                        icon: Icons.medical_services,
                        title: 'Infección Quirúrgica',
                        subtitle: 'Escalas: NNIS, SENIC, RAC, CPIS',
                        assessmentType: 'surgical_infection',
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Sección de acceso rápido
                      const Text(
                        'Acceso rápido',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: _buildQuickAccessCard(
                              icon: Icons.history,
                              label: 'Historial',
                              onTap: () {
                                // Navegar a historial
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildQuickAccessCard(
                              icon: Icons.info_outline,
                              label: 'Guía de Escalas',
                              onTap: () {
                                _showScalesGuide(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
  
  Widget _buildAssessmentCard({
    required BuildContext context,
    required LinearGradient gradient,
    required IconData icon,
    required String title,
    required String subtitle,
    required String assessmentType,
  }) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EligibilityScreen(
                assessmentType: assessmentType,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildQuickAccessCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(icon, size: 32, color: AppTheme.primaryBase),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showScalesGuide(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Guía de Escalas'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Lesiones por Presión:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text('• Braden: Estándar de oro internacional'),
              Text('• EVARUCI: Específica para UCI'),
              Text('• Norton: Personas mayores ≥65 años'),
              SizedBox(height: 16),
              Text(
                'Infección Quirúrgica:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text('• NNIS: Pacientes quirúrgicos (ISQ)'),
              Text('• SENIC: Predictor de sepsis'),
              Text('• RAC: Riesgo general IAAS'),
              Text('• CPIS: Neumonía nosocomial'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
