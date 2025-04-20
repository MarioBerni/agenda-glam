import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Importar los widgets y servicios necesarios
import '../../blocs/auth/auth.dart';
import '../../widgets/common/animated_background.dart';
import 'login_page.dart';
import 'register/register_widgets.dart';

/// Página de registro con diseño moderno y animaciones fluidas
class RegisterPage extends StatefulWidget {
  /// Ruta para la navegación
  static const String routeName = '/register';
  
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with SingleTickerProviderStateMixin {
  // Controladores del formulario
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  
  // Controlador para las animaciones
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;
  
  // Controlador de la página de registro
  late RegisterController _registerController;
  
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
    
    // Inicializar el controlador después de que el widget esté montado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _registerController = RegisterController(context: context);
    });
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
  
  /// Manejar el registro
  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      // Registrar con Firebase a través del BLoC
      _registerController.registerWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }
  
  /// Manejar la navegación a la página de inicio de sesión
  void _handleLogin() {
    Navigator.pushReplacementNamed(
      context,
      LoginPage.routeName,
    );
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
          'Crear Cuenta',
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
              } else if (state.status == AuthStatus.error) {
                setState(() {
                  _isLoading = false;
                });
                // Mostrar mensaje de error
                _registerController.showResultMessage(
                  isSuccess: false,
                  message: state.errorMessage ?? 'Error al registrarse',
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
                      RegisterHeader(
                        fadeInAnimation: _fadeInAnimation,
                        slideAnimation: _slideAnimation,
                      ),
                      
                      // Formulario
                      RegisterForm(
                        nameController: _nameController,
                        emailController: _emailController,
                        phoneController: _phoneController,
                        passwordController: _passwordController,
                        confirmPasswordController: _confirmPasswordController,
                        isLoading: _isLoading,
                        onSubmit: _handleRegister,
                        fadeInAnimation: _fadeInAnimation,
                        slideAnimation: _slideAnimation,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Botones de redes sociales
                      SocialRegisterButtons(
                        onGoogleSignUp: () => _registerController.registerWithGoogle(),
                        fadeInAnimation: _fadeInAnimation,
                        slideAnimation: _slideAnimation,
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Pie de página
                      RegisterFooter(
                        onLogin: _handleLogin,
                        fadeInAnimation: _fadeInAnimation,
                        slideAnimation: _slideAnimation,
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