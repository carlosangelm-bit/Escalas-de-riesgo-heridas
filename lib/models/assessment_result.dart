/// Enum para los tipos de capacidad de curación
enum HealingCapacity {
  curable,
  mantenimiento,
  noCurable,
}

/// Clase para almacenar el resultado de una evaluación
class AssessmentResult {
  final String patientName;
  final String patientAge;
  final String weight;
  final String height;
  final String diagnosis;
  final DateTime assessmentDate;
  final String assessmentType; // 'LPP', 'UPD', 'UV', 'DXHX'
  
  final HealingCapacity capacity;
  final String treatment;
  final Map<String, dynamic> criteria; // Criterios evaluados
  final int? score; // Puntuación (para DXHX)
  
  AssessmentResult({
    required this.patientName,
    required this.patientAge,
    required this.weight,
    required this.height,
    required this.diagnosis,
    required this.assessmentDate,
    required this.assessmentType,
    required this.capacity,
    required this.treatment,
    required this.criteria,
    this.score,
  });
  
  String get capacityString {
    switch (capacity) {
      case HealingCapacity.curable:
        return 'Curable';
      case HealingCapacity.mantenimiento:
        return 'Mantenimiento';
      case HealingCapacity.noCurable:
        return 'No Curable';
    }
  }
  
  Map<String, dynamic> toJson() {
    return {
      'patientName': patientName,
      'patientAge': patientAge,
      'weight': weight,
      'height': height,
      'diagnosis': diagnosis,
      'assessmentDate': assessmentDate.toIso8601String(),
      'assessmentType': assessmentType,
      'capacity': capacity.index,
      'treatment': treatment,
      'criteria': criteria,
      'score': score,
    };
  }
  
  factory AssessmentResult.fromJson(Map<String, dynamic> json) {
    return AssessmentResult(
      patientName: json['patientName'] as String,
      patientAge: json['patientAge'] as String,
      weight: json['weight'] as String,
      height: json['height'] as String,
      diagnosis: json['diagnosis'] as String,
      assessmentDate: DateTime.parse(json['assessmentDate'] as String),
      assessmentType: json['assessmentType'] as String,
      capacity: HealingCapacity.values[json['capacity'] as int],
      treatment: json['treatment'] as String,
      criteria: json['criteria'] as Map<String, dynamic>,
      score: json['score'] as int?,
    );
  }
}
