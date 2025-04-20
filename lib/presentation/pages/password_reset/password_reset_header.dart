import 'package:flutter/material.dart';

/// Encabezado para la página de recuperación de contraseña
class PasswordResetHeader extends StatelessWidget {
  /// Animación de desvanecimiento
  final Animation<double> fadeInAnimation;
  
  /// Animación de deslizamiento
  final Animation<Offset> slideAnimation;
  
  /// Constructor del encabezado
  const PasswordResetHeader({
    super.key,
    required this.fadeInAnimation,
    required this.slideAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeInAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: const Column(
          children: [
            // Icono de recuperación de contraseña
            Icon(
              Icons.lock_reset,
              size: 64,
              color: Colors.amber,
            ),
            SizedBox(height: 24),
            
            // Título principal
            Text(
              'Recuperar Contraseña',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            
            // Subtítulo
            Text(
              'Elige un método para recuperar tu contraseña',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
