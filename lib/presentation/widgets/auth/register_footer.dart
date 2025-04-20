import 'package:flutter/material.dart';

/// Pie de página para la pantalla de registro
class RegisterFooter extends StatelessWidget {
  /// Función que se ejecuta al presionar el botón de inicio de sesión
  final VoidCallback? onLogin;

  /// Constructor del pie de página de registro
  const RegisterFooter({super.key, this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Separador visual
        const Divider(
          color: Colors.white24,
          thickness: 1,
          height: 32,
        ),
        
        // Texto y botón para ir a inicio de sesión
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¿Ya tienes una cuenta?',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
            TextButton(
              onPressed: onLogin,
              child: Text(
                'Iniciar sesión',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Versión de la aplicación
        Text(
          'Agenda Glam v1.0.0',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white38,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
