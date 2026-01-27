// Preguntas de elegibilidad para determinar qué escala aplicar

class EligibilityQuestion {
  final String id;
  final String question;
  final List<EligibilityOption> options;
  final String? helpText;

  EligibilityQuestion({
    required this.id,
    required this.question,
    required this.options,
    this.helpText,
  });
}

class EligibilityOption {
  final String value;
  final String text;

  EligibilityOption({
    required this.value,
    required this.text,
  });
}

// Preguntas de elegibilidad para Lesiones por Presión
class PressureInjuryEligibility {
  static List<EligibilityQuestion> getQuestions() {
    return [
      EligibilityQuestion(
        id: 'setting',
        question: '¿En qué tipo de unidad se encuentra el paciente?',
        options: [
          EligibilityOption(
            value: 'icu',
            text: 'Unidad de Cuidados Intensivos (UCI)',
          ),
          EligibilityOption(
            value: 'acute_care',
            text: 'Hospitalización de agudos',
          ),
          EligibilityOption(
            value: 'intermediate_care',
            text: 'Media estancia / Cuidados intermedios',
          ),
          EligibilityOption(
            value: 'general',
            text: 'Otra unidad hospitalaria',
          ),
        ],
        helpText: 'Esto ayudará a seleccionar la escala más apropiada y el punto de corte adecuado.',
      ),
      EligibilityQuestion(
        id: 'age',
        question: '¿Cuál es la edad del paciente?',
        options: [
          EligibilityOption(value: '<65', text: 'Menor de 65 años'),
          EligibilityOption(value: '65-80', text: '65-80 años'),
          EligibilityOption(value: '>80', text: 'Mayor de 80 años'),
        ],
        helpText: 'La edad es importante para determinar si se aplica la escala de Norton (específica para mayores de 65 años).',
      ),
    ];
  }

  static String getRecommendedScale(Map<String, String> answers) {
    String setting = answers['setting'] ?? '';
    String ageGroup = answers['age'] ?? '';
    
    // UCI: Recomendar EVARUCI o Braden
    if (setting == 'icu') {
      return 'evaruci'; // Mayor especificidad en UCI
    }
    
    // Paciente geriátrico: Norton o Braden
    if (ageGroup != '<65') {
      return 'norton'; // Específica para personas mayores
    }
    
    // Por defecto: Braden (estándar de oro)
    return 'braden';
  }

  static List<String> getAvailableScales(Map<String, String> answers) {
    List<String> scales = [];
    String setting = answers['setting'] ?? '';
    String ageGroup = answers['age'] ?? '';
    
    // Braden: aplicable en todos los casos
    scales.add('braden');
    
    // EVARUCI: solo UCI
    if (setting == 'icu') {
      scales.add('evaruci');
    }
    
    // Norton: pacientes ≥65 años
    if (ageGroup != '<65') {
      scales.add('norton');
    }
    
    return scales;
  }

  static String getScaleRecommendation(Map<String, String> answers) {
    String recommended = getRecommendedScale(answers);
    
    String recommendation = '';
    
    if (recommended == 'evaruci') {
      recommendation = '''
✅ Escala Recomendada: EVARUCI

Motivo: El paciente está en UCI. EVARUCI tiene mayor especificidad (85%) en cuidados intensivos y valora aspectos propios de UCI como sedación, ventilación mecánica y soporte hemodinámico.

Alternativa: Braden también puede utilizarse (punto de corte ≤12 en UCI).
''';
    } else if (recommended == 'norton') {
      recommendation = '''
✅ Escala Recomendada: Norton

Motivo: Escala específica para personas mayores (≥65 años). Validada en población geriátrica hospitalizada y en residencias.

Alternativa: Braden (estándar de oro internacional, punto de corte ≤18 para población general).
''';
    } else {
      recommendation = '''
✅ Escala Recomendada: Braden

Motivo: Estándar de oro internacional, más ampliamente validada. Definiciones operativas claras que reducen variabilidad entre evaluadores.

Punto de corte según unidad:
• Hospital de agudos: ≤16 puntos
• Media estancia: ≤18-19 puntos
• Población general: ≤18 puntos
''';
    }
    
    return recommendation;
  }
}

