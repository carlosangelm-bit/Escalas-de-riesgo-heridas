// Modelos para escalas de riesgo de infección en sitio quirúrgico

  // Índice NNIS (National Nosocomial Infections Surveillance)
class NNISScale {
  static const String name = 'NNIS';
  
  // Criterios de elegibilidad
  static bool isApplicable(Map<String, String> eligibility) {
    // Aplicable para todos los pacientes quirúrgicos
    return eligibility['is_surgical'] == 'true';
  }

  static List<NNISParameter> getParameters() {
    return [
      NNISParameter(
        id: 'asa_classification',
        name: 'Clasificación ASA',
        description: 'Estado físico del paciente según American Society of Anesthesiologists',
        helpText: '''Seleccione la clasificación ASA del paciente. Esta evalúa el estado de salud general antes de la cirugía.

Pulse el botón "Ver Guía ASA Completa" para más detalles y ejemplos.''',
        options: [
          NNISOption(
            'ASA I o II (0 puntos)',
            0,
            '''• ASA I: Paciente SANO, sin alteraciones orgánicas, fisiológicas o psiquiátricas
  Ejemplo: Persona joven sana para cirugía de hernia inguinal

• ASA II: Paciente con enfermedad sistémica LEVE sin limitaciones funcionales
  Ejemplos:
  - Hipertensión arterial controlada con medicamentos
  - Diabetes tipo 2 sin complicaciones
  - Obesidad (IMC 30-40)
  - Fumador activo sin EPOC
  - Embarazo sin complicaciones
  - Edad >70 años sin otras comorbilidades''',
          ),
          NNISOption(
            'ASA III, IV o V (1 punto)',
            1,
            '''• ASA III: Enfermedad sistémica GRAVE con limitación funcional
  Ejemplos:
  - Diabetes con complicaciones (nefropatía, retinopatía)
  - Hipertensión mal controlada
  - EPOC moderado-severo
  - Obesidad mórbida (IMC >40)
  - Insuficiencia renal crónica (sin diálisis)
  - Infarto al miocardio >6 meses

• ASA IV: Enfermedad sistémica GRAVE con amenaza CONSTANTE para la vida
  Ejemplos:
  - Infarto al miocardio reciente (<6 meses)
  - Insuficiencia cardíaca congestiva descompensada
  - Insuficiencia renal con diálisis
  - Sepsis activa
  - Politraumatismo grave

• ASA V: Paciente MORIBUNDO que no se espera sobreviva sin la cirugía
  Ejemplos:
  - Aneurisma aórtico roto
  - Traumatismo masivo con shock
  - Embolismo pulmonar masivo''',
          ),
        ],
      ),
      NNISParameter(
        id: 'wound_contamination',
        name: 'Contaminación de la Herida',
        description: 'Clasificación de la herida quirúrgica según grado de contaminación',
        helpText: '''Seleccione el tipo de herida quirúrgica según el grado de contaminación bacteriana esperado durante el procedimiento.''',
        options: [
          NNISOption(
            'Limpia (Clase I) - 0 puntos',
            0,
            '''Herida NO infectada, sin inflamación, sin apertura de tractos contaminados.

Características:
• Técnica aséptica perfecta
• Sin ruptura de esterilidad
• Sin entrada a tractos respiratorio, digestivo, genitourinario
• Cierre primario y drenaje cerrado si es necesario

Ejemplos:
✓ Cirugía de hernia (sin malla contaminada)
✓ Mastectomía
✓ Tiroidectomía
✓ Cirugía ortopédica electiva
✓ Cirugía vascular de arterias (bypass)
✓ Neurocirugía electiva''',
          ),
          NNISOption(
            'Limpia-Contaminada (Clase II) - 0 puntos',
            0,
            '''Apertura CONTROLADA de tractos con contaminación bacteriana mínima.

Características:
• Entrada controlada a tractos contaminados
• Sin contaminación inusual
• Sin ruptura importante de técnica aséptica

Ejemplos:
✓ Colecistectomía (vesícula no infectada)
✓ Apendicectomía (no perforada)
✓ Histerectomía vaginal
✓ Cirugía gástrica o intestinal electiva
✓ Cirugía de vías biliares
✓ Cesárea
✓ Cirugía orofaríngea''',
          ),
          NNISOption(
            'Contaminada (Clase III) o Sucia/Infectada (Clase IV) - 1 punto',
            1,
            '''CLASE III - CONTAMINADA:
Contaminación VISIBLE durante la cirugía

Características:
• Ruptura importante de técnica estéril
• Derrame importante de contenido gastrointestinal
• Herida traumática reciente (<4 horas)
• Entrada a tracto urinario o biliar infectado

Ejemplos:
✓ Cirugía de colon con derrame de contenido
✓ Apendicectomía con apéndice perforado
✓ Herida traumática reciente limpia
✓ Cirugía de vía biliar con bilis infectada


CLASE IV - SUCIA/INFECTADA:
Infección PREEXISTENTE o víscera perforada

Características:
• Pus presente en campo quirúrgico
• Víscera perforada con peritonitis
• Herida traumática antigua (>4 horas)
• Tejido desvitalizado
• Contaminación fecal

Ejemplos:
✓ Peritonitis fecal
✓ Absceso intraabdominal
✓ Víscera perforada (estómago, intestino)
✓ Herida traumática antigua o sucia
✓ Gangrena''',
          ),
        ],
      ),
      NNISParameter(
        id: 'surgery_duration',
        name: 'Duración de la Cirugía',
        description: 'Tiempo quirúrgico comparado con el percentil 75 del procedimiento específico',
        helpText: '''Compare la duración REAL de la cirugía con el tiempo estándar (percentil 75) para ese tipo de procedimiento específico.

El percentil 75 significa que el 75% de las cirugías de ese tipo se completan en ese tiempo o menos.

Pulse "Ver Tabla de Tiempos" para consultar duración estándar por procedimiento.''',
        options: [
          NNISOption(
            '≤ Percentil 75 (Duración Normal) - 0 puntos',
            0,
            '''La cirugía se completó en el tiempo ESPERADO o menos para ese tipo de procedimiento.

Esto indica:
• Procedimiento sin complicaciones técnicas importantes
• Tiempo quirúrgico dentro de lo esperado
• Menor exposición a contaminación

Ejemplo:
Si una colecistectomía laparoscópica tiene percentil 75 = 2 horas:
✓ Duración de 1.5 horas → SELECCIONAR ESTA OPCIÓN (0 puntos)
✓ Duración de 2 horas → SELECCIONAR ESTA OPCIÓN (0 puntos)
✗ Duración de 3 horas → Seleccionar opción siguiente (1 punto)''',
          ),
          NNISOption(
            '> Percentil 75 (Duración Prolongada) - 1 punto',
            1,
            '''La cirugía tomó MÁS tiempo del esperado para ese tipo de procedimiento.

Esto puede indicar:
• Complicaciones técnicas durante la cirugía
• Anatomía difícil o adherencias
• Mayor complejidad del procedimiento
• Mayor exposición a contaminación
• Mayor tiempo de anestesia

Ejemplo:
Si una colecistectomía laparoscópica tiene percentil 75 = 2 horas:
✓ Duración de 2.5 horas → SELECCIONAR ESTA OPCIÓN (1 punto)
✓ Duración de 3 horas → SELECCIONAR ESTA OPCIÓN (1 punto)

NOTA IMPORTANTE:
• Cada tipo de cirugía tiene su propio tiempo estándar
• Consulte la tabla de tiempos por procedimiento
• Si no conoce el percentil 75, use el tiempo promedio esperado para ese procedimiento en su institución''',
          ),
        ],
      ),
    ];
  }
  
