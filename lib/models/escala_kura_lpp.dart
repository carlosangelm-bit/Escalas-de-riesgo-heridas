/// Escala Kura+ de Pronóstico de Cierre en LPP (EKP-LPP) - Versión 2.0
/// Sistema de 5 dominios (0-15 puntos total)
/// Regla: Por dominio, usar el PEOR puntaje entre sus parámetros
class EscalaKuraLpp {
  
  // ========================================
  // DOMINIO 1: NUTRICIÓN (0-3 puntos)
  // ========================================
  
  // Laboratorios
  double? albuminaSerica; // g/dL
  double? prealbumina; // mg/dL (opcional)
  double? proteinasTotales; // g/dL (opcional)
  
  // Historia clínica
  double? perdidaPesoInvoluntaria; // % últimos 30 días
  double? ingestaProteica; // g/kg/día
  
  // ========================================
  // DOMINIO 2: PERFUSIÓN (0-3 puntos)
  // ========================================
  
  // Pruebas vasculares
  double? indiceTobilloBrazo; // ITB/ABI ratio
  double? tcpo2Perilesional; // mmHg (opcional)
  
  // Exploración física
  String? llenadoCapilar; // 'Normal', 'Leve', 'Moderada', 'Severa'
  String? edemaPeriferico; // '0', '+1', '+2', '+3/+4'
  
  // ========================================
  // DOMINIO 3: HERIDA (0-3 puntos)
  // ========================================
  
  // Evaluación del lecho
  int? cronicidadMeses; // 0-18 meses
  double? porcentajeGranulacion; // 0-100%
  double? porcentajeFibrina; // 0-100%
  bool necrosisPresente = false;
  
  // Exudado
  double? exudadoSeroHematico; // 0-100%
  double? exudadoPurulento; // 0-100%
  double? exudadoSeroPurulento; // 0-100%
  
  // Infección
  bool infeccionAguda = false;
  String? infeccionCronica; // 'No', 'Biopelícula', 'Celulitis', 'Osteomielitis'
  
  // ========================================
  // DOMINIO 4: PRESIÓN (0-3 puntos)
  // ========================================
  
  // Plan de cuidados
  double? adherenciaAlivioPresion; // % cumplimiento (0-100)
  double? frecuenciaCambiosPosturales; // horas
  
  // Escala Braden (solo 2 subescalas)
  int bradenMovilidad = 4; // 1-4
  int bradenHumedad = 4; // 1-4
  
  // ========================================
  // DOMINIO 5: CLÍNICO (0-3 puntos)
  // ========================================
  
  // Laboratorios
  double? hba1c; // % (si DM)
  double? glucosa; // mg/dL (si no HbA1c)
  double? hemoglobina; // g/dL
  double? pcr; // mg/L (inflamación)
  
  // Historia clínica
  String? inmunosupresion; // 'No', 'Moderado', 'Alto'
  String? medicamentos; // 'No', 'Ocasional', 'Crónico', 'Múltiple'
  
  // Antecedentes LPP
  String? antecedentesLpp; // 'No', 'Estadio III', 'Estadio IV', 'Ambos'
  
  // Toxicomanías
  String? toxicomanias; // 'No', 'Alcoholismo', 'Tabaquismo', 'Ambas'
  
  // Comorbilidades
  String? comorbilidades; // 'No', 'Impacto menor', 'Impacto moderado', 'Alto impacto'
  
  // Función renal
  String? funcionRenal; // 'Normal', 'ERC G1', 'ERC G2-G3', 'ERC G3a-G4'
  
  EscalaKuraLpp();
  
  // ========================================
  // CÁLCULOS DE PUNTAJES POR PARÁMETRO
  // ========================================
  
  // NUTRICIÓN - Parámetros individuales
  
  int get puntajeAlbumina {
    if (albuminaSerica == null) return 0;
    if (albuminaSerica! >= 3.5) return 0;
    if (albuminaSerica! >= 3.0) return 1;
    if (albuminaSerica! >= 2.5) return 2;
    return 3;
  }
  
