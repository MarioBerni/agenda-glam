import 'package:flutter/material.dart';

/// Encabezado para la página de inicio de sesión
class LoginHeader extends StatelessWidget {
  /// Animación de desvanecimiento
  final Animation<double> fadeInAnimation;
  
  /// Animación de deslizamiento
  final Animation<Offset> slideAnimation;
  
  /// Constructor del encabezado
  const LoginHeader({
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
            // Logo o icono de la aplicación
            Icon(
              Icons.lock_open,
              size: 64,
              color: Colors.amber,
            ),
            SizedBox(height: 24),
            
            // Título principal
            Text(
              'Iniciar Sesión',
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
              'Ingresa tus credenciales para acceder a tu cuenta',
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