  // Tabla de referencia de tiempos quirúrgicos (percentil 75)
  static Map<String, String> getSurgeryDurationReference() {
    return {
      'Colecistectomía laparoscópica': '2 horas',
      'Colecistectomía abierta': '3 horas',
      'Apendicectomía laparoscópica': '1.5 horas',
      'Apendicectomía abierta': '2 horas',
      'Hernioplastia inguinal': '1.5 horas',
      'Cesárea': '1.5 horas',
      'Histerectomía abdominal': '2.5 horas',
      'Colectomía': '4 horas',
      'Gastrectomía': '4.5 horas',
      'Bypass coronario': '5 horas',
      'Artroplastia de cadera': '2.5 horas',
      'Artroplastia de rodilla': '2.5 horas',
      'Mastectomía': '2 horas',
      'Tiroidectomía': '2 horas',
      'Laminectomía': '3 horas',
      'Nota': 'Estos son valores promedio. Consulte los datos específicos de su institución.',
    };
  }
  
  static String getASADetailedGuide() {
    return '''
GUÍA COMPLETA DE CLASIFICACIÓN ASA

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ASA I - PACIENTE SANO
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
• Sin enfermedad orgánica, fisiológica o psiquiátrica
• No fumador o fumador social
• Consumo mínimo de alcohol
• IMC < 30

Ejemplos típicos:
✓ Adulto joven sano para cirugía electiva
✓ Niño sano para amigdalectomía


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ASA II - ENFERMEDAD SISTÉMICA LEVE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
• Enfermedad leve SIN limitación funcional
• Fumador activo
• Bebedor social
• Embarazo
• Obesidad leve (IMC 30-35)
• DM o HTA bien controladas
• Enfermedad pulmonar leve

Ejemplos:
✓ HTA controlada con 1-2 medicamentos (PA <140/90)
✓ Diabetes tipo 2 sin complicaciones (HbA1c <7%)
✓ Asma leve controlada
✓ Paciente de 70 años sano
✓ Obesidad leve (IMC 30-35)


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ASA III - ENFERMEDAD SISTÉMICA GRAVE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
• Enfermedad grave CON limitación funcional sustancial
• Uno o más padecimientos moderados-severos

Ejemplos cardiovasculares:
✓ HTA mal controlada (PA >160/100)
✓ Angina estable, IAM >6 meses
✓ Insuficiencia cardíaca controlada
✓ Enfermedad valvular moderada
✓ Marcapasos o DAI

Ejemplos respiratorios:
✓ EPOC moderado-severo
✓ Asma mal controlada
✓ Dependencia de oxígeno

Ejemplos metabólicos:
✓ Diabetes con complicaciones (nefropatía, retinopatía)
✓ Obesidad mórbida (IMC >40)
✓ Insuficiencia renal (creatinina >2, sin diálisis)

Otros:
✓ Cirrosis Child A-B sin hipertensión portal
✓ Hepatitis activa
✓ Alcoholismo activo con dependencia
✓ Reducción capacidad funcional


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ASA IV - ENFERMEDAD CON AMENAZA VITAL
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
• Enfermedad sistémica GRAVE incapacitante
• Amenaza CONSTANTE para la vida
• No siempre relacionada con cirugía

Ejemplos cardiovasculares:
✓ IAM reciente (<6 meses)
✓ Insuficiencia cardíaca descompensada
✓ Arritmias graves
✓ Choque cardiogénico

Ejemplos respiratorios:
✓ Insuficiencia respiratoria aguda
✓ Dependencia de ventilador

Ejemplos renales:
✓ Insuficiencia renal con diálisis
✓ Uremia

Otros:
✓ Sepsis grave
✓ Coagulopatía severa
✓ Cirrosis Child C descompensada
✓ Politraumatismo grave


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ASA V - PACIENTE MORIBUNDO
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
• No se espera que sobreviva sin la operación
• No se espera que sobreviva >24 horas

Ejemplos:
✓ Aneurisma aórtico abdominal roto
✓ Traumatismo masivo con hemorragia descontrolada
✓ Hemorragia intracraneal con efecto de masa
✓ Isquemia intestinal con shock séptico
✓ Politraumatismo con shock hemorrágico
✓ Embolia pulmonar masiva


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ASA VI - MUERTE CEREBRAL (donante)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
• Paciente con muerte cerebral
• Para procuración de órganos


MODIFICADOR "E" (EMERGENCIA):
Agregar "E" si la cirugía es de EMERGENCIA
Ejemplo: ASA III-E

Una cirugía es de emergencia si:
• Retraso significativo aumenta amenaza vital
• Debe realizarse <6 horas del diagnóstico

Ejemplos ASA con "E":
✓ ASA II-E: Apendicitis en paciente sano
✓ ASA III-E: Colecistitis en diabético
✓ ASA IV-E: Perforación intestinal en paciente crítico
''';
  }