  int get puntajePrealbumina {
    if (prealbumina == null) return 0;
    if (prealbumina! >= 18) return 0;
    if (prealbumina! >= 15) return 1;
    if (prealbumina! >= 10) return 2;
    return 3;
  }
  
  int get puntajeProteinasTotales {
    if (proteinasTotales == null) return 0;
    if (proteinasTotales! >= 6.6) return 0;
    if (proteinasTotales! >= 6.0) return 1;
    if (proteinasTotales! >= 5.5) return 2;
    return 3;
  }
  
  int get puntajePerdidaPeso {
    if (perdidaPesoInvoluntaria == null) return 0;
    if (perdidaPesoInvoluntaria! < 5) return 0;
    if (perdidaPesoInvoluntaria! < 10) return 1;
    if (perdidaPesoInvoluntaria! < 15) return 2;
    return 3;
  }
  
  int get puntajeIngestaProteica {
    if (ingestaProteica == null) return 0;
    if (ingestaProteica! >= 1.2) return 0;
    if (ingestaProteica! >= 1.0) return 1;
    if (ingestaProteica! >= 0.8) return 2;
    return 3;
  }
  
  // PERFUSIÓN - Parámetros individuales
  
  int get puntajeITB {
    if (indiceTobilloBrazo == null) return 0;
    if (indiceTobilloBrazo! >= 0.9 && indiceTobilloBrazo! <= 1.3) return 0;
    if (indiceTobilloBrazo! >= 0.7) return 1;
    if (indiceTobilloBrazo! >= 0.5) return 2;
    return 3;
  }
  
  int get puntajeTcpo2 {
    if (tcpo2Perilesional == null) return 0;
    if (tcpo2Perilesional! >= 40) return 0;
    if (tcpo2Perilesional! >= 30) return 1;
    if (tcpo2Perilesional! >= 20) return 2;
    return 3;
  }
  
  int get puntajeLlenadoCapilar {
    switch (llenadoCapilar) {
      case 'Normal':
        return 0;
      case 'Leve':
        return 1;
      case 'Moderada':
        return 2;
      case 'Severa':
        return 3;
      default:
        return 0;
    }
  }
  
  int get puntajeEdema {
    switch (edemaPeriferico) {
      case '0':
        return 0;
      case '+1':
        return 1;
      case '+2':
        return 2;
      case '+3/+4':
        return 3;
      default:
        return 0;
    }
  }
  
  // HERIDA - Parámetros individuales
  
  int get puntajeCronicidad {
    if (cronicidadMeses == null) return 0;
    if (cronicidadMeses == 0) return 0;
    if (cronicidadMeses! <= 3) return 1;
    if (cronicidadMeses! <= 6) return 2;
    return 3; // 6-12 meses
  }
  
  int get puntajeGranulacion {
    if (porcentajeGranulacion == null) return 0;
    if (porcentajeGranulacion! >= 75) return 0;
    if (porcentajeGranulacion! >= 50) return 1;
    if (porcentajeGranulacion! >= 25) return 2;
    return 3;
  }
  
  int get puntajeFibrina {
    if (porcentajeFibrina == null) return 0;
    if (porcentajeFibrina! < 25) return 0;
    if (porcentajeFibrina! < 50) return 1;
    if (porcentajeFibrina! < 75) return 2;
    return 3;
  }
  
  int get puntajeNecrosis {
    return necrosisPresente ? 3 : 0;
  }
  
  int get puntajeExudadoSeroHematico {
    if (exudadoSeroHematico == null || exudadoSeroHematico == 0) return 0;
    if (exudadoSeroHematico! <= 30) return 1;
    if (exudadoSeroHematico! <= 60) return 2;
    return 3;
  }
  
  int get puntajeExudadoPurulento {
    if (exudadoPurulento == null || exudadoPurulento == 0) return 0;
    if (exudadoPurulento! <= 30) return 1;
    if (exudadoPurulento! <= 60) return 2;
    return 3;
  }
  
