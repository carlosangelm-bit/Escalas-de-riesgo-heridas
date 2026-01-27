// Modelos para escalas de riesgo de lesión por presión

  // Escala de Braden
class BradenScale {
  static const String name = 'Braden';
  
  // Criterios de elegibilidad
  static bool isApplicable(Map<String, String> eligibility) {
    // Aplicable para pacientes hospitalizados en agudos, media estancia, UCI
    String setting = eligibility['setting'] ?? '';
    return ['acute_care', 'intermediate_care', 'icu', 'general'].contains(setting);
  }

  static int getCutoffPoint(Map<String, String> eligibility) {
    String setting = eligibility['setting'] ?? 'general';
    if (setting == 'acute_care') return 16;
    if (setting == 'intermediate_care') return 18;
    if (setting == 'icu') return 12;
    return 18; // Población general
  }

  // Parámetros de evaluación
  static List<BradenParameter> getParameters() {
    return [
      BradenParameter(
        id: 'sensory_perception',
        name: 'Percepción Sensorial',
        description: 'Capacidad para responder a molestias relacionadas con la presión',
        options: [
          BradenOption('Completamente limitada (no responde a estímulos dolorosos)', 1),
          BradenOption('Muy limitada (solo responde a estímulos dolorosos, no puede comunicar)', 2),
          BradenOption('Ligeramente limitada (responde a órdenes verbales pero no siempre comunica)', 3),
          BradenOption('Sin limitación (responde a órdenes verbales, sin déficit sensorial)', 4),
        ],
      ),
      BradenParameter(
        id: 'moisture',
        name: 'Humedad',
        description: 'Grado de exposición de la piel a la humedad',
        options: [
          BradenOption('Constantemente húmeda (piel siempre húmeda por transpiración, orina, etc.)', 1),
          BradenOption('Muy húmeda (piel frecuentemente pero no siempre húmeda)', 2),
          BradenOption('Ocasionalmente húmeda (piel ocasionalmente húmeda, cambio de ropa 1 vez/día)', 3),
          BradenOption('Raramente húmeda (piel generalmente seca, cambio ropa rutinario)', 4),
        ],
      ),
      BradenParameter(
        id: 'activity',
        name: 'Actividad',
        description: 'Grado de actividad física',
        options: [
          BradenOption('Encamado (confinado a la cama)', 1),
          BradenOption('En silla (capacidad para caminar severamente limitada o nula)', 2),
          BradenOption('Deambula ocasionalmente (camina ocasionalmente durante el día, distancias cortas)', 3),
          BradenOption('Deambula frecuentemente (camina fuera de la habitación al menos 2 veces/día)', 4),
        ],
      ),
      BradenParameter(
        id: 'mobility',
        name: 'Movilidad',
        description: 'Capacidad para cambiar y controlar la posición del cuerpo',
        options: [
          BradenOption('Completamente inmóvil (no puede hacer cambios en posición sin ayuda)', 1),
          BradenOption('Muy limitada (ocasionalmente cambio leve de posición cuerpo/extremidades)', 2),
          BradenOption('Ligeramente limitada (hace cambios frecuentes pero leves de posición)', 3),
          BradenOption('Sin limitaciones (hace cambios frecuentes e importantes sin ayuda)', 4),
        ],
      ),
      BradenParameter(
        id: 'nutrition',
        name: 'Nutrición',
        description: 'Patrón usual de consumo de alimentos',
        options: [
          BradenOption('Muy pobre (nunca completa la comida, raramente toma suplemento completo)', 1),
          BradenOption('Probablemente inadecuado (raramente completa comida, ingesta proteínas inadecuada)', 2),
          BradenOption('Adecuado (come más de la mitad de la comida, toma suplementos si se ofrecen)', 3),
          BradenOption('Excelente (come la mayor parte de cada comida, nunca rechaza comida)', 4),
        ],
      ),
      BradenParameter(
        id: 'friction_shear',
        name: 'Fricción y Roce',
        description: 'Problema de fricción y deslizamiento',
        options: [
          BradenOption('Problema (requiere asistencia moderada/máxima para moverse, deslizamiento frecuente)', 1),
          BradenOption('Problema potencial (se mueve débilmente, requiere asistencia mínima, deslizamiento ocasional)', 2),
          BradenOption('No existe problema aparente (se mueve independientemente en cama/silla)', 3),
        ],
      ),
    ];
  }