  static String interpretRisk(int score) {
    // Tasas de incidencia de ISQ según score
    if (score == 0) return 'muy_bajo'; // 1.1%
    if (score == 1) return 'bajo';     // 1.8%
    if (score == 2) return 'moderado'; // 2.8%
    return 'alto';                      // 5.3%
  }

  static String getRiskDescription(String riskLevel) {
    switch (riskLevel) {
      case 'muy_bajo':
        return 'Score 0: Incidencia de ISQ ~1.1%. Riesgo muy bajo.';
      case 'bajo':
        return 'Score 1: Incidencia de ISQ ~1.8%. Riesgo bajo.';
      case 'moderado':
        return 'Score 2: Incidencia de ISQ ~2.8%. Riesgo moderado.';
      case 'alto':
        return 'Score 3: Incidencia de ISQ ~5.3%. Riesgo alto. Vigilancia intensiva requerida.';
      default:
        return 'Nivel de riesgo desconocido';
    }
  }

  static String getASAExplanation(int asaLevel) {
    switch (asaLevel) {
      case 1:
        return 'ASA I: Paciente sano, sin enfermedad orgánica, fisiológica o psiquiátrica.';
      case 2:
        return 'ASA II: Paciente con enfermedad sistémica leve (ej: hipertensión controlada, diabetes sin complicaciones).';
      case 3:
        return 'ASA III: Paciente con enfermedad sistémica grave que limita actividad pero no es incapacitante.';
      case 4:
        return 'ASA IV: Paciente con enfermedad sistémica grave con amenaza constante para la vida.';
      case 5:
        return 'ASA V: Paciente moribundo que no se espera sobreviva sin la operación.';
      default:
        return 'Clasificación ASA desconocida';
    }
  }
}

