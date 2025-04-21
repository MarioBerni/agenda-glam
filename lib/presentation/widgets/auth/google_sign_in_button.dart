import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth.dart';

/// Botón para iniciar sesión con Google
class GoogleSignInButton extends StatelessWidget {
  /// Función que se ejecuta después de un inicio de sesión exitoso
  final VoidCallback? onSignIn;

  const GoogleSignInButton({super.key, this.onSignIn});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated && 
            state.authMethod == 'google' && 
            onSignIn != null) {
          onSignIn!();
        }
      },
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Colors.white70, width: 1),
            ),
          ),
          onPressed: () {
            context.read<AuthBloc>().add(GoogleSignInRequested());
          },
          child: const Text(
            'Continuar con Google',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
