import 'package:flutter/material.dart';

/// Widget que muestra el pie de página de la pantalla de inicio de sesión
/// con opciones para registrarse y la versión de la aplicación.
class LoginFooter extends StatelessWidget {
  /// Función que se ejecuta cuando se presiona el botón de registro
  final VoidCallback? onRegister;
  
  /// Versión de la aplicación
  final String version;

  const LoginFooter({
    super.key, 
    this.onRegister,
    this.version = '1.0.0',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Colores con opacidad para textos secundarios
    final onSurfaceWithOpacity = colorScheme.onSurface.withAlpha(179); // 0.7 * 255 = 179
    final onSurfaceWithLowOpacity = colorScheme.onSurface.withAlpha(128); // 0.5 * 255 = 128

    return Column(
      children: [
        const SizedBox(height: 32.0),
        
        // Opción para registrarse
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¿No tienes una cuenta?',
              style: TextStyle(color: onSurfaceWithOpacity),
            ),
            TextButton(
              onPressed: onRegister,
              child: Text(
                'Regístrate',
                style: TextStyle(
                  color: colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        // Versión de la aplicación
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: Text(
            'Versión $version',
            style: TextStyle(
              color: onSurfaceWithLowOpacity,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
