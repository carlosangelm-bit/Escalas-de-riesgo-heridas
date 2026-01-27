# 🏥 Medical Risk Analyzer

Plataforma profesional para evaluación de riesgos médicos en pacientes hospitalizados.

![Flutter](https://img.shields.io/badge/Flutter-3.35.4-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.9.2-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)

## 📋 Descripción

**Medical Risk Analyzer** es una aplicación Flutter diseñada para profesionales de la salud que permite evaluar de manera sistemática y basada en evidencia el riesgo de:

- 🛏️ **Lesiones por Presión** (Úlceras por presión)
- 💉 **Infección en Sitio Quirúrgico** (ISQ)

La aplicación implementa escalas clínicas validadas internacionalmente con sistema inteligente de recomendación de escalas según el perfil del paciente.

## ✨ Características Principales

### 🎯 Sistema Inteligente de Evaluación
- **Preguntas de elegibilidad** automáticas para determinar el perfil del paciente
- **Recomendación inteligente** de la escala más apropiada según criterios clínicos
- **Cálculo automático** de puntuación y nivel de riesgo
- **Interpretación clínica** basada en evidencia científica

### 📊 Escalas de Evaluación Implementadas

#### Lesiones por Presión:
1. **Escala de Braden** - Estándar de oro internacional (6-23 puntos)
2. **Escala EVARUCI** - Específica para UCI con factores adicionales
3. **Escala de Norton** - Específica para personas mayores ≥65 años

#### Infección Quirúrgica:
1. **Índice NNIS** - Más utilizado internacionalmente para ISQ
   - Incluye guía completa ASA I-V con ejemplos clínicos
   - Tabla de tiempos quirúrgicos por procedimiento
2. **Índice SENIC** - Mejor predictor de sepsis nosocomial
3. **Escala RAC** - Riesgo general de IAAS en adultos hospitalizados
4. **Escala CPIS** - Neumonía asociada a ventilación mecánica

### 🎨 Diseño Profesional
- **Paleta de colores** basada en #F43058 (rosa médico profesional)
- **Gradientes vibrantes** para diferenciación visual
- **Interfaz intuitiva** optimizada para uso clínico
- **Responsive design** para tablets y dispositivos móviles

### 📱 Funcionalidades
- ✅ Evaluación paso a paso con barra de progreso
- ✅ Explicaciones detalladas de cada parámetro
- ✅ Botones de ayuda interactivos con guías completas
- ✅ Resultados con interpretación clínica y recomendaciones
- ✅ Registro de fecha y hora de cada evaluación
- ✅ Identificación de paciente (nombre e ID)

## 🚀 Instalación y Configuración

### Requisitos Previos
- Flutter 3.35.4
- Dart 3.9.2
- Android SDK (para compilar APK)

### Instalación

```bash
# Clonar el repositorio
git clone https://github.com/TU_USUARIO/medical-risk-analyzer.git
cd medical-risk-analyzer

# Instalar dependencias
flutter pub get

# Ejecutar en modo web
flutter run -d chrome

# Compilar para Android
flutter build apk --release
```

## 📦 Dependencias

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  provider: 6.1.5+1          # State management
  hive: 2.2.3                # Local database
  hive_flutter: 1.1.0        # Hive Flutter integration
  intl: ^0.19.0              # Internationalization
```

## 🏗️ Estructura del Proyecto

```
lib/
├── main.dart                          # Punto de entrada
├── models/
│   ├── assessment.dart                # Modelo de evaluación
│   ├── eligibility_questions.dart     # Preguntas de elegibilidad
│   ├── pressure_injury_scales.dart    # Escalas de lesiones por presión
│   └── infection_scales.dart          # Escalas de infección
├── screens/
│   ├── home_screen.dart               # Pantalla principal
│   ├── eligibility_screen.dart        # Preguntas de elegibilidad
│   ├── scale_selection_screen.dart    # Selección de escala
│   ├── assessment_screen.dart         # Pantalla de evaluación
│   └── result_screen.dart             # Resultados con interpretación
├── utils/
│   └── app_theme.dart                 # Tema y colores de la app
└── widgets/                           # Widgets reutilizables
```

## 🎯 Uso

### 1. Inicio de Evaluación
- Seleccionar tipo de evaluación (Lesiones por Presión o Infección Quirúrgica)

### 2. Preguntas de Elegibilidad
- Responder preguntas sobre el perfil del paciente
- Sistema recomienda la escala más apropiada

### 3. Evaluación Clínica
- Ingresar datos del paciente (nombre e ID)
- Responder todos los parámetros de la escala
- Usar botones de ayuda para consultar guías

### 4. Resultados
- Ver nivel de riesgo calculado
- Leer interpretación clínica
- Revisar recomendaciones de intervención
- Fecha y hora de la evaluación

## 📚 Escalas Clínicas - Referencias

### Braden Scale
- Punto de corte: ≤16 (agudos), ≤18 (general)
- Sensibilidad: 70-90%, Especificidad: ~60%

### EVARUCI
- Punto de corte: ≥10 (alto riesgo)
- Especificidad en UCI: hasta 85%

### NNIS (National Nosocomial Infections Surveillance)
- Score 0: ISQ ~1.1%
- Score 3: ISQ ~5.3%

### CPIS (Clinical Pulmonary Infection Score)
- Punto de corte: ≥6 (sospecha NAVM)
- Sensibilidad: 69%, Especificidad: 75%

## 🎨 Paleta de Colores

- **Base Principal**: #F43058 (Rosa médico)
- **Rosa Claro**: #FF6B8A
- **Púrpura**: #B430F4
- **Verde (Bajo riesgo)**: #4CAF50
- **Naranja (Moderado)**: #FF9800

## 🔒 Consideraciones Clínicas

⚠️ **Importante**: 
- Las escalas son herramientas de apoyo, no sustituyen el juicio clínico
- Requieren reevaluación periódica según protocolo institucional
- Los puntos de corte pueden variar según el contexto clínico
- Siempre considerar el estado general del paciente

## 👨‍⚕️ Dirigido a

- Enfermeras y enfermeros
- Médicos internistas
- Personal de UCI
- Profesionales de cuidados intensivos
- Estudiantes de medicina y enfermería

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver archivo `LICENSE` para más detalles.

## 📧 Contacto

Para consultas o soporte técnico, por favor abrir un issue en GitHub.

---

**Desarrollado con ❤️ para mejorar la seguridad del paciente**

*Versión: 1.0.0*
