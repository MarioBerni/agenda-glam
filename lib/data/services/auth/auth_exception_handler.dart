import 'package:firebase_auth/firebase_auth.dart';
import 'auth_models.dart';

/// Clase para manejar excepciones de autenticación de Firebase
/// Convierte las excepciones de Firebase en mensajes de error amigables
class AuthExceptionHandler {
  /// Convierte una excepción de Firebase Auth en una excepción personalizada
  static AuthException handleException(FirebaseAuthException e) {
    String message;
    
    switch (e.code) {
      case 'user-not-found':
        message = 'No existe un usuario con este correo electrónico.';
        break;
      case 'wrong-password':
        message = 'Contraseña incorrecta. Por favor, verifica tus credenciales.';
        break;
      case 'email-already-in-use':
        message = 'Este correo electrónico ya está registrado. Intenta iniciar sesión.';
        break;
      case 'weak-password':
        message = 'La contraseña es demasiado débil. Debe tener al menos 6 caracteres.';
        break;
      case 'invalid-email':
        message = 'El formato del correo electrónico es inválido.';
        break;
      case 'account-exists-with-different-credential':
        message = 'Ya existe una cuenta con este email pero con otro método de autenticación.';
        break;
      case 'invalid-credential':
        message = 'Las credenciales proporcionadas son inválidas.';
        break;
      case 'operation-not-allowed':
        message = 'Esta operación no está permitida. Contacta al soporte.';
        break;
      case 'user-disabled':
        message = 'Esta cuenta ha sido deshabilitada. Contacta al soporte.';
        break;
      case 'too-many-requests':
        message = 'Demasiados intentos fallidos. Intenta más tarde.';
        break;
      case 'network-request-failed':
        message = 'Error de conexión. Verifica tu conexión a internet.';
        break;
      case 'invalid-verification-code':
        message = 'El código de verificación es inválido. Intenta nuevamente.';
        break;
      case 'invalid-verification-id':
        message = 'El ID de verificación es inválido. Solicita un nuevo código.';
        break;
      case 'invalid-phone-number':
        message = 'El número de teléfono proporcionado no es válido.';
        break;
      case 'quota-exceeded':
        message = 'Se ha excedido la cuota de envío de SMS. Intenta más tarde.';
        break;
      default:
        message = 'Ha ocurrido un error: ${e.message ?? e.code}';
    }
    
    return AuthException(e.code, message);
  }
}
