import 'package:flutter/material.dart';

/// Pie de página para la página de recuperación de contraseña
class PasswordResetFooter extends StatelessWidget {
  /// Callback para volver a la página de inicio de sesión
  final VoidCallback onCancel;
  
  /// Animación de desvanecimiento
  final Animation<double> fadeInAnimation;
  
  /// Animación de deslizamiento
  final Animation<Offset> slideAnimation;
  
  /// Constructor del pie de página
  const PasswordResetFooter({
    super.key,
    required this.onCancel,
    required this.fadeInAnimation,
    required this.slideAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeInAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: Column(
          children: [
            // Enlace para volver a la página de inicio de sesión
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '¿Recordaste tu contraseña?',
                  style: TextStyle(color: Colors.white70),
                ),
                TextButton(
                  onPressed: onCancel,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.amber,
                  ),
                  child: const Text('Volver a Iniciar Sesión'),
                ),
              ],
            ),
            
            // Versión de la aplicación
            const SizedBox(height: 16),
            const Text(
              'Versión 1.0.0',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