  static String interpretRisk(int score) {
    if (score <= 9) return 'muy_alto';
    if (score <= 12) return 'alto';
    if (score <= 14) return 'moderado';
    if (score <= 18) return 'bajo';
    return 'sin_riesgo';
  }

  static String getRiskDescription(String riskLevel) {
    switch (riskLevel) {
      case 'muy_alto':
        return '≤9 puntos: Riesgo muy alto. Requiere intervención inmediata y medidas preventivas intensivas.';
      case 'alto':
        return '10-12 puntos: Riesgo alto. Necesita plan de cuidados específico y monitoreo frecuente.';
      case 'moderado':
        return '13-14 puntos: Riesgo moderado. Implementar medidas preventivas básicas.';
      case 'bajo':
        return '15-18 puntos: Riesgo bajo/leve. Mantener vigilancia y medidas estándar.';
      case 'sin_riesgo':
        return '19-23 puntos: Sin riesgo aparente. Continuar con cuidados rutinarios.';
      default:
        return 'Nivel de riesgo desconocido';
    }
  }
}

class BradenParameter {
  final String id;
  final String name;
  final String description;
  final List<BradenOption> options;

  BradenParameter({
    required this.id,
    required this.name,
    required this.description,
    required this.options,
  });
}

class BradenOption {
  final String text;
  final int points;

  BradenOption(this.text, this.points);
}

  // Escala EVARUCI (Específica para UCI)
class EVARUCIScale {
  static const String name = 'EVARUCI';
  
  // Criterios de elegibilidad
  static bool isApplicable(Map<String, String> eligibility) {
    return eligibility['setting'] == 'icu';
  }

  static List<EVARUCIParameter> getParameters() {
    return [
      EVARUCIParameter(
        id: 'consciousness',
        name: 'Consciencia',
        description: 'Nivel de consciencia',
        options: [
          EVARUCIOption('Consciente y orientado', 0),
          EVARUCIOption('Consciente y desorientado', 1),
          EVARUCIOption('Sedado/analgesiado', 2),
          EVARUCIOption('Obnubilado/confuso', 3),
          EVARUCIOption('Coma', 4),
        ],
      ),
      EVARUCIParameter(
        id: 'hemodynamics',
        name: 'Hemodinámica',
        description: 'Estado hemodinámico',
        options: [
          EVARUCIOption('Estable sin apoyo vasoactivo', 0),
          EVARUCIOption('Hipotensión controlada con un solo fármaco vasoactivo', 1),
          EVARUCIOption('Hipotensión controlada con dos o más fármacos vasoactivos', 2),
          EVARUCIOption('Hipotensión no controlada con dos o más fármacos', 3),
          EVARUCIOption('Shock (requiere drogas vasoactivas a dosis elevadas)', 4),
        ],
      ),
      EVARUCIParameter(
        id: 'respiratory',
        name: 'Respiratorio',
        description: 'Función respiratoria',
        options: [
          EVARUCIOption('Respiración espontánea normal', 0),
          EVARUCIOption('Ventilación mecánica no invasiva/oxigenoterapia', 1),
          EVARUCIOption('Ventilación mecánica invasiva <48 horas', 2),
          EVARUCIOption('Ventilación mecánica invasiva 48h-7 días', 3),
          EVARUCIOption('Ventilación mecánica invasiva >7 días', 4),
        ],
      ),
      EVARUCIParameter(
        id: 'mobility',
        name: 'Movilidad',
        description: 'Capacidad de movimiento',
        options: [
          EVARUCIOption('Movilidad conservada', 0),
          EVARUCIOption('Movilidad ligeramente limitada', 1),
          EVARUCIOption('Movilidad muy limitada', 2),
          EVARUCIOption('Inmovilidad relativa', 3),
          EVARUCIOption('Inmovilidad absoluta', 4),
        ],
      ),
    ];
  }

  static List<EVARUCIAdditionalFactor> getAdditionalFactors() {
    return [
      EVARUCIAdditionalFactor('temperature', 'Temperatura >38.5°C', 0.5),
      EVARUCIAdditionalFactor('skin_moisture', 'Piel muy húmeda o muy seca', 0.5),
      EVARUCIAdditionalFactor('hypotension', 'Hipotensión arterial (TAS <90 mmHg)', 0.5),
      EVARUCIAdditionalFactor('prone_position', 'Posición en decúbito prono', 0.5),
    ];
  }