class NNISParameter {
  final String id;
  final String name;
  final String description;
  final String? helpText;
  final List<NNISOption> options;

  NNISParameter({
    required this.id,
    required this.name,
    required this.description,
    this.helpText,
    required this.options,
  });
}

class NNISOption {
  final String text;
  final int points;
  final String explanation;

  NNISOption(this.text, this.points, this.explanation);
}

  // Índice SENIC (Study on the Efficacy of Nosocomial Infection Control)
class SENICScale {
  static const String name = 'SENIC';
  
  // Criterios de elegibilidad
  static bool isApplicable(Map<String, String> eligibility) {
    // Aplicable para todos los pacientes quirúrgicos
    return eligibility['is_surgical'] == 'true';
  }

  static List<SENICParameter> getParameters() {
    return [
      SENICParameter(
        id: 'abdominal_surgery',
        name: 'Cirugía Abdominal',
        description: 'Procedimiento involucra cavidad abdominal',
        options: [
          SENICOption('No', 0),
          SENICOption('Sí (procedimiento involucra cavidad abdominal)', 1),
        ],
      ),
      SENICParameter(
        id: 'surgery_duration',
        name: 'Duración de la Intervención',
        description: 'Tiempo quirúrgico',
        options: [
          SENICOption('≤2 horas', 0),
          SENICOption('>2 horas', 1),
        ],
      ),
      SENICParameter(
        id: 'discharge_diagnoses',
        name: 'Número de Diagnósticos al Alta',
        description: 'Cantidad de diagnósticos médicos',
        options: [
          SENICOption('≤3 diagnósticos', 0),
          SENICOption('>3 diagnósticos', 1),
        ],
      ),
      SENICParameter(
        id: 'wound_contamination',
        name: 'Contaminación de la Herida',
        description: 'Clasificación de la herida quirúrgica',
        options: [
          SENICOption('Limpia o Limpia-contaminada', 0),
          SENICOption('Contaminada o Sucia/Infectada', 1),
        ],
      ),
    ];
  }

  static String interpretRisk(int score) {
    if (score == 0) return 'minimo';
    if (score == 1) return 'bajo_moderado';
    if (score == 2) return 'moderado_alto';
    return 'alto';
  }