  int get puntajeExudadoSeroPurulento {
    if (exudadoSeroPurulento == null || exudadoSeroPurulento == 0) return 0;
    if (exudadoSeroPurulento! <= 30) return 1;
    if (exudadoSeroPurulento! <= 60) return 2;
    return 3;
  }
  
  int get puntajeInfeccionAguda {
    return infeccionAguda ? 3 : 0;
  }
  
  int get puntajeInfeccionCronica {
    switch (infeccionCronica) {
      case 'No':
        return 0;
      case 'Biopelícula':
        return 1;
      case 'Celulitis':
        return 2;
      case 'Osteomielitis':
        return 3;
      default:
        return 0;
    }
  }
  
  // PRESIÓN - Parámetros individuales
  
  int get puntajeAdherenciaAlivio {
    if (adherenciaAlivioPresion == null) return 0;
    if (adherenciaAlivioPresion! >= 80) return 0;
    if (adherenciaAlivioPresion! >= 60) return 1;
    if (adherenciaAlivioPresion! >= 40) return 2;
    return 3;
  }
  
  int get puntajeFrecuenciaCambios {
    if (frecuenciaCambiosPosturales == null) return 0;
    if (frecuenciaCambiosPosturales! <= 2) return 0;
    if (frecuenciaCambiosPosturales! <= 3) return 1;
    if (frecuenciaCambiosPosturales! <= 4) return 2;
    return 3;
  }
  
  int get puntajeBradenMovilidad {
    return 4 - bradenMovilidad; // Invertido: 1→3pts, 2→2pts, 3→1pt, 4→0pts
  }
  
  int get puntajeBradenHumedad {
    return 4 - bradenHumedad; // Invertido: 1→3pts, 2→2pts, 3→1pt, 4→0pts
  }
  
  // CLÍNICO - Parámetros individuales
  
  int get puntajeHbA1c {
    if (hba1c == null) return 0;
    if (hba1c! < 7.5) return 0;
    if (hba1c! < 8.5) return 1;
    if (hba1c! < 9.5) return 2;
    return 3;
  }
  
  int get puntajeGlucosa {
    if (glucosa == null) return 0;
    if (glucosa! >= 80 && glucosa! <= 180) return 0;
    if (glucosa! <= 220) return 1;
    if (glucosa! <= 260) return 2;
    return 3;
  }
  
  int get puntajeHemoglobina {
    if (hemoglobina == null) return 0;
    if (hemoglobina! >= 12) return 0;
    if (hemoglobina! >= 10) return 1;
    if (hemoglobina! >= 8) return 2;
    return 3;
  }
  
  int get puntajePCR {
    if (pcr == null) return 0;
    if (pcr! < 10) return 0;
    if (pcr! < 40) return 1;
    if (pcr! < 100) return 2;
    return 3;
  }
  
  int get puntajeInmunosupresion {
    switch (inmunosupresion) {
      case 'No':
        return 0;
      case 'Moderado':
        return 2;
      case 'Alto':
        return 3;
      default:
        return 0;
    }
  }
  
  int get puntajeMedicamentos {
    switch (medicamentos) {
      case 'No':
        return 0;
      case 'Ocasional':
        return 1;
      case 'Crónico':
        return 2;
      case 'Múltiple':
        return 3;
      default:
        return 0;
    }
  }
  
  int get puntajeAntecedentesLpp {
    switch (antecedentesLpp) {
      case 'No':
        return 0;
      case 'Estadio III':
        return 1;
      case 'Estadio IV':
        return 2;
      case 'Ambos':
        return 3;
      default:
        return 0;
    }
  }
  
  int get puntajeToxicomanias {
    switch (toxicomanias) {
      case 'No':
        return 0;
      case 'Alcoholismo':
        return 1;
      case 'Tabaquismo':
        return 2;
      case 'Ambas':
        return 3;
      default:
        return 0;
    }
  }
  
  int get puntajeComorbilidades {
    switch (comorbilidades) {
      case 'No':
        return 0;
      case 'Impacto menor':
        return 1;
      case 'Impacto moderado':
        return 2;
      case 'Alto impacto':
        return 3;
      default:
        return 0;
    }
  }
  
