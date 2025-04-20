import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';


/// Interfaz base para el servicio de autenticación
/// Define los métodos y propiedades que deben implementar todos los servicios de autenticación
abstract class AuthServiceInterface {
  /// Stream que emite cambios en el estado de autenticación del usuario
  Stream<User?> get authStateChanges;

  /// Usuario actualmente autenticado
  User? get currentUser;

  /// Verifica si el email del usuario está verificado
  bool get isEmailVerified;

  /// Iniciar sesión con email y contraseña
  Future<UserCredential> signInWithEmailAndPassword(String email, String password);

  /// Registrar un nuevo usuario con email y contraseña
  Future<UserCredential> createUserWithEmailAndPassword(String email, String password);

  /// Iniciar sesión con credenciales (método genérico)
  Future<UserCredential> signInWithCredential(AuthCredential credential);

  /// Iniciar sesión con Google
  Future<UserCredential> signInWithGoogle();

  /// Cerrar sesión
  Future<void> signOut();

  /// Enviar email para restablecer contraseña
  Future<void> sendPasswordResetEmail(String email);

  /// Enviar email de verificación al usuario actual
  Future<void> sendEmailVerification();

  /// Recargar información del usuario actual
  Future<void> reloadUser();

  /// Liberar recursos
  void dispose();
}
