import 'package:flutter/material.dart';

/// Encabezado para la página de registro
class RegisterHeader extends StatelessWidget {
  /// Constructor del encabezado de registro
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Logo de la aplicación
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(26),
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Título de bienvenida
        Text(
          'Crear una cuenta',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 8),
        
        // Subtítulo informativo
        Text(
          'Completa tus datos para comenzar a usar Agenda Glam',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white.withAlpha(179),
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 16),
      ],
    );
  }
}
