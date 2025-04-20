import 'package:flutter/material.dart';

/// Pie de página para la página de inicio de sesión
class LoginFooter extends StatelessWidget {
  /// Callback para navegar a la página de registro
  final VoidCallback onRegister;
  
  /// Animación de desvanecimiento
  final Animation<double> fadeInAnimation;
  
  /// Animación de deslizamiento
  final Animation<Offset> slideAnimation;
  
  /// Constructor del pie de página
  const LoginFooter({
    super.key,
    required this.onRegister,
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
            // Enlace para registrarse
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '¿No tienes una cuenta?',
                  style: TextStyle(color: Colors.white70),
                ),
                TextButton(
                  onPressed: onRegister,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.amber,
                  ),
                  child: const Text('Regístrate'),
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