// Preguntas de elegibilidad para Infección en Sitio Quirúrgico
class SurgicalInfectionEligibility {
  static List<EligibilityQuestion> getQuestions() {
    return [
      EligibilityQuestion(
        id: 'is_surgical',
        question: '¿El paciente ha sido sometido a cirugía o está programado para cirugía?',
        options: [
          EligibilityOption(value: 'true', text: 'Sí'),
          EligibilityOption(value: 'false', text: 'No'),
        ],
        helpText: 'Las escalas NNIS y SENIC son específicas para pacientes quirúrgicos.',
      ),
      EligibilityQuestion(
        id: 'mechanical_ventilation',
        question: '¿El paciente está en ventilación mecánica?',
        options: [
          EligibilityOption(value: 'true', text: 'Sí'),
          EligibilityOption(value: 'false', text: 'No'),
        ],
        helpText: 'La escala CPIS es específica para neumonía asociada a ventilación mecánica.',
      ),
      EligibilityQuestion(
        id: 'age',
        question: '¿Cuál es la edad del paciente?',
        options: [
          EligibilityOption(value: '<18', text: 'Menor de 18 años'),
          EligibilityOption(value: '18-65', text: '18-65 años'),
          EligibilityOption(value: '>65', text: 'Mayor de 65 años'),
        ],
        helpText: 'La escala RAC es aplicable para adultos hospitalizados (≥18 años).',
      ),
    ];
  }

  static String getRecommendedScale(Map<String, String> answers) {
    bool isSurgical = answers['is_surgical'] == 'true';
    bool mechanicalVentilation = answers['mechanical_ventilation'] == 'true';
    String ageGroup = answers['age'] ?? '';
    
    // Ventilación mecánica: CPIS (neumonía nosocomial)
    if (mechanicalVentilation) {
      return 'cpis';
    }
    
    // Paciente quirúrgico: NNIS o SENIC
    if (isSurgical) {
      return 'nnis'; // Más utilizado internacionalmente
    }
    
    // Adulto hospitalizado (riesgo general IAAS): RAC
    if (ageGroup != '<18') {
      return 'rac';
    }
    
    return 'nnis'; // Por defecto
  }

  static List<String> getAvailableScales(Map<String, String> answers) {
    List<String> scales = [];
    bool isSurgical = answers['is_surgical'] == 'true';
    bool mechanicalVentilation = answers['mechanical_ventilation'] == 'true';
    String ageGroup = answers['age'] ?? '';
    
    // NNIS y SENIC: pacientes quirúrgicos
    if (isSurgical) {
      scales.add('nnis');
      scales.add('senic');
    }
    
    // CPIS: ventilación mecánica
    if (mechanicalVentilation) {
      scales.add('cpis');
    }
    
    // RAC: adultos hospitalizados
    if (ageGroup != '<18') {
      scales.add('rac');
    }
    
    return scales;
  }

  static String getScaleRecommendation(Map<String, String> answers) {
    String recommended = getRecommendedScale(answers);
    
    String recommendation = '';
    
    if (recommended == 'cpis') {
      recommendation = '''
✅ Escala Recomendada: CPIS (Clinical Pulmonary Infection Score)

Motivo: El paciente está en ventilación mecánica. CPIS es específica para sospecha de neumonía asociada a ventilación mecánica (NAVM).

Rendimiento:
• Sensibilidad: 69%
• Especificidad: 75%
• Punto de corte ≥6 para sospecha de NAVM
''';
    } else if (recommended == 'senic') {
      recommendation = '''
✅ Escala Recomendada: SENIC

Motivo: Mejor capacidad predictiva de sepsis nosocomial que NNIS. Componentes más predictivos:
• Cirugía abdominal: OR 5.9
• >3 diagnósticos: OR 9.9

Alternativa: NNIS (más utilizado internacionalmente para comparación entre hospitales).
''';
    } else if (recommended == 'rac') {
      recommendation = '''
✅ Escala Recomendada: RAC (Rodríguez-Almeida-Cañon)

Motivo: Primera escala validada para riesgo general de IAAS en adultos hospitalizados (no limitada a ISQ). Aplicable en instituciones con recursos limitados.

Puntos de corte:
• 4-11 puntos: Riesgo bajo
• 12-21 puntos: Riesgo intermedio
• ≥22 puntos: Riesgo alto
''';
    } else { // NNIS
      recommendation = '''
✅ Escala Recomendada: NNIS

Motivo: Más utilizado internacionalmente para infección de sitio quirúrgico (ISQ). Permite comparación estandarizada entre hospitales.

Tasas de incidencia de ISQ:
• Score 0: 1.1%
• Score 1: 1.8%
• Score 2: 2.8%
• Score 3: 5.3%

Alternativa: SENIC (mejor predictor de sepsis).
''';
    }
    
    return recommendation;
  }
}