  static String getRiskDescription(String riskLevel) {
    switch (riskLevel) {
      case 'minimo':
        return '0 puntos: 88% de pacientes, riesgo mínimo de sepsis.';
      case 'bajo_moderado':
        return '1 punto: 11% de pacientes, riesgo bajo-moderado.';
      case 'moderado_alto':
        return '2 puntos: Riesgo moderado-alto.';
      case 'alto':
        return '≥3 puntos: Riesgo alto, aumento significativo de sepsis nosocomial (p<0.001). Vigilancia intensiva requerida.';
      default:
        return 'Nivel de riesgo desconocido';
    }
  }

  static String getComponentPredictiveValue() {
    return '''
Componentes más predictivos:
• Cirugía abdominal: OR ajustada = 5.9 (IC 95%: 2.1-16.1)
• >3 diagnósticos: OR ajustada = 9.9 (IC 95%: 1.9-52.8)
''';
  }
}

class SENICParameter {
  final String id;
  final String name;
  final String description;
  final List<SENICOption> options;

  SENICParameter({
    required this.id,
    required this.name,
    required this.description,
    required this.options,
  });
}

class SENICOption {
  final String text;
  final int points;

  SENICOption(this.text, this.points);
}

  // Escala RAC (Rodríguez-Almeida-Cañon) - Riesgo de Infección en Adultos Hospitalizados
class RACScale {
  static const String name = 'RAC';
  
  // Criterios de elegibilidad
  static bool isApplicable(Map<String, String> eligibility) {
    // Aplicable para adultos hospitalizados (cualquier servicio)
    int? age = int.tryParse(eligibility['age'] ?? '0');
    return age != null && age >= 18;
  }

  // Nota: La escala completa RAC tiene múltiples ítems específicos
  // Por simplicidad, incluimos los factores principales
  static List<RACFactor> getMainFactors() {
    return [
      RACFactor(
        id: 'invasive_devices',
        name: 'Dispositivos Invasivos',
        description: 'Catéteres, sondas, ventilación mecánica',
        riskLevel: 'alto',
      ),
      RACFactor(
        id: 'immunosuppression',
        name: 'Inmunosupresión',
        description: 'Medicamentos inmunosupresores, enfermedades inmunes',
        riskLevel: 'alto',
      ),
      RACFactor(
        id: 'diabetes',
        name: 'Diabetes Mellitus',
        description: 'Diabetes mal controlada',
        riskLevel: 'moderado',
      ),
      RACFactor(
        id: 'malnutrition',
        name: 'Desnutrición',
        description: 'Estado nutricional deficiente',
        riskLevel: 'moderado',
      ),
      RACFactor(
        id: 'prolonged_stay',
        name: 'Estancia Prolongada',
        description: 'Hospitalización >7 días',
        riskLevel: 'moderado',
      ),
      RACFactor(
        id: 'recent_surgery',
        name: 'Cirugía Reciente',
        description: 'Procedimiento quirúrgico en últimos 30 días',
        riskLevel: 'moderado',
      ),
      RACFactor(
        id: 'antibiotic_therapy',
        name: 'Terapia Antibiótica Previa',
        description: 'Uso de antibióticos en últimas 2 semanas',
        riskLevel: 'bajo',
      ),
      RACFactor(
        id: 'advanced_age',
        name: 'Edad Avanzada',
        description: '>65 años',
        riskLevel: 'bajo',
      ),
    ];
  }

  static String interpretRisk(int score) {
    if (score >= 22) return 'alto';
    if (score >= 12) return 'intermedio';
    return 'bajo';
  }

  static String getRiskDescription(String riskLevel) {
    switch (riskLevel) {
      case 'alto':
        return '≥22 puntos: Riesgo alto de IAAS. Requiere intervenciones preventivas intensivas y vigilancia estrecha.';
      case 'intermedio':
        return '12-21 puntos: Riesgo intermedio de IAAS. Implementar medidas preventivas específicas.';
      case 'bajo':
        return '4-11 puntos: Riesgo bajo de IAAS. Mantener medidas preventivas estándar.';
      default:
        return 'Nivel de riesgo desconocido';
    }
  }
}

class RACFactor {
  final String id;
  final String name;
  final String description;
  final String riskLevel;

