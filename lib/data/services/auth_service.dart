import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:logging/logging.dart';

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

/// Servicio de autenticación que maneja todas las operaciones relacionadas con Firebase Auth
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  // Para manejar el estado de verificación del teléfono
  final StreamController<PhoneAuthState> _phoneAuthStateController = StreamController<PhoneAuthState>.broadcast();
  
  // Logger para registro de eventos
  final Logger _logger = Logger('AuthService');

  // Estado del usuario actual
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Usuario actual
  User? get currentUser => _auth.currentUser;
  
  // Estado de la autenticación por teléfono
  Stream<PhoneAuthState> get phoneAuthStateChanges => _phoneAuthStateController.stream;

  // Iniciar sesión con email y contraseña
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password,) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Registrar usuario con email y contraseña
  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password,) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Enviar email de verificación
      await credential.user?.sendEmailVerification();
      
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Iniciar sesión con credenciales de Firebase Auth
  Future<UserCredential> signInWithCredential(AuthCredential credential) async {
    try {
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Iniciar sesión con Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Iniciar el flujo de autenticación de Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        throw Exception('Inicio de sesión con Google cancelado por el usuario.');
      }

      // Obtener detalles de autenticación de la solicitud
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Crear credencial para Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Iniciar sesión con la credencial
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      if (e is FirebaseAuthException) {
        throw _handleAuthException(e);
      }
      throw Exception('Error al iniciar sesión con Google: ${e.toString()}');
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    // Cerrar sesión de Google si está activa
    await _googleSignIn.signOut();
    // Cerrar sesión de Firebase
    await _auth.signOut();
  }

  // Recuperar contraseña
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Verificar email del usuario
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Verificar si el email está verificado
  bool get isEmailVerified {
    return _auth.currentUser?.emailVerified ?? false;
  }

  // Recargar usuario para actualizar estado de verificación
  Future<void> reloadUser() async {
    try {
      await _auth.currentUser?.reload();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Iniciar sesión o registrar usuario con número de teléfono
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function(PhoneAuthCredential) onVerificationCompleted,
    required Function(String) onError,
    bool isForRegistration = false,
  }) async {
    try {
      // Configuraciones para mejorar la compatibilidad
      // Registra información adicional para depuración
      _logger.info('Iniciando verificación de teléfono para: $phoneNumber');
      
      // Aseguramos que el número tenga el formato internacional correcto
      if (!phoneNumber.startsWith('+')) {
        // Si el número no tiene el prefijo internacional, asumimos Uruguay (+598)
        phoneNumber = '+598$phoneNumber';
        _logger.info('Número formateado a formato internacional: $phoneNumber');
      }
      
      // Configuraciones para entorno de desarrollo
      if (kDebugMode) {
        // Forzar el uso de reCAPTCHA en lugar de Play Integrity
        // Esto es especialmente útil en emuladores o cuando hay problemas con Play Integrity
        _auth.setSettings(forceRecaptchaFlow: true);
        _logger.info('Forzando flujo de reCAPTCHA para la verificación de teléfono');
        
        // Configurar números de teléfono de prueba
        // IMPORTANTE: Estos números deben estar configurados en Firebase Console
        // en la sección "Números de teléfono para la prueba"
        if (phoneNumber == '+598123456789') {
          // Si es un número de prueba, configurar la recuperación automática del código
          _auth.setSettings(phoneNumber: phoneNumber, smsCode: '123456');
          _logger.info('Usando número de teléfono de prueba con código 123456');
        }
      }
      
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          // Auto-verificación completada (Android)
          _logger.info('Verificación automática completada');
          _phoneAuthStateController.add(PhoneAuthState.verified);
          onVerificationCompleted(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          _logger.warning('Error en verificación: ${e.code} - ${e.message}');
          _phoneAuthStateController.add(PhoneAuthState.error);
          
          // Mensajes de error más detallados para ayudar en la depuración
          String errorMsg;
          switch (e.code) {
            case 'invalid-phone-number':
              errorMsg = 'El número de teléfono no tiene un formato válido.';
              break;
            case 'quota-exceeded':
              errorMsg = 'Se ha excedido la cuota de envío de SMS. Intenta más tarde.';
              break;
            case 'missing-client-identifier':
              errorMsg = 'Falta el identificador del cliente en la solicitud.';
              break;
            case 'app-not-authorized':
              errorMsg = 'La aplicación no está autorizada para usar Firebase Authentication. Verifica que las huellas SHA-1 y SHA-256 estén configuradas en la consola de Firebase.';
              break;
            case 'missing-verification-code':
              errorMsg = 'Falta el código de verificación.';
              break;
            case 'invalid-verification-code':
              errorMsg = 'El código de verificación es inválido.';
              break;
            default:
              errorMsg = _handleAuthException(e).toString();
          }
          
          onError(errorMsg);
        },
        codeSent: (String verificationId, int? resendToken) {
          _logger.info('Código SMS enviado a $phoneNumber');
          _phoneAuthStateController.add(PhoneAuthState.codeSent);
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Tiempo de espera para la recuperación automática del código
          _logger.info('Tiempo de espera agotado para la recuperación automática del código');
        },
        timeout: const Duration(seconds: 120), // Aumentamos el tiempo de espera
      );
    } catch (e) {
      _logger.severe('Error general en verificación de teléfono: $e');
      _phoneAuthStateController.add(PhoneAuthState.error);
      onError('Error al enviar el código de verificación: $e');
    }  
  }

  /// Verificar el código SMS recibido
  Future<UserCredential> verifyPhoneSmsCode({
    required String verificationId,
    required String smsCode,
    String? email,
    String? password,
  }) async {
    try {
      // Crear credenciales con el código SMS
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      UserCredential userCredential;

      // Si el usuario actual existe, vinculamos la credencial de teléfono
      if (_auth.currentUser != null) {
        await _auth.currentUser!.linkWithCredential(credential);
        // Usamos el usuario actual después de vincular la credencial
        userCredential = await _auth.signInWithCredential(credential);
      } else {
        // Si no hay usuario actual, iniciamos sesión con la credencial
        userCredential = await _auth.signInWithCredential(credential);

        // Si se proporcionó email y password, vincular con credenciales de email
        if (email != null && password != null && userCredential.user != null) {
          try {
            final emailCredential = EmailAuthProvider.credential(
              email: email,
              password: password,
            );
            await userCredential.user!.linkWithCredential(emailCredential);
          } catch (e) {
            // Si falla la vinculación, continuamos con la autenticación por teléfono
          }
        }
      }

      _phoneAuthStateController.add(PhoneAuthState.verified);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      _phoneAuthStateController.add(PhoneAuthState.error);
      throw _handleAuthException(e);
    }
  }

  /// Enviar código de recuperación de contraseña por SMS
  Future<void> sendPasswordResetBySms({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function() onVerified,
    required Function(String) onError,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          _phoneAuthStateController.add(PhoneAuthState.verified);
          onVerified();
        },
        verificationFailed: (FirebaseAuthException e) {
          _phoneAuthStateController.add(PhoneAuthState.error);
          onError(_handleAuthException(e).toString());
        },
        codeSent: (String verificationId, int? resendToken) {
          _phoneAuthStateController.add(PhoneAuthState.codeSent);
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      _phoneAuthStateController.add(PhoneAuthState.error);
      onError('Error al enviar el código de verificación: $e');
    }
  }

  /// Actualizar contraseña después de verificación por teléfono
  Future<void> updatePasswordAfterPhoneVerification({
    required String verificationId,
    required String smsCode,
    required String newPassword,
  }) async {
    try {
      // Verificar el código SMS
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      // Iniciar sesión con la credencial de teléfono
      final userCredential = await _auth.signInWithCredential(credential);

      // Actualizar la contraseña
      await userCredential.user?.updatePassword(newPassword);

      _phoneAuthStateController.add(PhoneAuthState.passwordUpdated);
    } on FirebaseAuthException catch (e) {
      _phoneAuthStateController.add(PhoneAuthState.error);
      throw _handleAuthException(e);
    }
  }

  // Manejo de excepciones de autenticación
  Exception _handleAuthException(FirebaseAuthException e) {
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
    return Exception(message);
  }
  
  /// Cerrar y liberar recursos
  void dispose() {
    _phoneAuthStateController.close();
  }
}
