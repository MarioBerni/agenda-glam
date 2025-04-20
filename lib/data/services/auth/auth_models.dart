/// Modelos y enumeraciones relacionados con la autenticación.
/// Este archivo contiene definiciones de estados y modelos utilizados en el proceso de autenticación.
library auth_models;

/// Estados posibles durante la autenticación por teléfono
enum PhoneAuthState {
  /// Código SMS enviado
  codeSent,
  
  /// Verificación completada
  verified,
  
  /// Error en la verificación
  error,
  
  /// Contraseña actualizada después de verificación
  passwordUpdated,
}

/// Excepción personalizada para errores de autenticación
class AuthException implements Exception {
  final String code;
  final String message;

  AuthException(this.code, this.message);

  @override
  String toString() => message;
}
