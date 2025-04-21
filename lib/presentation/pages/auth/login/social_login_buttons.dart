import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
            
            // Botón de inicio de sesión con Google (diseño oficial)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                minimumSize: const Size(double.infinity, 56),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              onPressed: onGoogleSignIn,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo de Google
                    SvgPicture.asset(
                      'assets/images/google_logo.svg',
                      height: 24,
                      width: 24,
                    ),
                    const SizedBox(width: 12),
                    // Texto del botón con estilo oficial
                    const Text(
                      'Continuar con Google',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        letterSpacing: 0.25,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
