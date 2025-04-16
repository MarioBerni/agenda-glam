import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Widget que muestra el encabezado de la pantalla de inicio de sesión
/// con el logo y los textos de bienvenida.
class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Color para textos con opacidad
    final onSurfaceWithOpacity = theme.colorScheme.onSurface.withAlpha(179); // 0.7 * 255 = 179

    return Container(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Column(
        children: [
          // Logo
          SvgPicture.asset(
            'assets/images/logo_agenda_glam.svg',
            height: 120.0,
            // Aplicar color dorado al logo si es monocromático
            colorFilter: const ColorFilter.mode(
              Color(0xFFFFC107), // Color dorado
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 16),
          
          // Texto de bienvenida
          Text(
            'Bienvenido a Agenda Glam',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          
          // Subtítulo
          Text(
            'Tu agenda de servicios estéticos',
            style: theme.textTheme.bodySmall?.copyWith(
              color: onSurfaceWithOpacity,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
