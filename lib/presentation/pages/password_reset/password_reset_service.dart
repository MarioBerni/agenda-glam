import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../widgets/common/custom_snackbar.dart';

/// Clase que maneja la lógica de autenticación para la recuperación de contraseña
class PasswordResetService {
  /// Instancia de Firebase Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  /// Envía un código de verificación al número de teléfono proporcionado
  Future<void> sendVerificationCode({
    required String phoneNumber,
    required Function(String) onVerificationIdReceived,
    required VoidCallback onAutoVerified,
    required Function(String) onError,
    required Function(String) onCodeSent,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          // Auto-verificación en Android (raro en recuperación de contraseña)
          onAutoVerified();
        },
        verificationFailed: (FirebaseAuthException e) {
          onError(e.message ?? 'Error al enviar SMS');
        },
        codeSent: (String verificationId, int? resendToken) {
          onVerificationIdReceived(verificationId);
          onCodeSent(phoneNumber);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // El código expiró sin ser usado
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      onError(e.toString());
    }
  }
  
  /// Verifica el código SMS ingresado
  Future<bool> verifyCode({
    required String verificationId,
    required String smsCode,
    required Function(String) onError,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      
      // Verificar el código
      await _auth.signInWithCredential(credential);
      
      // Cerrar sesión inmediatamente, ya que solo queríamos verificar el código
      await _auth.signOut();
      
      return true;
    } catch (e) {
      onError('Código incorrecto o expirado. Inténtalo de nuevo.');
      return false;
    }
  }
  
  /// Muestra un mensaje de éxito o error según el resultado de la operación
  void showResultMessage({
    required BuildContext context,
    required bool isSuccess,
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    if (isSuccess) {
      CustomSnackBar.showSuccess(
        context: context,
        message: message,
        duration: duration,
      );
    } else {
      CustomSnackBar.showError(
        context: context,
        message: message,
        duration: duration,
      );
    }
  }
}
