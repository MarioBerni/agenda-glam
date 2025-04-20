import 'package:flutter/material.dart';

/// Fondo animado con gradiente para las páginas de autenticación
class AnimatedBackground extends StatelessWidget {
  /// Widget hijo que se mostrará sobre el fondo
  final Widget child;

  /// Constructor del fondo animado
  const AnimatedBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Fondo con gradiente sutil
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.surface,
            const Color(0xFF0A1A30), // Un tono azul profundo para el gradiente
          ],
        ),
      ),
      // Aplicamos una animación de shimmer sutil al fondo
      child: Stack(
        children: [
          // Efecto de partículas sutiles (opcional)
          Positioned.fill(
            child: Opacity(
              opacity: 0.05, // Muy sutil
              child: ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withAlpha(26),
                      Colors.white.withAlpha(51),
                    ],
                    stops: const [0.0, 1.0],
                  ).createShader(rect);
                },
                blendMode: BlendMode.srcOver,
                child: Container(
                  decoration: const BoxDecoration(
                    // Patrón sutil de puntos o líneas
                    image: DecorationImage(
                      image: AssetImage('assets/images/pattern.png'),
                      fit: BoxFit.cover,
                      opacity: 0.05,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Contenido principal
          child,
        ],
      ),
    );
  }
}
