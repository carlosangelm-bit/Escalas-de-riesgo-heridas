/// Modelo para evaluación de Lesiones por Presión (LPP)
class LppCriteria {
  // Comorbilidades
  bool hipertensionControlada = false;
  bool diabetesControlada = false;
  bool insuficienciaCardiaca = false;
  bool enfermedadRenalG1 = false;
  bool enfermedadRenalG2G3 = false;
  bool enfermedadRenalG3aG4 = false;
  bool inmunodepresion = false;
  
  // Estado Nutricional
  double? albumina;
  double? hemoglobina;
  double? proteinasTotales;
  double? hematocrito;
  
  // Factores Intrínsecos
  int? bradenScore;
  String movilidad = 'normal'; // 'limitada', 'forzada', 'inmovil'
  String incontinencia = 'ninguna'; // 'urinaria', 'fecal', 'ambas'
  double? imc;
  
  // Valoración de la herida
  double? tunelizacion;
  double? socavamiento;
  double? profundidadMaxima;
  double? tejidoSubcutaneo;
  double? exposicionHuesoTendon;
  double? tejidoNecrotico;
  double? fibrina;
  int? cronicidadMeses;
  
  // Datos de infección
  bool exudadoSeropurulento = false;
  bool eritema = false;
  bool calorLocal = false;
  bool olorFetido = false;
  bool cultivoPositivo = false;
  double? pcr;
  double? pct;
  double? vsg;
  bool biopsiaPrevia = false;
  
  LppCriteria();
  
  /// Calcula la capacidad de curación basada en los criterios
  String evaluateHealingCapacity() {
    int curablePoints = 0;
    int mantenimientoPoints = 0;
    int noCurablePoints = 0;
    
    // Evaluar Comorbilidades
    if (hipertensionControlada && diabetesControlada && enfermedadRenalG1) {
      curablePoints += 3;
    } else if ((hipertensionControlada || diabetesControlada) && 
               (enfermedadRenalG2G3 || insuficienciaCardiaca)) {
      mantenimientoPoints += 3;
    } else if (enfermedadRenalG3aG4 || inmunodepresion) {
      noCurablePoints += 3;
    }
    
    // Evaluar Estado Nutricional
    if (albumina != null && albumina! >= 3.5) {
      curablePoints += 2;
    } else if (albumina != null && albumina! >= 2.4 && albumina! < 3.5) {
      mantenimientoPoints += 2;
    } else if (albumina != null && albumina! < 2.4) {
      noCurablePoints += 2;
    }
    
    if (hemoglobina != null && hemoglobina! >= 13.8) {
      curablePoints += 2;
    } else if (hemoglobina != null && hemoglobina! >= 11.5) {
      mantenimientoPoints += 2;
    } else if (hemoglobina != null && hemoglobina! <= 7) {
      noCurablePoints += 2;
    }
    
    // Evaluar Factores Intrínsecos (Braden)
    if (bradenScore != null && bradenScore! >= 15 && bradenScore! <= 18) {
      curablePoints += 3;
    } else if (bradenScore != null && bradenScore! >= 10 && bradenScore! <= 13) {
      mantenimientoPoints += 3;
    } else if (bradenScore != null && bradenScore! <= 9) {
      noCurablePoints += 3;
    }
    
    // Evaluar profundidad y cronicidad
    if (profundidadMaxima != null && profundidadMaxima! < 7) {
      curablePoints += 2;
    } else if (profundidadMaxima != null && profundidadMaxima! >= 7) {
      mantenimientoPoints += 2;
    }
    
    if (cronicidadMeses != null && cronicidadMeses! <= 6) {
      curablePoints += 1;
    } else if (cronicidadMeses != null && cronicidadMeses! <= 12) {
      mantenimientoPoints += 1;
    } else if (cronicidadMeses != null && cronicidadMeses! > 36) {
      noCurablePoints += 2;
    }
    
    // Evaluar infección
    if (exudadoSeropurulento || eritema || calorLocal || olorFetido) {
      curablePoints -= 1;
    }
    
    if (cultivoPositivo && pcr != null && pcr! >= 3 && pcr! <= 10) {
      mantenimientoPoints += 2;
    }
    
    if (biopsiaPrevia && pcr != null && pcr! >= 10) {
      noCurablePoints += 3;
    }
    
    // Determinar resultado
    int maxPoints = [curablePoints, mantenimientoPoints, noCurablePoints]
        .reduce((a, b) => a > b ? a : b);
    
    if (maxPoints == curablePoints) {
      return 'Curable';
    } else if (maxPoints == mantenimientoPoints) {
      return 'Mantenimiento';
    } else {
      return 'No Curable';
    }
  }
  
  /// Obtiene el tratamiento recomendado según la capacidad de curación
  String getTreatment(String capacity) {
    switch (capacity) {
      case 'Curable':
        return 'Todos los desbridamientos. Apósitos antimicrobianos. '
               'Gestión de la humedad. Valoración del progreso.';
      case 'Mantenimiento':
        return 'Desbridamiento conservador. Control de la infección. '
               'Gestión de la humedad. Reevaluación continua.';
      case 'No Curable':
        return 'Desbridamiento autolítico. Apósitos para el control del olor. '
               'Gestión de la humedad. Sesiones de educación.';
      default:
        return 'Evaluación incompleta. Consulte con el especialista.';
    }
  }
  
  Map<String, dynamic> toJson() {
    return {
      'hipertensionControlada': hipertensionControlada,
      'diabetesControlada': diabetesControlada,
      'insuficienciaCardiaca': insuficienciaCardiaca,
      'enfermedadRenalG1': enfermedadRenalG1,
      'enfermedadRenalG2G3': enfermedadRenalG2G3,
      'enfermedadRenalG3aG4': enfermedadRenalG3aG4,
      'inmunodepresion': inmunodepresion,
      'albumina': albumina,
      'hemoglobina': hemoglobina,
      'proteinasTotales': proteinasTotales,
      'hematocrito': hematocrito,
      'bradenScore': bradenScore,
      'movilidad': movilidad,
      'incontinencia': incontinencia,
      'imc': imc,
      'tunelizacion': tunelizacion,
      'socavamiento': socavamiento,
      'profundidadMaxima': profundidadMaxima,
      'tejidoSubcutaneo': tejidoSubcutaneo,
      'exposicionHuesoTendon': exposicionHuesoTendon,
      'tejidoNecrotico': tejidoNecrotico,
      'fibrina': fibrina,
      'cronicidadMeses': cronicidadMeses,
      'exudadoSeropurulento': exudadoSeropurulento,
      'eritema': eritema,
      'calorLocal': calorLocal,
      'olorFetido': olorFetido,
      'cultivoPositivo': cultivoPositivo,
      'pcr': pcr,
      'pct': pct,
      'vsg': vsg,
      'biopsiaPrevia': biopsiaPrevia,
    };
  }
}
