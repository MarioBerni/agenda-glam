import 'package:flutter/material.dart';
import 'package:intl_phone_field/phone_number.dart';
import '../password_reset_page.dart';
import 'email_recovery_form.dart';
import 'phone_recovery_form.dart';
import 'verification_code_form.dart';

/// Formulario principal para la recuperación de contraseña
class ResetForm extends StatelessWidget {
  /// Constructor del formulario de recuperación
  const ResetForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.phoneController,
    required this.smsCodeController,
    required this.recoveryMethod,
    required this.isLoading,
    required this.codeSent,
    required this.onMethodChanged,
    required this.onPhoneChanged,
    required this.onSubmit,
    required this.onCancel,
    required this.fadeInAnimation,
    required this.slideAnimation,
  });

  /// Clave del formulario para validación
  final GlobalKey<FormState> formKey;
  
  /// Controlador para el campo de email
  final TextEditingController emailController;
  
  /// Controlador para el campo de teléfono
  final TextEditingController phoneController;
  
  /// Controlador para el campo de código SMS
  final TextEditingController smsCodeController;
  
  /// Método de recuperación seleccionado
  final RecoveryMethod recoveryMethod;
  
  /// Indica si se está procesando la solicitud
  final bool isLoading;
  
  /// Indica si se ha enviado el código SMS
  final bool codeSent;
  
  /// Callback cuando cambia el método de recuperación
  final Function(RecoveryMethod) onMethodChanged;
  
  /// Callback cuando cambia el número de teléfono
  final Function(PhoneNumber) onPhoneChanged;
  
  /// Callback cuando se envía el formulario
  final VoidCallback onSubmit;
  
  /// Callback cuando se cancela la operación
  final VoidCallback onCancel;
  
  /// Animación de fade in
  final Animation<double> fadeInAnimation;
  
  /// Animación de deslizamiento
  final Animation<Offset> slideAnimation;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeInAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.lock_reset,
                size: 64,
                color: Colors.blue,
              ),
              const SizedBox(height: 24),
              const Text(
                'Recupera tu contraseña',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Selecciona un método para recuperar tu contraseña',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              // Selector de método de recuperación
              SegmentedButton<RecoveryMethod>(
                segments: const [
                  ButtonSegment<RecoveryMethod>(
                    value: RecoveryMethod.email,
                    label: Text('Email'),
                    icon: Icon(Icons.email),
                  ),
                  ButtonSegment<RecoveryMethod>(
                    value: RecoveryMethod.phone,
                    label: Text('Teléfono'),
                    icon: Icon(Icons.phone_android),
                  ),
                ],
                selected: {recoveryMethod},
                onSelectionChanged: (Set<RecoveryMethod> selection) {
                  onMethodChanged(selection.first);
                },
              ),
              
              const SizedBox(height: 24),
              
              // Formulario según el método seleccionado
              if (recoveryMethod == RecoveryMethod.email)
                EmailRecoveryForm(
                  controller: emailController,
                  isLoading: isLoading,
                )
              else
                Column(
                  children: [
                    PhoneRecoveryForm(
                      controller: phoneController,
                      isLoading: isLoading || codeSent,
                      onPhoneChanged: onPhoneChanged,
                    ),
                    
                    // Mostrar campo para código SMS si ya se envió el código
                    if (codeSent)
                      VerificationCodeForm(
                        controller: smsCodeController,
                        isLoading: isLoading,
                      ),
                  ],
                ),
              
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
                onPressed: isLoading ? null : onSubmit,
                child: isLoading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 12),
                          Text('Enviando...'),
                        ],
                      )
                    : Text(recoveryMethod == RecoveryMethod.email 
                        ? 'ENVIAR INSTRUCCIONES' 
                        : (codeSent ? 'VERIFICAR CÓDIGO' : 'ENVIAR CÓDIGO SMS')),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: isLoading ? null : onCancel,
                child: const Text('CANCELAR'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
