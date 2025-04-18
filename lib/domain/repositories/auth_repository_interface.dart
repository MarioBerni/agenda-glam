import 'package:firebase_auth/firebase_auth.dart';
import '../../data/services/auth_service.dart';

/// Interfaz para el repositorio de autenticación
abstract class AuthRepositoryInterface {
  /// Stream de cambios en el estado de autenticación
  Stream<User?> get authStateChanges;
  
  /// Usuario actualmente autenticado
  User? get currentUser;
  
  /// Stream de cambios en el estado de autenticación por teléfono
  Stream<PhoneAuthState> get phoneAuthStateChanges;
  
  /// Iniciar sesión con email y contraseña
  Future<UserCredential> signInWithEmailAndPassword(String email, String password);
  
  /// Crear usuario con email y contraseña
  Future<UserCredential> createUserWithEmailAndPassword(String email, String password);
  
  /// Iniciar sesión con Google
  Future<UserCredential> signInWithGoogle();
  
  /// Iniciar sesión con credenciales de Firebase Auth
  Future<UserCredential> signInWithCredential(AuthCredential credential);
  
  /// Cerrar sesión
  Future<void> signOut();
  
  /// Enviar email de recuperación de contraseña
  Future<void> sendPasswordResetEmail(String email);
  
  /// Enviar email de verificación
  Future<void> sendEmailVerification();
  
  /// Verificar si el email está verificado
  bool get isEmailVerified;
  
  /// Recargar información del usuario
  Future<void> reloadUser();
  
  /// Verificar número de teléfono para autenticación
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function(PhoneAuthCredential) onVerificationCompleted,
    required Function(String) onError,
    bool isForRegistration,
  });
  
  /// Verificar código SMS recibido
  Future<UserCredential> verifyPhoneSmsCode({
    required String verificationId,
    required String smsCode,
    String? email,
    String? password,
  });
  
  /// Enviar código de recuperación de contraseña por SMS
  Future<void> sendPasswordResetBySms({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function() onVerified,
    required Function(String) onError,
  });
  
  /// Actualizar contraseña después de verificación por teléfono
  Future<void> updatePasswordAfterPhoneVerification({
    required String verificationId,
    required String smsCode,
    required String newPassword,
  });
  
  /// Liberar recursos
  void dispose();
}
