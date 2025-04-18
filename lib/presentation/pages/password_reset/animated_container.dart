import 'package:flutter/material.dart';

/// Widget contenedor con animaciones para la página de restablecimiento de contraseña
class AnimatedResetContainer extends StatelessWidget {
  /// Animación de desvanecimiento
  final Animation<double> fadeInAnimation;
  
  /// Animación de deslizamiento
  final Animation<Offset> slideAnimation;
  
  /// Contenido del widget
  final Widget child;
  
  /// Constructor del contenedor animado
  const AnimatedResetContainer({
    super.key,
    required this.fadeInAnimation,
    required this.slideAnimation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeInAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: child,
      ),
    );
  }
}
