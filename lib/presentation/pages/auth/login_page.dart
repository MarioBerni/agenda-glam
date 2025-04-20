import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Importar los widgets y servicios necesarios
import '../../blocs/auth/auth.dart';
import '../password_reset_page.dart';
import '../../widgets/common/animated_background.dart';
import 'register_page.dart';
import 'login/login_widgets.dart';

/// Página de inicio de sesión con diseño mejorado siguiendo el patrón de recuperación de contraseña
class LoginPage extends StatefulWidget {
  /// Ruta para la navegación
  static const String routeName = '/login';
  
  /// Indica si el usuario viene de registrarse (para mostrar mensaje de verificación)
  final bool fromRegistration;
  
  const LoginPage({
    super.key,
    this.fromRegistration = false,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  // Controladores del formulario
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _showVerificationMessage = false;
  
  // Controlador para las animaciones
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;
  
  // Controlador de la página de inicio de sesión
  late LoginController _loginController;
  
  @override
  void initState() {
    super.initState();
    
    // Configurar la barra de estado para que sea transparente
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    
    // Configurar animaciones
    _setupAnimations();
    
    // Iniciar animaciones
    _animationController.forward();
    
    // Verificar si viene de registro para mostrar mensaje de verificación
    _showVerificationMessage = widget.fromRegistration;
    
    // Inicializar el controlador después de que el widget esté montado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loginController = LoginController(context: context);
      
      // Mostrar mensaje de verificación si viene de registro
      if (_showVerificationMessage) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _loginController.showVerificationMessage();
        });
      }
    });
  }
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }
  
  /// Configura las animaciones para la página
  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
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
        curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
      ),
    );
  }
  
  /// Manejar el inicio de sesión
  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final identifier = _emailController.text.trim();
      
      // Determinar si es un email o un teléfono
      final bool isEmail = identifier.contains('@');
      
      // Iniciar sesión con Firebase a través del BLoC
      if (isEmail) {
        // Si es un email, usar el método tradicional
        _loginController.loginWithEmailAndPassword(
          email: identifier,
          password: _passwordController.text,
        );
      } else {
        // Si es un teléfono, usar el método de teléfono
        // Implementación futura
      }
    }
  }
  
  /// Manejar la navegación a la página de recuperación de contraseña
  void _handleForgotPassword() {
    Navigator.pushNamed(
      context,
      PasswordResetPage.routeName,
      arguments: _emailController.text,
    );
  }
  
  /// Manejar la navegación a la página de registro
  void _handleRegister() {
    Navigator.pushReplacementNamed(
      context,
      RegisterPage.routeName,
    );
  }
  
  /// Manejar la navegación a la página de verificación de email
  void _handleVerifyEmail() {
    if (_emailController.text.trim().isNotEmpty) {
      Navigator.pushNamed(
        context,
        '/verify-email',
        arguments: _emailController.text.trim(),
      );
    } else {
      _loginController.showResultMessage(
        isSuccess: false,
        message: 'Por favor, ingresa tu correo electrónico primero',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Iniciar Sesión',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: AnimatedBackground(
        child: SafeArea(
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state.status == AuthStatus.authenticated) {
                setState(() {
                  _isLoading = false;
                });
                // Navegar a la página principal
                Navigator.pushReplacementNamed(context, '/home');
              } else if (state.status == AuthStatus.emailNotVerified) {
                setState(() {
                  _isLoading = false;
                  _showVerificationMessage = true;
                });
                // Mostrar mensaje de verificación
                _loginController.showVerificationMessage();
              } else if (state.status == AuthStatus.error) {
                setState(() {
                  _isLoading = false;
                });
                // Mostrar mensaje de error
                _loginController.showResultMessage(
                  isSuccess: false,
                  message: state.errorMessage ?? 'Error al iniciar sesión',
                );
              }
            },
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Encabezado
                      LoginHeader(
                        fadeInAnimation: _fadeInAnimation,
                        slideAnimation: _slideAnimation,
                      ),
                      
                      // Formulario
                      LoginForm(
                        emailController: _emailController,
                        passwordController: _passwordController,
                        isLoading: _isLoading,
                        onSubmit: _handleLogin,
                        onForgotPassword: _handleForgotPassword,
                        fadeInAnimation: _fadeInAnimation,
                        slideAnimation: _slideAnimation,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Botones de redes sociales
                      SocialLoginButtons(
                        onGoogleSignIn: () => _loginController.loginWithGoogle(),
                        fadeInAnimation: _fadeInAnimation,
                        slideAnimation: _slideAnimation,
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Pie de página
                      LoginFooter(
                        onRegister: _handleRegister,
                        fadeInAnimation: _fadeInAnimation,
                        slideAnimation: _slideAnimation,
                      ),
                      
                      // Mensaje de verificación si es necesario
                      if (_showVerificationMessage)
                        FadeTransition(
                          opacity: _fadeInAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: Container(
                              margin: const EdgeInsets.only(top: 16),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.amber.withValues(alpha: 51), // 0.2 * 255 = 51
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.amber),
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    '¿Ya verificaste tu correo electrónico?',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Revisa tu bandeja de entrada y haz clic en el enlace de verificación para activar tu cuenta.',
                                    style: TextStyle(color: Colors.white70),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 12),
                                  TextButton(
                                    onPressed: _handleVerifyEmail,
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.amber,
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    ),
                                    child: const Text('Ir a opciones de verificación'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}