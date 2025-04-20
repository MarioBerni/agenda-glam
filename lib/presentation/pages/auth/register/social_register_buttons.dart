import 'package:flutter/material.dart';

/// Botones de registro con redes sociales
class SocialRegisterButtons extends StatelessWidget {
  /// Callback para el registro con Google
  final VoidCallback onGoogleSignUp;
  
  /// Animación de desvanecimiento
  final Animation<double> fadeInAnimation;
  
  /// Animación de deslizamiento
  final Animation<Offset> slideAnimation;
  
  /// Constructor de los botones de redes sociales
  const SocialRegisterButtons({
    super.key,
    required this.onGoogleSignUp,
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
            
            // Botón de registro con Google
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white30),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                foregroundColor: Colors.white,
              ),
              onPressed: onGoogleSignUp,
              icon: const Icon(Icons.g_mobiledata, size: 24, color: Colors.amber),
              label: const Text('Registrarse con Google'),
            ),
          ],
        ),
      ),
    );
  }
}
