import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'escala_kura_lpp_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // AppBar minimalista con logo
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: AppTheme.surface,
              flexibleSpace: FlexibleSpaceBar(
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.primary, AppTheme.accent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.healing,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Wound Care Pro',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              ),
            ),
            
            // Contenido
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título de bienvenida
                    Text(
                      'Evaluación de\nHeridas',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Seleccione el tipo de evaluación que desea realizar',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 32),
                    
                    // Cards de evaluación
                    _ModernAssessmentCard(
                      title: 'Lesiones por Presión',
                      subtitle: 'Escala Kura+ LPP v2.0',
                      description: 'Sistema de 5 dominios para pronóstico de cierre',
                      icon: Icons.accessibility_new_rounded,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EscalaKuraLppScreen(),
                          ),
                        );
                      },
                    ),
                    
                    _ModernAssessmentCard(
                      title: 'Úlceras Pie Diabético',
                      subtitle: 'Evaluación UPD',
                      description: 'Próximamente disponible',
                      icon: Icons.monitor_heart_rounded,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF10B981), Color(0xFF059669)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      enabled: false,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Próximamente disponible'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                    
                    _ModernAssessmentCard(
                      title: 'Úlceras Venosas',
                      subtitle: 'Evaluación UV',
                      description: 'Próximamente disponible',
                      icon: Icons.favorite_rounded,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFEC4899), Color(0xFFDB2777)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      enabled: false,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Próximamente disponible'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                    
                    _ModernAssessmentCard(
                      title: 'Diagnóstico Integral',
                      subtitle: 'Sistema de Puntuación',
                      description: 'Próximamente disponible',
                      icon: Icons.assessment_rounded,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      enabled: false,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Próximamente disponible'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Info card minimalista
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.primary.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.info_outline_rounded,
                              color: AppTheme.primary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Información Importante',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppTheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Estas evaluaciones son herramientas de apoyo clínico. Siempre consulte con un profesional de la salud.',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.primaryDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          border: Border(
            top: BorderSide(
              color: AppTheme.neutral200,
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavBarItem(
                  icon: Icons.home_rounded,
                  label: 'Inicio',
                  isSelected: true,
                  onTap: () {},
                ),
                _NavBarItem(
                  icon: Icons.people_rounded,
                  label: 'Pacientes',
                  isSelected: false,
                  onTap: () {},
                ),
                _NavBarItem(
                  icon: Icons.assessment_rounded,
                  label: 'Evaluaciones',
                  isSelected: false,
                  onTap: () {},
                ),
                _NavBarItem(
                  icon: Icons.person_rounded,
                  label: 'Perfil',
                  isSelected: false,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModernAssessmentCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback onTap;
  final bool enabled;

  const _ModernAssessmentCard({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final opacity = enabled ? 1.0 : 0.5;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(20),
          child: Opacity(
            opacity: opacity,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.neutral200,
                  width: 1,
                ),
                boxShadow: enabled ? AppTheme.softShadow : [],
              ),
              child: Row(
                children: [
                  // Icono con gradiente
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: gradient,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Contenido
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        if (!enabled) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.neutral100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Próximamente',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppTheme.textTertiary,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  // Flecha
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: enabled ? AppTheme.textSecondary : AppTheme.textTertiary,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppTheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