  int get puntajeFuncionRenal {
    switch (funcionRenal) {
      case 'Normal':
        return 0;
      case 'ERC G1':
        return 1;
      case 'ERC G2-G3':
        return 2;
      case 'ERC G3a-G4':
        return 3;
      default:
        return 0;
    }
  }
  
  // ========================================
  // PUNTAJES POR DOMINIO (REGLA: PEOR PUNTAJE)
  // ========================================
  
  /// DOMINIO 1: NUTRICIÓN (0-3)
  /// Regla: Usar el peor puntaje entre todos los parámetros
  int get dominioNutricion {
    final puntajes = [
      puntajeAlbumina,
      puntajePrealbumina,
      puntajeProteinasTotales,
      puntajePerdidaPeso,
      puntajeIngestaProteica,
    ];
    return puntajes.reduce((a, b) => a > b ? a : b);
  }
  
  /// DOMINIO 2: PERFUSIÓN (0-3)
  /// Regla: Usar el peor puntaje entre todos los parámetros
  int get dominioPerfusion {
    final puntajes = [
      puntajeITB,
      puntajeTcpo2,
      puntajeLlenadoCapilar,
      puntajeEdema,
    ];
    return puntajes.reduce((a, b) => a > b ? a : b);
  }
  
  /// DOMINIO 3: HERIDA (0-3)
  /// Regla: Usar el peor puntaje entre todos los parámetros
  int get dominioHerida {
    final puntajes = [
      puntajeCronicidad,
      puntajeGranulacion,
      puntajeFibrina,
      puntajeNecrosis,
      puntajeExudadoSeroHematico,
      puntajeExudadoPurulento,
      puntajeExudadoSeroPurulento,
      puntajeInfeccionAguda,
      puntajeInfeccionCronica,
    ];
    return puntajes.reduce((a, b) => a > b ? a : b);
  }
  
  /// DOMINIO 4: PRESIÓN (0-3)
  /// Regla: Usar el peor puntaje entre todos los parámetros
  int get dominioPresion {
    final puntajes = [
      puntajeAdherenciaAlivio,
      puntajeFrecuenciaCambios,
      puntajeBradenMovilidad,
      puntajeBradenHumedad,
    ];
    return puntajes.reduce((a, b) => a > b ? a : b);
  }
  
  /// DOMINIO 5: CLÍNICO (0-3)
  /// Regla: Usar el peor puntaje entre todos los parámetros
  int get dominioClinico {
    final puntajes = [
      hba1c != null ? puntajeHbA1c : puntajeGlucosa,
      puntajeHemoglobina,
      puntajePCR,
      puntajeInmunosupresion,
      puntajeMedicamentos,
      puntajeAntecedentesLpp,
      puntajeToxicomanias,
      puntajeComorbilidades,
      puntajeFuncionRenal,
    ];
    return puntajes.reduce((a, b) => a > b ? a : b);
  }
  
  // ========================================
  // PUNTAJE TOTAL Y CATEGORIZACIÓN
  // ========================================
  
  /// PUNTAJE TOTAL (0-15)
  int get puntajeTotal {
    return dominioNutricion +
           dominioPerfusion +
           dominioHerida +
           dominioPresion +
           dominioClinico;
  }
  
  /// CATEGORÍA según puntaje total
  String get categoria {
    final pts = puntajeTotal;
    if (pts <= 4) return 'Favorable';
    if (pts <= 9) return 'Intermedio';
    return 'Desfavorable';
  }
  
  /// Color de la categoría
  String get colorCategoria {
    final cat = categoria;
    if (cat == 'Favorable') return 'success'; // Verde
    if (cat == 'Intermedio') return 'warning'; // Naranja
    return 'error'; // Rojo
  }
  
