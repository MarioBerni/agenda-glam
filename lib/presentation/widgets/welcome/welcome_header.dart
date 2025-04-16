import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Widget para el encabezado de la página de bienvenida
/// Muestra el logo y el nombre de la aplicación
class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo
          SvgPicture.asset(
            'assets/images/logo_agenda_glam.svg',
            height: 40.0,
            colorFilter: const ColorFilter.mode(
              Color(0xFFFFC107), // Color dorado
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 12),
          // Nombre de la aplicación
          Text(
            'AGENDA GLAM',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: colorScheme.secondary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