  RACFactor({
    required this.id,
    required this.name,
    required this.description,
    required this.riskLevel,
  });
}

  // Escala CPIS (Clinical Pulmonary Infection Score) - Neumonía Nosocomial
class CPISScale {
  static const String name = 'CPIS';
  
  // Criterios de elegibilidad
  static bool isApplicable(Map<String, String> eligibility) {
    // Aplicable para pacientes en ventilación mecánica con sospecha de NAVM
    return eligibility['mechanical_ventilation'] == 'true';
  }

  static List<CPISParameter> getParameters() {
    return [
      CPISParameter(
        id: 'temperature',
        name: 'Temperatura (°C)',
        description: 'Temperatura corporal',
        options: [
          CPISOption('36.5 - 38.4°C', 0),
          CPISOption('38.5 - 38.9°C', 1),
          CPISOption('<36.5°C o ≥39.0°C', 2),
        ],
      ),
      CPISParameter(
        id: 'leukocytes',
        name: 'Leucocitos (céls/mm³)',
        description: 'Recuento de glóbulos blancos',
        options: [
          CPISOption('4,000 - 11,000', 0),
          CPISOption('<4,000 o >11,000', 1),
          CPISOption('<4,000 o >11,000 + Bandas ≥50%', 2),
        ],
      ),
      CPISParameter(
        id: 'tracheal_secretions',
        name: 'Secreciones Traqueales',
        description: 'Características de las secreciones',
        options: [
          CPISOption('Ausentes o mínimas', 0),
          CPISOption('Presentes, no purulentas', 1),
          CPISOption('Presentes y purulentas', 2),
        ],
      ),
      CPISParameter(
        id: 'oxygenation',
        name: 'Oxigenación PaO₂/FiO₂ (mmHg)',
        description: 'Índice de oxigenación',
        options: [
          CPISOption('>240 o presencia de SDRA', 0),
          CPISOption('≤240 y sin SDRA', 2),
        ],
      ),
      CPISParameter(
        id: 'chest_xray',
        name: 'Radiografía de Tórax',
        description: 'Patrón radiológico',
        options: [
          CPISOption('Sin infiltrado', 0),
          CPISOption('Infiltrado difuso o parcheado', 1),
          CPISOption('Infiltrado localizado', 2),
        ],
      ),
      CPISParameter(
        id: 'tracheal_culture',
        name: 'Cultivo de Aspirado Traqueal',
        description: 'Resultado microbiológico',
        options: [
          CPISOption('Negativo o escaso crecimiento (<1+)', 0),
          CPISOption('Crecimiento moderado o abundante (≥1+)', 1),
          CPISOption('Misma bacteria en tinción Gram', 2),
        ],
      ),
    ];
  }

  static String interpretRisk(int score) {
    if (score >= 10) return 'grave';
    if (score >= 7) return 'moderado';
    if (score >= 6) return 'sospecha';
    return 'bajo';
  }

  static String getRiskDescription(String riskLevel) {
    switch (riskLevel) {
      case 'grave':
        return '≥10 puntos: Neumonía nosocomial grave. Considerar escalada antibiótica y manejo intensivo.';
      case 'moderado':
        return '7-9 puntos: Neumonía nosocomial moderada. Continuar antibioticoterapia y monitoreo.';
      case 'sospecha':
        return '≥6 puntos: Punto de corte para sospecha de NAVM. Iniciar protocolo de neumonía.';
      case 'bajo':
        return '<6 puntos: Bajo riesgo de infección pulmonar. Vigilar evolución clínica.';
      default:
        return 'Nivel de riesgo desconocido';
    }
  }

  static String getPerformanceMetrics() {
    return '''
Rendimiento diagnóstico:
• Sensibilidad: 69%
• Especificidad: 75%
• Permite diferenciar VAT de VAP con alta especificidad
''';
  }
}

class CPISParameter {
  final String id;
  final String name;
  final String description;
  final List<CPISOption> options;

  CPISParameter({
    required this.id,
    required this.name,
    required this.description,
    required this.options,
  });
}

class CPISOption {
  final String text;
  final int points;

  CPISOption(this.text, this.points);
}
