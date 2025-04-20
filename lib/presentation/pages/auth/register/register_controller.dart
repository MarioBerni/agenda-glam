import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/auth/auth.dart';

/// Controlador para la página de registro
class RegisterController {
  /// Contexto de la aplicación
  final BuildContext context;
  
  /// Constructor del controlador
  RegisterController({required this.context});
  
  /// Registra un nuevo usuario con email y contraseña
  void registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required bool hasAcceptedTerms,
  }) {
    context.read<AuthBloc>().add(
      SignUpRequested(
        email: email,
        password: password,
        name: name,
        hasAcceptedTerms: hasAcceptedTerms,
      ),
    );
  }
  
  /// Registra un nuevo usuario con número de teléfono
  void registerWithPhoneNumber({
    required String phoneNumber,
    required String password,
  }) {
    // Primero solicitar verificación del número de teléfono
    context.read<AuthBloc>().add(
      PhoneVerificationRequested(
        phoneNumber: phoneNumber,
        isForRegistration: true,
      ),
    );
  }
  
  /// Registra un nuevo usuario con Google
  void registerWithGoogle() {
    context.read<AuthBloc>().add(GoogleSignInRequested());
  }
  
  /// Muestra un mensaje de resultado
  void showResultMessage({
    required bool isSuccess,
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ),
    );
  }
}
