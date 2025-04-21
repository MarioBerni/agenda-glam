import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import 'auth_exception_handler.dart';
import 'auth_models.dart';

/// Servicio especializado para autenticación con número de teléfono
@injectable
class PhoneAuthService {
  final FirebaseAuth _auth;
  final Logger _logger = Logger('PhoneAuthService');
  
  // Para manejar el estado de verificación del teléfono
  final StreamController<PhoneAuthState> _phoneAuthStateController = 
      StreamController<PhoneAuthState>.broadcast();
  
  /// Stream que emite cambios en el estado de autenticación por teléfono
  Stream<PhoneAuthState> get phoneAuthStateChanges => _phoneAuthStateController.stream;

  PhoneAuthService(this._auth);

  /// Iniciar sesión o registrar usuario con número de teléfono
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function(PhoneAuthCredential) onVerificationCompleted,
    required Function(String) onError,
    bool isForRegistration = false,
  }) async {
    try {
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
        _auth.setSettings(forceRecaptchaFlow: true);
        _logger.info('Forzando flujo de reCAPTCHA para la verificación de teléfono');
        
        // Configurar números de teléfono de prueba
        if (phoneNumber == '+598123456789') {
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
            default:
              final authException = AuthExceptionHandler.handleException(e);
              errorMsg = authException.message;
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
      _logger.info('Verificando código SMS');
      
      // Crear credenciales con el código SMS
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      UserCredential userCredential;

      // Si el usuario actual existe, vinculamos la credencial de teléfono
      if (_auth.currentUser != null) {
        _logger.info('Vinculando credencial de teléfono con usuario existente');
        await _auth.currentUser!.linkWithCredential(credential);
        // Usamos el usuario actual después de vincular la credencial
        userCredential = await _auth.signInWithCredential(credential);
      } else {
        // Si no hay usuario actual, iniciamos sesión con la credencial
        _logger.info('Iniciando sesión con credencial de teléfono');
        userCredential = await _auth.signInWithCredential(credential);

        // Si se proporcionó email y password, vincular con credenciales de email
        if (email != null && password != null && userCredential.user != null) {
          try {
            _logger.info('Vinculando credencial de email con usuario de teléfono');
            final emailCredential = EmailAuthProvider.credential(
              email: email,
              password: password,
            );
            await userCredential.user!.linkWithCredential(emailCredential);
          } catch (e) {
            _logger.warning('Error al vincular credencial de email: $e');
            // Si falla la vinculación, continuamos con la autenticación por teléfono
          }
        }
      }

      _phoneAuthStateController.add(PhoneAuthState.verified);
      _logger.info('Verificación de código SMS exitosa');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      _logger.severe('Error al verificar código SMS: ${e.code}');
      _phoneAuthStateController.add(PhoneAuthState.error);
      throw AuthExceptionHandler.handleException(e);
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
      _logger.info('Enviando código de recuperación de contraseña a: $phoneNumber');
      
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          _logger.info('Verificación automática completada para recuperación de contraseña');
          _phoneAuthStateController.add(PhoneAuthState.verified);
          onVerified();
        },
        verificationFailed: (FirebaseAuthException e) {
          _logger.warning('Error en verificación para recuperación: ${e.code}');
          _phoneAuthStateController.add(PhoneAuthState.error);
          onError(AuthExceptionHandler.handleException(e).message);
        },
        codeSent: (String verificationId, int? resendToken) {
          _logger.info('Código de recuperación enviado a: $phoneNumber');
          _phoneAuthStateController.add(PhoneAuthState.codeSent);
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      _logger.severe('Error general en recuperación por SMS: $e');
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
      _logger.info('Actualizando contraseña después de verificación por teléfono');
      
      // Verificar el código SMS
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      // Iniciar sesión con la credencial de teléfono
      final userCredential = await _auth.signInWithCredential(credential);

      // Actualizar la contraseña
      await userCredential.user?.updatePassword(newPassword);
      _logger.info('Contraseña actualizada exitosamente');

      _phoneAuthStateController.add(PhoneAuthState.passwordUpdated);
    } on FirebaseAuthException catch (e) {
      _logger.severe('Error al actualizar contraseña: ${e.code}');
      _phoneAuthStateController.add(PhoneAuthState.error);
      throw AuthExceptionHandler.handleException(e);
    }
  }

  /// Liberar recursos
  void dispose() {
    _logger.info('Liberando recursos de PhoneAuthService');
    _phoneAuthStateController.close();
  }
}
