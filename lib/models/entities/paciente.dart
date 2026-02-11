import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de entidad Paciente para Firestore
class Paciente {
  final String id;
  final String nombre;
  final int edad;
  final double? peso;
  final double? altura;
  final String? diagnostico;
  final DateTime fechaCreacion;
  final DateTime fechaActualizacion;
  final String usuarioId;
  
  Paciente({
    required this.id,
    required this.nombre,
    required this.edad,
    this.peso,
    this.altura,
    this.diagnostico,
    required this.fechaCreacion,
    required this.fechaActualizacion,
    required this.usuarioId,
  });
  
  /// Convertir a Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'edad': edad,
      'peso': peso,
      'altura': altura,
      'diagnostico': diagnostico,
      'fechaCreacion': Timestamp.fromDate(fechaCreacion),
      'fechaActualizacion': Timestamp.fromDate(fechaActualizacion),
      'usuarioId': usuarioId,
    };
  }
  
  /// Crear desde Map de Firestore
  factory Paciente.fromMap(String id, Map<String, dynamic> map) {
    return Paciente(
      id: id,
      nombre: map['nombre'] as String? ?? '',
      edad: map['edad'] as int? ?? 0,
      peso: map['peso'] as double?,
      altura: map['altura'] as double?,
      diagnostico: map['diagnostico'] as String?,
      fechaCreacion: (map['fechaCreacion'] as Timestamp?)?.toDate() ?? DateTime.now(),
      fechaActualizacion: (map['fechaActualizacion'] as Timestamp?)?.toDate() ?? DateTime.now(),
      usuarioId: map['usuarioId'] as String? ?? '',
    );
  }
  
  /// Copiar con modificaciones
  Paciente copyWith({
    String? nombre,
    int? edad,
    double? peso,
    double? altura,
    String? diagnostico,
    DateTime? fechaActualizacion,
  }) {
    return Paciente(
      id: id,
      nombre: nombre ?? this.nombre,
      edad: edad ?? this.edad,
      peso: peso ?? this.peso,
      altura: altura ?? this.altura,
      diagnostico: diagnostico ?? this.diagnostico,
      fechaCreacion: fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? DateTime.now(),
      usuarioId: usuarioId,
    );
  }
}
