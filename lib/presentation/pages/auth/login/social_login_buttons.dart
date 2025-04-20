import 'package:flutter/material.dart';

/// Botones de inicio de sesión con redes sociales
class SocialLoginButtons extends StatelessWidget {
  /// Callback para el inicio de sesión con Google
  final VoidCallback onGoogleSignIn;
  
  /// Animación de desvanecimiento
  final Animation<double> fadeInAnimation;
  
  /// Animación de deslizamiento
  final Animation<Offset> slideAnimation;
  
  /// Constructor de los botones de redes sociales
  const SocialLoginButtons({
    super.key,
    required this.onGoogleSignIn,
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Separador
            const Row(
              children: [
                Expanded(child: Divider(color: Colors.white30)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'O',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                Expanded(child: Divider(color: Colors.white30)),
              ],
            ),
            const SizedBox(height: 16),
            
            // Botón de inicio de sesión con Google
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white30),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                foregroundColor: Colors.white,
              ),
              onPressed: onGoogleSignIn,
              icon: const Icon(Icons.g_mobiledata, size: 24, color: Colors.amber),
              label: const Text('Continuar con Google'),
            ),
          ],
        ),
      ),
    );
  }
}
