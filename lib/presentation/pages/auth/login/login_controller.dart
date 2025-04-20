import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/auth/auth.dart';

/// Controlador para la página de inicio de sesión
class LoginController {
  /// Contexto de la aplicación
  final BuildContext context;
  
  /// Constructor del controlador
  LoginController({required this.context});
  
  /// Inicia sesión con email y contraseña
  void loginWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    context.read<AuthBloc>().add(
      SignInRequested(
        email: email,
        password: password,
      ),
    );
  }
  
  /// Inicia sesión con Google
  void loginWithGoogle() {
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
