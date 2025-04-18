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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated && 
            state.authMethod == 'google' && 
            onSignIn != null) {
          onSignIn!();
        }
      },
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          side: BorderSide(color: colorScheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        icon: const Icon(
          Icons.g_mobiledata,
          size: 24,
          color: Colors.blue,
        ),
        label: const Text('Continuar con Google'),
        onPressed: () {
          context.read<AuthBloc>().add(GoogleSignInRequested());
        },
      ),
    );
  }
}
