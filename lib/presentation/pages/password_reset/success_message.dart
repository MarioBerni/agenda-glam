import 'package:flutter/material.dart';
import '../password_reset_page.dart';

/// Enum para identificar el estado de la verificación por teléfono
enum PhoneVerificationStatus {
  /// Código SMS enviado, esperando verificación
  codeSent,
  
  /// Código verificado correctamente
  verified,
}

/// Widget que muestra el mensaje de éxito después de enviar la solicitud de recuperación
class SuccessMessage extends StatelessWidget {
  /// Constructor del mensaje de éxito
  const SuccessMessage({
    super.key,
    required this.fadeInAnimation,
    required this.slideAnimation,
    required this.recoveryMethod,
    this.emailAddress = '',
    this.phoneNumber = '',
    this.phoneStatus = PhoneVerificationStatus.codeSent,
    required this.onResendPressed,
  });

  /// Animación de fade in
  final Animation<double> fadeInAnimation;
  
  /// Animación de deslizamiento
  final Animation<Offset> slideAnimation;
  
  /// Método de recuperación utilizado
  final RecoveryMethod recoveryMethod;
  
  /// Dirección de correo electrónico (para recuperación por email)
  final String emailAddress;
  
  /// Número de teléfono (para recuperación por SMS)
  final String phoneNumber;
  
  /// Estado de la verificación por teléfono
  final PhoneVerificationStatus phoneStatus;
  
  /// Callback que se ejecuta cuando se presiona el botón de reenviar
  final VoidCallback onResendPressed;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeInAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(),
            const SizedBox(height: 24),
            _buildTitle(context),
            const SizedBox(height: 16),
            _buildMessage(),
            if (recoveryMethod == RecoveryMethod.email || phoneStatus == PhoneVerificationStatus.codeSent) ...[              
              const SizedBox(height: 8),
              _buildAddress(),
            ],
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 56),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('VOLVER AL INICIO DE SESIÓN'),
            ),
            const SizedBox(height: 16),
            if (recoveryMethod == RecoveryMethod.email || phoneStatus == PhoneVerificationStatus.codeSent)
              TextButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Enviar nuevamente'),
                onPressed: onResendPressed,
              ),
          ],
        ),
      ),
    );
  }
  
  /// Construye el ícono adecuado según el método de recuperación
  Widget _buildIcon() {
    final IconData iconData;
    const Color iconColor = Colors.green;
    
    if (recoveryMethod == RecoveryMethod.email) {
      iconData = Icons.mark_email_read;
    } else if (phoneStatus == PhoneVerificationStatus.verified) {
      iconData = Icons.verified_user_outlined;
    } else {
      iconData = Icons.sms_outlined;
    }
    
    return Icon(
      iconData,
      size: 80,
      color: iconColor,
    );
  }
  
  /// Construye el título según el método de recuperación
  Widget _buildTitle(BuildContext context) {
    final String title;
    
    if (recoveryMethod == RecoveryMethod.email) {
      title = '¡Correo enviado!';
    } else if (phoneStatus == PhoneVerificationStatus.verified) {
      title = 'Verificación exitosa';
    } else {
      title = '¡Código SMS enviado!';
    }
    
    return Text(
      title,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
      textAlign: TextAlign.center,
    );
  }
  
  /// Construye el mensaje según el método de recuperación
  Widget _buildMessage() {
    final String message;
    
    if (recoveryMethod == RecoveryMethod.email) {
      message = 'Hemos enviado instrucciones para restablecer tu contraseña a:';
    } else if (phoneStatus == PhoneVerificationStatus.verified) {
      message = 'Tu número de teléfono ha sido verificado correctamente. '
               'Ahora puedes crear una nueva contraseña para tu cuenta.';
    } else {
      message = 'Hemos enviado un código de verificación al número:';
    }
    
    return Text(
      message,
      style: const TextStyle(fontSize: 16),
      textAlign: TextAlign.center,
    );
  }
  
  /// Construye la dirección de correo o número de teléfono
  Widget _buildAddress() {
    final String address = recoveryMethod == RecoveryMethod.email ? emailAddress : phoneNumber;
    final String additionalText = recoveryMethod == RecoveryMethod.email 
        ? 'Revisa tu bandeja de entrada y sigue las instrucciones.'
        : 'Revisa tus mensajes SMS e ingresa el código en la aplicación.';
    
    return Column(
      children: [
        Text(
          address,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          additionalText,
          style: const TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
