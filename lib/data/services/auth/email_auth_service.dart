import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import 'auth_exception_handler.dart';

/// Servicio especializado para autenticación con email y contraseña
@injectable
class EmailAuthService {
  final FirebaseAuth _auth;
  final Logger _logger = Logger('EmailAuthService');

  EmailAuthService(this._auth);

  /// Iniciar sesión con email y contraseña
  Future<UserCredential> signInWithEmailAndPassword(
    String email, 
    String password,
  ) async {
    try {
      _logger.info('Intentando iniciar sesión con email: $email');
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      _logger.warning('Error al iniciar sesión con email: ${e.code}');
      throw AuthExceptionHandler.handleException(e);
    }
  }

  /// Registrar usuario con email y contraseña
  Future<UserCredential> createUserWithEmailAndPassword(
    String email, 
    String password,
  ) async {
    try {
      _logger.info('Intentando registrar usuario con email: $email');
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Enviar email de verificación automáticamente
      await credential.user?.sendEmailVerification();
      _logger.info('Email de verificación enviado a: $email');
      
      return credential;
    } on FirebaseAuthException catch (e) {
      _logger.warning('Error al registrar usuario con email: ${e.code}');
      throw AuthExceptionHandler.handleException(e);
    }
  }

  /// Enviar email para restablecer contraseña
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      _logger.info('Enviando email de recuperación de contraseña a: $email');
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      _logger.warning('Error al enviar email de recuperación: ${e.code}');
      throw AuthExceptionHandler.handleException(e);
    }
  }

  /// Enviar email de verificación al usuario actual
  Future<void> sendEmailVerification() async {
    try {
      _logger.info('Enviando email de verificación al usuario actual');
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      _logger.warning('Error al enviar email de verificación: ${e.code}');
      throw AuthExceptionHandler.handleException(e);
    }
  }

  /// Verificar si el email del usuario está verificado
  bool isEmailVerified() {
    return _auth.currentUser?.emailVerified ?? false;
  }

  /// Recargar usuario para actualizar estado de verificación
  Future<void> reloadUser() async {
    try {
      _logger.info('Recargando información del usuario actual');
      await _auth.currentUser?.reload();
    } on FirebaseAuthException catch (e) {
      _logger.warning('Error al recargar usuario: ${e.code}');
      throw AuthExceptionHandler.handleException(e);
    }
  }
}
