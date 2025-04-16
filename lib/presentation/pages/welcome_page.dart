import 'package:flutter/material.dart';

// Importar widgets modulares
import '../widgets/welcome/welcome_widgets.dart';
// Importar el modal de inicio de sesión
import '../widgets/auth/login_modal.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Datos para el carrusel de características
    final List<CarouselItem> carouselItems = [
      CarouselItem(
        image: 'assets/images/carousel1.jpg',
        title: 'Servicios de Barbería',
        description: 'Cortes modernos y afeitados profesionales',
      ),
      CarouselItem(
        image: 'assets/images/carousel2.jpg',
        title: 'Tratamientos Faciales',
        description: 'Cuida tu piel con tratamientos especializados',
      ),
      CarouselItem(
        image: 'assets/images/carousel3.jpg',
        title: 'Masajes y Relajación',
        description: 'Reduce el estrés y mejora tu bienestar',
      ),
    ];

    // Datos para los beneficios
    final List<BenefitItem> benefits = [
      BenefitItem(
        icon: Icons.calendar_today,
        title: 'Reservas Fáciles',
        description: 'Agenda tus citas en segundos, sin llamadas ni esperas',
      ),
      BenefitItem(
        icon: Icons.location_on,
        title: 'Encuentra Cerca',
        description: 'Descubre los mejores servicios cerca de ti',
      ),
      BenefitItem(
        icon: Icons.star,
        title: 'Servicios Premium',
        description: 'Accede a los mejores profesionales y servicios exclusivos',
      ),
      BenefitItem(
        icon: Icons.local_offer,
        title: 'Ofertas Especiales',
        description: 'Aprovecha descuentos y promociones exclusivas',
      ),
    ];

    // Datos para los socios
    final List<String> partners = [
      'assets/images/partner1.png',
      'assets/images/partner2.png',
      'assets/images/partner3.png',
      'assets/images/partner4.png',
      'assets/images/partner5.png',
    ];

    return Scaffold(
      body: Container(
        // Fondo con gradiente sutil
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.background,
              const Color(0xFF0A1A30), // Un tono ligeramente más claro para el gradiente
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Encabezado con logo y nombre
                const WelcomeHeader(),
                
                // Carrusel principal de características
                FeatureCarousel(items: carouselItems),
                
                // Botones de acción
                ActionButtons(
                  onRegister: () {
                    // Por ahora usamos el mismo modal de inicio de sesión
                    // TODO: Implementar un modal específico para registro
                    showLoginModal(context);
                  },
                  onLogin: () {
                    // Mostrar el modal de inicio de sesión
                    showLoginModal(context);
                  },
                ),
                
                // Sección de beneficios
                BenefitsGrid(
                  title: 'Por qué elegir Agenda Glam',
                  benefits: benefits,
                ),
                
                // Sección de socios/marcas
                PartnersCarousel(
                  title: 'Nuestros Socios',
                  partners: partners,
                ),
                
                // Espacio inferior
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
