import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de usuario
class AppUser {
  final String uid;
  final String email;
  final String? nombre;
  final DateTime fechaCreacion;
  
  AppUser({
    required this.uid,
    required this.email,
    this.nombre,
    required this.fechaCreacion,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'nombre': nombre,
      'fechaCreacion': Timestamp.fromDate(fechaCreacion),
    };
  }
  
  factory AppUser.fromMap(String uid, Map<String, dynamic> map) {
    return AppUser(
      uid: uid,
      email: map['email'] as String? ?? '',
      nombre: map['nombre'] as String?,
      fechaCreacion: (map['fechaCreacion'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

/// Servicio de autenticación con Firebase Auth
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  /// Usuario actual
  User? get currentUser => _auth.currentUser;
  
  /// Stream del estado de autenticación
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  /// Registrar nuevo usuario con email y contraseña
  Future<AppUser> registrarConEmail({
    required String email,
    required String password,
    String? nombre,
  }) async {
    try {
      // Crear usuario en Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final user = userCredential.user;
      if (user == null) {
        throw Exception('No se pudo crear el usuario');
      }
      
      // Actualizar nombre de perfil si se proporcionó
      if (nombre != null && nombre.isNotEmpty) {
        await user.updateDisplayName(nombre);
      }
      
      // Crear documento de usuario en Firestore
      final appUser = AppUser(
        uid: user.uid,
        email: email,
        nombre: nombre,
        fechaCreacion: DateTime.now(),
      );
      
      await _firestore.collection('usuarios').doc(user.uid).set(appUser.toMap());
      
      // Enviar email de verificación
      await user.sendEmailVerification();
      
      return appUser;
    } on FirebaseAuthException catch (e) {
      throw _manejarErrorAuth(e);
    } catch (e) {
      throw Exception('Error al registrar usuario: $e');
    }
  }
  
  /// Iniciar sesión con email y contraseña
  Future<AppUser> iniciarSesionConEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final user = userCredential.user;
      if (user == null) {
        throw Exception('No se pudo iniciar sesión');
      }
      
      // Obtener datos del usuario de Firestore
      final doc = await _firestore.collection('usuarios').doc(user.uid).get();
      
      if (doc.exists && doc.data() != null) {
        return AppUser.fromMap(user.uid, doc.data()!);
      } else {
        // Si no existe en Firestore, crear documento
        final appUser = AppUser(
          uid: user.uid,
          email: email,
          nombre: user.displayName,
          fechaCreacion: DateTime.now(),
        );
        await _firestore.collection('usuarios').doc(user.uid).set(appUser.toMap());
        return appUser;
      }
    } on FirebaseAuthException catch (e) {
      throw _manejarErrorAuth(e);
    } catch (e) {
      throw Exception('Error al iniciar sesión: $e');
    }
  }
  
  /// Cerrar sesión
  Future<void> cerrarSesion() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Error al cerrar sesión: $e');
    }
  }
  
  /// Recuperar contraseña
  Future<void> recuperarContrasena(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _manejarErrorAuth(e);
    } catch (e) {
      throw Exception('Error al enviar email de recuperación: $e');
    }
  }
  
  /// Actualizar perfil de usuario
  Future<void> actualizarPerfil({
    String? nombre,
    String? photoUrl,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No hay usuario autenticado');
      }
      
      if (nombre != null) {
        await user.updateDisplayName(nombre);
      }
      
      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl);
      }
      
      // Actualizar en Firestore
      final updates = <String, dynamic>{};
      if (nombre != null) {
        updates['nombre'] = nombre;
      }
      
      if (updates.isNotEmpty) {
        await _firestore.collection('usuarios').doc(user.uid).update(updates);
      }
    } catch (e) {
      throw Exception('Error al actualizar perfil: $e');
    }
  }
  
  /// Reenviar email de verificación
  Future<void> reenviarEmailVerificacion() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No hay usuario autenticado');
      }
      
      await user.sendEmailVerification();
    } catch (e) {
      throw Exception('Error al enviar email de verificación: $e');
    }
  }
  
  /// Verificar si el email está verificado
  bool get emailVerificado => _auth.currentUser?.emailVerified ?? false;
  
  /// Recargar datos del usuario
  Future<void> recargarUsuario() async {
    await _auth.currentUser?.reload();
  }
  
  /// Manejar errores de Firebase Auth
  String _manejarErrorAuth(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'La contraseña es muy débil. Usa al menos 6 caracteres.';
      case 'email-already-in-use':
        return 'Ya existe una cuenta con este email.';
      case 'invalid-email':
        return 'El email no es válido.';
      case 'user-disabled':
        return 'Esta cuenta ha sido deshabilitada.';
      case 'user-not-found':
        return 'No existe una cuenta con este email.';
      case 'wrong-password':
        return 'Contraseña incorrecta.';
      case 'too-many-requests':
        return 'Demasiados intentos. Intenta más tarde.';
      case 'network-request-failed':
        return 'Error de red. Verifica tu conexión.';
      default:
        return 'Error de autenticación: ${e.message ?? e.code}';
    }
  }
}
