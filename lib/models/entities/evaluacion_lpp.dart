import 'package:cloud_firestore/cloud_firestore.dart';
import '../escala_kura_lpp.dart';

/// Modelo de entidad Evaluación LPP para Firestore
class EvaluacionLPP {
  final String id;
  final String pacienteId;
  final String nombrePaciente;
  final int edadPaciente;
  final String? diagnostico;
  final DateTime fechaEvaluacion;
  final EscalaKuraLpp escala;
  final String usuarioId;
  final String? pdfUrl;
  
  EvaluacionLPP({
    required this.id,
    required this.pacienteId,
    required this.nombrePaciente,
    required this.edadPaciente,
    this.diagnostico,
    required this.fechaEvaluacion,
    required this.escala,
    required this.usuarioId,
    this.pdfUrl,
  });
  
  /// Convertir a Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'pacienteId': pacienteId,
      'nombrePaciente': nombrePaciente,
      'edadPaciente': edadPaciente,
      'diagnostico': diagnostico,
      'fechaEvaluacion': Timestamp.fromDate(fechaEvaluacion),
      'usuarioId': usuarioId,
      'pdfUrl': pdfUrl,
      // Guardar todos los datos de la escala
      'escala': escala.toJson(),
      // Campos calculados para consultas fáciles
      'puntajeTotal': escala.puntajeTotal,
      'categoria': escala.categoria,
      'dominioNutricion': escala.dominioNutricion,
      'dominioPerfusion': escala.dominioPerfusion,
      'dominioHerida': escala.dominioHerida,
      'dominioPresion': escala.dominioPresion,
      'dominioClinico': escala.dominioClinico,
    };
  }
  
  /// Crear desde Map de Firestore
  factory EvaluacionLPP.fromMap(String id, Map<String, dynamic> map) {
    return EvaluacionLPP(
      id: id,
      pacienteId: map['pacienteId'] as String? ?? '',
      nombrePaciente: map['nombrePaciente'] as String? ?? '',
      edadPaciente: map['edadPaciente'] as int? ?? 0,
      diagnostico: map['diagnostico'] as String?,
      fechaEvaluacion: (map['fechaEvaluacion'] as Timestamp?)?.toDate() ?? DateTime.now(),
      escala: EscalaKuraLpp.fromJson(map['escala'] as Map<String, dynamic>? ?? {}),
      usuarioId: map['usuarioId'] as String? ?? '',
      pdfUrl: map['pdfUrl'] as String?,
    );
  }
  
  /// Copiar con modificaciones
  EvaluacionLPP copyWith({
    String? pdfUrl,
  }) {
    return EvaluacionLPP(
      id: id,
      pacienteId: pacienteId,
      nombrePaciente: nombrePaciente,
      edadPaciente: edadPaciente,
      diagnostico: diagnostico,
      fechaEvaluacion: fechaEvaluacion,
      escala: escala,
      usuarioId: usuarioId,
      pdfUrl: pdfUrl ?? this.pdfUrl,
    );
  }
}