  /// Interpretación clínica según categoría
  String get interpretacionClinica {
    final cat = categoria;
    if (cat == 'Favorable') {
      return 'PRONÓSTICO FAVORABLE:\n'
             'Alta probabilidad de cierre con manejo estándar adecuado. '
             'Los factores medidos sugieren que la lesión tiene buena capacidad '
             'de cicatrización. Continuar con el protocolo actual, mantener '
             'factores protectores y realizar seguimiento rutinario.';
    } else if (cat == 'Intermedio') {
      return 'PRONÓSTICO INTERMEDIO:\n'
             'Existen factores que pueden retrasar el cierre. Se requiere '
             'optimización de los dominios con peor puntaje. Reevaluar '
             'semanalmente y ajustar el plan de manejo. Considerar interconsulta '
             'con especialistas según el dominio afectado (nutrición, vascular, '
             'infectología, etc.).';
    } else {
      return 'PRONÓSTICO DESFAVORABLE:\n'
             'Múltiples factores adversos presentes. Cierre difícil sin '
             'intervención avanzada. Requiere valoración multidisciplinaria '
             'URGENTE. Considerar: manejo nutricional intensivo, evaluación '
             'vascular, tratamiento avanzado de infección, optimización de '
             'alivio de presión, y/o redefinir objetivos realistas de cuidado.';
    }
  }
  
  /// Tratamiento recomendado según categoría
  String get tratamientoRecomendado {
    final cat = categoria;
    if (cat == 'Favorable') {
      return 'MANEJO ESTÁNDAR:\n'
             '• Continuar plan actual de cuidados\n'
             '• Desbridamiento según protocolo\n'
             '• Apósitos apropiados para fase de cicatrización\n'
             '• Alivio de presión: mantener adherencia ≥80%\n'
             '• Soporte nutricional: proteínas ≥1.2 g/kg/día\n'
             '• Seguimiento semanal o bisemanal\n'
             '• Reevaluación con esta escala cada 7-14 días';
    } else if (cat == 'Intermedio') {
      return 'OPTIMIZACIÓN REQUERIDA:\n'
             '• Identificar dominios con puntaje ≥2 y actuar\n'
             '• Nutrición: interconsulta, suplementos, balance nitrogenado\n'
             '• Perfusión: doppler, evaluar revascularización si ITB <0.7\n'
             '• Herida: cultivos, desbridamiento agresivo, control de infección\n'
             '• Presión: superficies avanzadas, reforzar cambios posturales\n'
             '• Clínico: control metabólico estricto, tratar anemia/inflamación\n'
             '• Seguimiento cada 7 días\n'
             '• Reevaluación obligatoria en 2 semanas';
    } else {
      return 'INTERVENCIÓN MULTIDISCIPLINARIA:\n'
             '• Junta médica multidisciplinaria (heridas, nutrición, vascular, etc.)\n'
             '• Considerar hospitalización si ambulatorio no es suficiente\n'
             '• Valorar cirugía: desbridamiento quirúrgico, revascularización, colgajo\n'
             '• Manejo avanzado: presión negativa, factores de crecimiento, bioingeniería\n'
             '• Si no candidato quirúrgico: redefinir objetivos (paliativo/confort)\n'
             '• Control estricto de todos los dominios\n'
             '• Seguimiento intensivo cada 3-7 días\n'
             '• Reevaluación continua y ajuste de plan';
    }
  }
  
