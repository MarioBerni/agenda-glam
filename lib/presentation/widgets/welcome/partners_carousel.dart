import 'package:flutter/material.dart';

/// Widget que muestra un carrusel horizontal de socios/marcas
class PartnersCarousel extends StatelessWidget {
  final List<String> partners;
  final String title;

  const PartnersCarousel({
    super.key,
    required this.partners,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Colores con opacidad
    final onBackgroundWithOpacity = colorScheme.onBackground.withOpacity(0.7);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de sección
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        // Carrusel horizontal de socios/marcas
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: partners.length,
            itemBuilder: (context, index) {
              return Container(
                width: 120,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    Icons.business,
                    size: 32,
                    color: onBackgroundWithOpacity,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
