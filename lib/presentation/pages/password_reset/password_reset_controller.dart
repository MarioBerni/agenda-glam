import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth.dart';
import 'password_reset_service.dart';
import 'success_message.dart';

/// Controlador para la página de restablecimiento de contraseña
/// 
/// Maneja la lógica de negocio para el restablecimiento de contraseña
class PasswordResetController {
  final PasswordResetService resetService;
  final BuildContext context;
  
  /// Constructor del controlador
  PasswordResetController({
    required this.context,
    PasswordResetService? resetService,
  }) : resetService = resetService ?? PasswordResetService();
  
  /// Solicita el restablecimiento de contraseña por email
  void requestEmailReset(String email) {
    context.read<AuthBloc>().add(
      PasswordResetRequested(email: email.trim()),
    );
  }
  
  /// Envía un código de verificación al número de teléfono
  Future<bool> sendVerificationCode({
    required String phoneNumber,
    required Function(String) onVerificationIdReceived,
    required Function() onLoading,
    required Function() onComplete,
  }) async {
    bool success = false;
    
    onLoading();
    
    await resetService.sendVerificationCode(
      phoneNumber: phoneNumber,
      onVerificationIdReceived: (verificationId) {
        onVerificationIdReceived(verificationId);
        success = true;
        onComplete();
      },
      onAutoVerified: () {
        success = true;
        onComplete();
      },
      onError: (errorMessage) {
        onComplete();
        
        resetService.showResultMessage(
          context: context,
          isSuccess: false,
          message: errorMessage,
        );
      },
      onCodeSent: (phoneNumber) {
        resetService.showResultMessage(
          context: context,
          isSuccess: true,
          message: 'Se ha enviado un código de verificación al número $phoneNumber',
        );
      },
    );
    
    return success;
  }
  
  /// Verifica el código SMS ingresado
  Future<bool> verifyCode({
    required String verificationId,
    required String smsCode,
    required Function() onLoading,
    required Function() onComplete,
    required Function(PhoneVerificationStatus) onStatusChanged,
  }) async {
    // Capturar el contexto antes de la operación asíncrona
    final currentContext = context;
    
    onLoading();
    
    final success = await resetService.verifyCode(
      verificationId: verificationId,
      smsCode: smsCode.trim(),
      onError: (errorMessage) {
        onComplete();
        
        // Verificar si el widget aún está montado
        // Como estamos en un controlador, no podemos usar mounted directamente
        // Pero podemos usar un try-catch para manejar posibles errores
        try {
          // Verificar si el contexto aún es válido
          if (currentContext.mounted) {
            resetService.showResultMessage(
              context: currentContext,
              isSuccess: false,
              message: errorMessage,
            );
          }
        } catch (e) {
          // El contexto ya no es válido, no hacemos nada
        }
      },
    );
    
    if (success) {
      onStatusChanged(PhoneVerificationStatus.verified);
      onComplete();
      
      // Verificar si el widget aún está montado
      try {
        if (currentContext.mounted) {
          resetService.showResultMessage(
            context: currentContext,
            isSuccess: true,
            message: 'Verificación exitosa. Ahora puedes crear una nueva contraseña.',
          );
        }
      } catch (e) {
        // El contexto ya no es válido, no hacemos nada
      }
    }
    
    return success;
  }
  
  /// Muestra un mensaje de resultado
  void showResultMessage({
    required bool isSuccess,
    required String message,
  }) {
    resetService.showResultMessage(
      context: context,
      isSuccess: isSuccess,
      message: message,
    );
  }
}
