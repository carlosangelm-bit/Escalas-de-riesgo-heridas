import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/entities/paciente.dart';

/// Servicio para gestionar pacientes en Firestore
class PacienteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'pacientes';
  
  /// Crear un nuevo paciente
  Future<String> crearPaciente(Paciente paciente) async {
    try {
      final docRef = await _firestore.collection(_collection).add(paciente.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Error al crear paciente: $e');
    }
  }
  
  /// Obtener un paciente por ID
  Future<Paciente?> obtenerPaciente(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists && doc.data() != null) {
        return Paciente.fromMap(doc.id, doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener paciente: $e');
    }
  }
  
  /// Obtener todos los pacientes de un usuario
  Future<List<Paciente>> obtenerPacientesPorUsuario(String usuarioId) async {
    try {
      final query = await _firestore
          .collection(_collection)
          .where('usuarioId', isEqualTo: usuarioId)
          .orderBy('fechaActualizacion', descending: true)
          .get();
      
      return query.docs
          .map((doc) => Paciente.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener pacientes: $e');
    }
  }
  
  /// Stream de pacientes en tiempo real
  Stream<List<Paciente>> streamPacientesPorUsuario(String usuarioId) {
    return _firestore
        .collection(_collection)
        .where('usuarioId', isEqualTo: usuarioId)
        .orderBy('fechaActualizacion', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Paciente.fromMap(doc.id, doc.data()))
            .toList());
  }
  
  /// Actualizar un paciente
  Future<void> actualizarPaciente(Paciente paciente) async {
    try {
      await _firestore.collection(_collection).doc(paciente.id).update(
        paciente.copyWith(fechaActualizacion: DateTime.now()).toMap(),
      );
    } catch (e) {
      throw Exception('Error al actualizar paciente: $e');
    }
  }
  
  /// Eliminar un paciente
  Future<void> eliminarPaciente(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Error al eliminar paciente: $e');
    }
  }
  
  /// Buscar pacientes por nombre
  Future<List<Paciente>> buscarPacientesPorNombre(String usuarioId, String nombre) async {
    try {
      final query = await _firestore
          .collection(_collection)
          .where('usuarioId', isEqualTo: usuarioId)
          .orderBy('nombre')
          .startAt([nombre.toLowerCase()])
          .endAt(['${nombre.toLowerCase()}\uf8ff'])
          .get();
      
      return query.docs
          .map((doc) => Paciente.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      // Si falla la búsqueda ordenada, obtener todos y filtrar en memoria
      final pacientes = await obtenerPacientesPorUsuario(usuarioId);
      return pacientes
          .where((p) => p.nombre.toLowerCase().contains(nombre.toLowerCase()))
          .toList();
    }
  }
}