  static String interpretRisk(double score) {
    if (score >= 10) return 'alto';
    if (score >= 4) return 'minimo';
    return 'sin_riesgo';
  }

  static String getRiskDescription(String riskLevel) {
    switch (riskLevel) {
      case 'alto':
        return '≥10 puntos: Alto riesgo. Requiere intervenciones preventivas intensivas en UCI.';
      case 'minimo':
        return '4-9 puntos: Riesgo mínimo a moderado. Implementar medidas preventivas estándar.';
      case 'sin_riesgo':
        return '<4 puntos: Riesgo mínimo. Continuar con vigilancia habitual.';
      default:
        return 'Nivel de riesgo desconocido';
    }
  }
}

class EVARUCIParameter {
  final String id;
  final String name;
  final String description;
  final List<EVARUCIOption> options;

  EVARUCIParameter({
    required this.id,
    required this.name,
    required this.description,
    required this.options,
  });
}

class EVARUCIOption {
  final String text;
  final double points;

  EVARUCIOption(this.text, this.points);
}

class EVARUCIAdditionalFactor {
  final String id;
  final String description;
  final double points;

  EVARUCIAdditionalFactor(this.id, this.description, this.points);
}

  // Escala de Norton (Específica para personas mayores)
class NortonScale {
  static const String name = 'Norton';
  
  // Criterios de elegibilidad
  static bool isApplicable(Map<String, String> eligibility) {
    int? age = int.tryParse(eligibility['age'] ?? '0');
    return age != null && age >= 65;
  }

  static List<NortonParameter> getParameters() {
    return [
      NortonParameter(
        id: 'physical_condition',
        name: 'Condición Física',
        description: 'Estado general',
        options: [
          NortonOption('Muy malo', 1),
          NortonOption('Regular/Malo', 2),
          NortonOption('Débil', 3),
          NortonOption('Buena', 4),
        ],
      ),
      NortonParameter(
        id: 'mental_state',
        name: 'Estado Mental',
        description: 'Nivel de conciencia',
        options: [
          NortonOption('Estuporoso/Comatoso', 1),
          NortonOption('Confuso', 2),
          NortonOption('Apático', 3),
          NortonOption('Alerta', 4),
        ],
      ),
      NortonParameter(
        id: 'activity',
        name: 'Actividad',
        description: 'Grado de actividad',
        options: [
          NortonOption('Encamado', 1),
          NortonOption('Sentado (en silla de ruedas)', 2),
          NortonOption('Camina con ayuda', 3),
          NortonOption('Ambulante/Camina', 4),
        ],
      ),
      NortonParameter(
        id: 'mobility',
        name: 'Movilidad',
        description: 'Capacidad de movimiento',
        options: [
          NortonOption('Inmóvil', 1),
          NortonOption('Muy limitada', 2),
          NortonOption('Ligeramente limitada', 3),
          NortonOption('Completa/Total', 4),
        ],
      ),
      NortonParameter(
        id: 'incontinence',
        name: 'Incontinencia',
        description: 'Control de esfínteres',
        options: [
          NortonOption('Doble incontinencia (urinaria + fecal)', 1),
          NortonOption('Usualmente urinaria (o fecal)', 2),
          NortonOption('Ocasional', 3),
          NortonOption('No hay/Ninguna', 4),
        ],
      ),
    ];
  }

  static String interpretRisk(int score) {
    if (score <= 9) return 'muy_alto';
    if (score <= 12) return 'alto';
    if (score <= 14) return 'moderado';
    return 'bajo';
  }

  static String getRiskDescription(String riskLevel) {
    switch (riskLevel) {
      case 'muy_alto':
        return '5-9 puntos: Riesgo muy alto. Intervención inmediata requerida.';
      case 'alto':
        return '10-12 puntos: Riesgo alto. Plan de cuidados específico necesario.';
      case 'moderado':
        return '13-14 puntos: Riesgo medio/moderado. Implementar medidas preventivas.';
      case 'bajo':
        return '15-20 puntos: Riesgo mínimo o nulo. Continuar con cuidados estándar.';
      default:
        return 'Nivel de riesgo desconocido';
    }
  }
}

class NortonParameter {
  final String id;
  final String name;
  final String description;
  final List<NortonOption> options;

  NortonParameter({
    required this.id,
    required this.name,
    required this.description,
    required this.options,
  });
}

class NortonOption {
  final String text;
  final int points;

  NortonOption(this.text, this.points);
}
