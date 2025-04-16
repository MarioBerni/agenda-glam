import 'package:flutter/material.dart';

/// Modelo de datos para los elementos del carrusel
class CarouselItem {
  final String image;
  final String title;
  final String description;

  CarouselItem({
    required this.image,
    required this.title,
    required this.description,
  });
}

/// Widget de carrusel para mostrar características principales
class FeatureCarousel extends StatefulWidget {
  final List<CarouselItem> items;
  final double height;

  const FeatureCarousel({super.key, required this.items, this.height = 240});

  @override
  State<FeatureCarousel> createState() => _FeatureCarouselState();
}

class _FeatureCarouselState extends State<FeatureCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Colores con opacidad
    final blackWithOpacity = Colors.black.withAlpha(128); // 0.5 * 255 = 128

    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          // PageView para el carrusel
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: blackWithOpacity,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Imagen de fondo (placeholder por ahora)
                      Container(
                        color: colorScheme.surface,
                        child: Center(
                          child: Icon(
                            Icons.image,
                            size: 64,
                            color: colorScheme.onSurface.withAlpha(77), // 0.3 * 255 = 77
                          ),
                        ),
                      ),
                      // Gradiente oscuro para mejorar legibilidad del texto
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withAlpha(179), // 0.7 * 255 = 179
                            ],
                            stops: const [0.6, 1.0],
                          ),
                        ),
                      ),
                      // Texto sobre la imagen
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.items[index].title,
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.items[index].description,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withAlpha(230), // 0.9 * 255 = 230
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Indicadores de página
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.items.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        _currentPage == index
                            ? colorScheme.secondary
                            : colorScheme.onSurface.withAlpha(77), // 0.3 * 255 = 77
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