  Map<String, dynamic> toJson() {
    return {
      // Nutrición
      'albuminaSerica': albuminaSerica,
      'prealbumina': prealbumina,
      'proteinasTotales': proteinasTotales,
      'perdidaPesoInvoluntaria': perdidaPesoInvoluntaria,
      'ingestaProteica': ingestaProteica,
      
      // Perfusión
      'indiceTobilloBrazo': indiceTobilloBrazo,
      'tcpo2Perilesional': tcpo2Perilesional,
      'llenadoCapilar': llenadoCapilar,
      'edemaPeriferico': edemaPeriferico,
      
      // Herida
      'cronicidadMeses': cronicidadMeses,
      'porcentajeGranulacion': porcentajeGranulacion,
      'porcentajeFibrina': porcentajeFibrina,
      'necrosisPresente': necrosisPresente,
      'exudadoSeroHematico': exudadoSeroHematico,
      'exudadoPurulento': exudadoPurulento,
      'exudadoSeroPurulento': exudadoSeroPurulento,
      'infeccionAguda': infeccionAguda,
      'infeccionCronica': infeccionCronica,
      
      // Presión
      'adherenciaAlivioPresion': adherenciaAlivioPresion,
      'frecuenciaCambiosPosturales': frecuenciaCambiosPosturales,
      'bradenMovilidad': bradenMovilidad,
      'bradenHumedad': bradenHumedad,
      
      // Clínico
      'hba1c': hba1c,
      'glucosa': glucosa,
      'hemoglobina': hemoglobina,
      'pcr': pcr,
      'inmunosupresion': inmunosupresion,
      'medicamentos': medicamentos,
      'antecedentesLpp': antecedentesLpp,
      'toxicomanias': toxicomanias,
      'comorbilidades': comorbilidades,
      'funcionRenal': funcionRenal,
      
      // Puntajes calculados
      'dominioNutricion': dominioNutricion,
      'dominioPerfusion': dominioPerfusion,
      'dominioHerida': dominioHerida,
      'dominioPresion': dominioPresion,
      'dominioClinico': dominioClinico,
      'puntajeTotal': puntajeTotal,
      'categoria': categoria,
    };
  }
  
  /// Crear desde Map/JSON
  factory EscalaKuraLpp.fromJson(Map<String, dynamic> json) {
    final escala = EscalaKuraLpp();
    
    // Nutrición
    escala.albuminaSerica = json['albuminaSerica'] as double?;
    escala.prealbumina = json['prealbumina'] as double?;
    escala.proteinasTotales = json['proteinasTotales'] as double?;
    escala.perdidaPesoInvoluntaria = json['perdidaPesoInvoluntaria'] as double?;
    escala.ingestaProteica = json['ingestaProteica'] as double?;
    
    // Perfusión
    escala.indiceTobilloBrazo = json['indiceTobilloBrazo'] as double?;
    escala.tcpo2Perilesional = json['tcpo2Perilesional'] as double?;
    escala.llenadoCapilar = json['llenadoCapilar'] as String?;
    escala.edemaPeriferico = json['edemaPeriferico'] as String?;
    
    // Herida
    escala.cronicidadMeses = json['cronicidadMeses'] as int?;
    escala.porcentajeGranulacion = json['porcentajeGranulacion'] as double?;
    escala.porcentajeFibrina = json['porcentajeFibrina'] as double?;
    escala.necrosisPresente = json['necrosisPresente'] as bool? ?? false;
    escala.exudadoSeroHematico = json['exudadoSeroHematico'] as double?;
    escala.exudadoPurulento = json['exudadoPurulento'] as double?;
    escala.exudadoSeroPurulento = json['exudadoSeroPurulento'] as double?;
    escala.infeccionAguda = json['infeccionAguda'] as bool? ?? false;
    escala.infeccionCronica = json['infeccionCronica'] as String?;
    
    // Presión
    escala.adherenciaAlivioPresion = json['adherenciaAlivioPresion'] as double?;
    escala.frecuenciaCambiosPosturales = json['frecuenciaCambiosPosturales'] as double?;
    escala.bradenMovilidad = json['bradenMovilidad'] as int? ?? 4;
    escala.bradenHumedad = json['bradenHumedad'] as int? ?? 4;
    
    // Clínico
    escala.hba1c = json['hba1c'] as double?;
    escala.glucosa = json['glucosa'] as double?;
    escala.hemoglobina = json['hemoglobina'] as double?;
    escala.pcr = json['pcr'] as double?;
    escala.inmunosupresion = json['inmunosupresion'] as String?;
    escala.medicamentos = json['medicamentos'] as String?;
    escala.antecedentesLpp = json['antecedentesLpp'] as String?;
    escala.toxicomanias = json['toxicomanias'] as String?;
    escala.comorbilidades = json['comorbilidades'] as String?;
    escala.funcionRenal = json['funcionRenal'] as String?;
    
    return escala;
  }
}
