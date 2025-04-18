import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth.dart';
import '../widgets/common/custom_snackbar.dart';

/// Página de bienvenida que se muestra después del primer inicio de sesión
class WelcomeAfterLoginPage extends StatefulWidget {
  /// Ruta para la navegación
  static const String routeName = '/welcome-after-login';

  /// Constructor de la página de bienvenida después del inicio de sesión
  const WelcomeAfterLoginPage({super.key});

  @override
  State<WelcomeAfterLoginPage> createState() => _WelcomeAfterLoginPageState();
}

class _WelcomeAfterLoginPageState extends State<WelcomeAfterLoginPage> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  final int _totalPages = 3;
  
  // Controlador para la animación
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _pageController = PageController(initialPage: 0);
    
    // Configurar animaciones
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
      ),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOutCubic),
      ),
    );
    
    // Iniciar animación
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }
  
  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      // Última página, ir a la página principal
      _finishOnboarding();
    }
  }
  
  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
  
  void _finishOnboarding() {
    // Marcar que el usuario ha visto el onboarding
    // Aquí se podría guardar una preferencia en SharedPreferences
    
    // Navegar a la página principal
    Navigator.of(context).pushReplacementNamed('/home');
    
    // Mostrar mensaje de bienvenida
    CustomSnackBar.showSuccess(
      context: context,
      message: '¡Bienvenido a Agenda Glam! Estamos felices de tenerte con nosotros.',
      duration: const Duration(seconds: 5),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthBloc>().state.user;
    final userModel = context.read<AuthBloc>().state.userModel;
    final userName = userModel?.displayName ?? user?.displayName ?? 'Usuario';
    
    return Scaffold(
      body: Stack(
        children: [
          // Fondo con gradiente
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.primary.withAlpha(204), // 0.8 * 255 = 204
                  Theme.of(context).colorScheme.secondary.withAlpha(153), // 0.6 * 255 = 153
                ],
              ),
            ),
          ),
          
          // Contenido principal
          SafeArea(
            child: Column(
              children: [
                // Indicador de páginas
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _totalPages,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Colors.white
                              : Colors.white.withAlpha(102), // 0.4 * 255 = 102
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Páginas de onboarding
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (page) {
                      setState(() {
                        _currentPage = page;
                      });
                      
                      // Reiniciar animación en cada cambio de página
                      _animationController.reset();
                      _animationController.forward();
                    },
                    children: [
                      _buildWelcomePage(userName),
                      _buildFeaturesPage(),
                      _buildGetStartedPage(),
                    ],
                  ),
                ),
                
                // Botones de navegación
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Botón Atrás
                      _currentPage > 0
                          ? TextButton(
                              onPressed: _previousPage,
                              child: const Text(
                                'ATRÁS',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : const SizedBox(width: 80),
                      
                      // Botón Omitir
                      TextButton(
                        onPressed: _finishOnboarding,
                        child: const Text(
                          'OMITIR',
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      
                      // Botón Siguiente
                      ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Theme.of(context).colorScheme.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          _currentPage == _totalPages - 1 ? 'COMENZAR' : 'SIGUIENTE',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildWelcomePage(String userName) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Imagen de bienvenida
              Image.asset(
                'assets/images/welcome.png',
                height: 200,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(51), // 0.2 * 255 = 51
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 100,
                      color: Colors.white,
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              
              // Texto de bienvenida
              Text(
                '¡Hola, $userName!',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Bienvenido a Agenda Glam, tu aplicación para gestionar citas de belleza y bienestar.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildFeaturesPage() {
    final features = [
      {
        'icon': Icons.calendar_today,
        'title': 'Reserva Citas',
        'description': 'Agenda tus citas de forma rápida y sencilla.',
      },
      {
        'icon': Icons.notifications,
        'title': 'Recordatorios',
        'description': 'Recibe notificaciones antes de tus citas.',
      },
      {
        'icon': Icons.history,
        'title': 'Historial',
        'description': 'Accede a tu historial de servicios.',
      },
    ];
    
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Características',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              
              // Lista de características
              ...features.map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(51), // 0.2 * 255 = 51
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        feature['icon'] as IconData,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            feature['title'] as String,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            feature['description'] as String,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withAlpha(204), // 0.8 * 255 = 204
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildGetStartedPage() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(51), // 0.2 * 255 = 51
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  size: 80,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                '¡Todo listo!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Ya estás listo para comenzar a usar Agenda Glam. Explora los servicios disponibles y agenda tu primera cita.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
