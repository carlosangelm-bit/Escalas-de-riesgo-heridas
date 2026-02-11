import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/entities/evaluacion_lpp.dart';

/// Servicio para gestionar evaluaciones LPP en Firestore
class EvaluacionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'evaluaciones_lpp';
  
  /// Crear una nueva evaluación
  Future<String> crearEvaluacion(EvaluacionLPP evaluacion) async {
    try {
      final docRef = await _firestore.collection(_collection).add(evaluacion.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Error al crear evaluación: $e');
    }
  }
  
  /// Obtener una evaluación por ID
  Future<EvaluacionLPP?> obtenerEvaluacion(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists && doc.data() != null) {
        return EvaluacionLPP.fromMap(doc.id, doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener evaluación: $e');
    }
  }
  
  /// Obtener todas las evaluaciones de un usuario
  Future<List<EvaluacionLPP>> obtenerEvaluacionesPorUsuario(String usuarioId) async {
    try {
      final query = await _firestore
          .collection(_collection)
          .where('usuarioId', isEqualTo: usuarioId)
          .orderBy('fechaEvaluacion', descending: true)
          .get();
      
      return query.docs
          .map((doc) => EvaluacionLPP.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener evaluaciones: $e');
    }
  }
  
  /// Obtener evaluaciones de un paciente específico
  Future<List<EvaluacionLPP>> obtenerEvaluacionesPorPaciente(String pacienteId) async {
    try {
      final query = await _firestore
          .collection(_collection)
          .where('pacienteId', isEqualTo: pacienteId)
          .orderBy('fechaEvaluacion', descending: true)
          .get();
      
      return query.docs
          .map((doc) => EvaluacionLPP.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener evaluaciones del paciente: $e');
    }
  }
  
  /// Stream de evaluaciones en tiempo real
  Stream<List<EvaluacionLPP>> streamEvaluacionesPorUsuario(String usuarioId) {
    return _firestore
        .collection(_collection)
        .where('usuarioId', isEqualTo: usuarioId)
        .orderBy('fechaEvaluacion', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => EvaluacionLPP.fromMap(doc.id, doc.data()))
            .toList());
  }
  
  /// Actualizar URL del PDF de una evaluación
  Future<void> actualizarPdfUrl(String evaluacionId, String pdfUrl) async {
    try {
      await _firestore.collection(_collection).doc(evaluacionId).update({
        'pdfUrl': pdfUrl,
      });
    } catch (e) {
      throw Exception('Error al actualizar PDF URL: $e');
    }
  }
  
  /// Eliminar una evaluación
  Future<void> eliminarEvaluacion(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Error al eliminar evaluación: $e');
    }
  }
  
  /// Obtener estadísticas de evaluaciones por categoría
  Future<Map<String, int>> obtenerEstadisticasPorCategoria(String usuarioId) async {
    try {
      final evaluaciones = await obtenerEvaluacionesPorUsuario(usuarioId);
      
      final stats = <String, int>{
        'Favorable': 0,
        'Intermedio': 0,
        'Desfavorable': 0,
      };
      
      for (final eval in evaluaciones) {
        final categoria = eval.escala.categoria;
        if (stats.containsKey(categoria)) {
          stats[categoria] = stats[categoria]! + 1;
        }
      }
      
      return stats;
    } catch (e) {
      throw Exception('Error al obtener estadísticas: $e');
    }
  }
  
  /// Obtener evaluaciones recientes (últimos N días)
  Future<List<EvaluacionLPP>> obtenerEvaluacionesRecientes(
    String usuarioId,
    int dias,
  ) async {
    try {
      final fechaLimite = DateTime.now().subtract(Duration(days: dias));
      
      final query = await _firestore
          .collection(_collection)
          .where('usuarioId', isEqualTo: usuarioId)
          .where('fechaEvaluacion', isGreaterThanOrEqualTo: Timestamp.fromDate(fechaLimite))
          .orderBy('fechaEvaluacion', descending: true)
          .get();
      
      return query.docs
          .map((doc) => EvaluacionLPP.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener evaluaciones recientes: $e');
    }
  }
}
