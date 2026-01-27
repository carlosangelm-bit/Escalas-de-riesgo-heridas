import 'package:hive/hive.dart';

// part 'assessment.g.dart'; // Comentado temporalmente - se generará con build_runner

/// Modelo base para evaluaciones
// @HiveType(typeId: 0) // Comentado temporalmente
class Assessment extends HiveObject {
  // @HiveField(0)
  String id;

  // @HiveField(1)
  String patientId;

  // @HiveField(2)
  String patientName;

  // @HiveField(3)
  DateTime date;

  // @HiveField(4)
  String type; // 'pressure_injury' o 'surgical_infection'

  // @HiveField(5)
  String scale; // Nombre de la escala utilizada

  // @HiveField(6)
  int totalScore;

  // @HiveField(7)
  String riskLevel; // 'sin_riesgo', 'bajo', 'moderado', 'alto', 'muy_alto'

  // @HiveField(8)
  Map<String, dynamic> answers; // Respuestas de la evaluación

  // @HiveField(9)
  String? notes;

  Assessment({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.date,
    required this.type,
    required this.scale,
    required this.totalScore,
    required this.riskLevel,
    required this.answers,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'patientName': patientName,
      'date': date.toIso8601String(),
      'type': type,
      'scale': scale,
      'totalScore': totalScore,
      'riskLevel': riskLevel,
      'answers': answers,
      'notes': notes,
    };
  }

  factory Assessment.fromJson(Map<String, dynamic> json) {
    return Assessment(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      patientName: json['patientName'] as String,
      date: DateTime.parse(json['date'] as String),
      type: json['type'] as String,
      scale: json['scale'] as String,
      totalScore: json['totalScore'] as int,
      riskLevel: json['riskLevel'] as String,
      answers: Map<String, dynamic>.from(json['answers'] as Map),
      notes: json['notes'] as String?,
    );
  }
}
