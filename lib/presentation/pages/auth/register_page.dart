import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Importar los widgets y servicios necesarios
import '../../../core/enums/auth_method.dart';
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
  
  // Método de autenticación seleccionado
  AuthMethod _authMethod = AuthMethod.email;
  
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
      
      // Iniciar temporizador para evitar que se quede cargando indefinidamente
      _startRegistrationTimeout();
      
      if (_authMethod == AuthMethod.email) {
        // Registro por email
        _registerController.registerWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
      } else {
        // Registro por teléfono - ahora el número ya incluye el código de país
        // gracias al widget IntlPhoneField
        _registerController.registerWithPhoneNumber(
          phoneNumber: _phoneController.text,
          password: _passwordController.text,
        );
      }
    }
  }
  
  /// Iniciar temporizador para evitar que se quede cargando indefinidamente
  void _startRegistrationTimeout() {
    Future.delayed(const Duration(seconds: 15), () {
      // Verificar si el widget sigue montado antes de actualizar el estado
      if (!mounted) return;
      
      if (_isLoading) {
        setState(() {
          _isLoading = false;
        });
        // Usar el contexto actual, ya que verificamos que el widget sigue montado
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('La operación ha tardado demasiado. Por favor, inténtalo de nuevo.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
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
              // Siempre desactivar el estado de carga cuando cambia el estado (excepto loading)
              if (state.status != AuthStatus.loading) {
                setState(() {
                  _isLoading = false;
                });
              }
              
              // Manejar los diferentes estados
              if (state.status == AuthStatus.authenticated) {
                // Navegar a la página principal
                Navigator.pushReplacementNamed(context, '/home');
              } else if (state.status == AuthStatus.emailNotVerified) {
                // Mostrar mensaje de verificación de correo
                _registerController.showResultMessage(
                  isSuccess: true,
                  message: 'Registro exitoso. Por favor, verifica tu correo electrónico.',
                );
                
                // Programar la navegación a la página de login después de un delay
                // Usamos una bandera para controlar si debemos navegar
                bool shouldNavigate = true;
                
                // Definir la acción de navegación
                void navigateToLogin() {
                  // Navegar a la página de login con indicador de que viene de registro
                  Navigator.of(context).pushReplacementNamed(
                    '/login',
                    arguments: true, // Indica que viene de registro
                  );
                }
                
                // Ejecutar la navegación inmediatamente, sin delay
                // Esto evita el problema de uso de BuildContext a través de gaps asíncronos
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  // Verificar si todavía debemos navegar
                  if (shouldNavigate) {
                    // Esperar 2 segundos antes de navegar
                    Future.delayed(const Duration(seconds: 2), () {
                      // Cancelar la navegación si el widget ya no está montado
                      if (mounted && shouldNavigate) {
                        navigateToLogin();
                      }
                    });
                  }
                });
                
                // Asegurarse de que no navegamos si el widget se desmonta
                // antes de que se complete el delay
                addPostFrameCallback() {
                  if (!mounted) {
                    shouldNavigate = false;
                  }
                }
                
                // Registrar el callback para verificar si el widget sigue montado
                WidgetsBinding.instance.addPostFrameCallback((_) => addPostFrameCallback());
              } else if (state.status == AuthStatus.error) {
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
                        authMethod: _authMethod,
                        onAuthMethodChanged: (method) {
                          setState(() {
                            _authMethod = method;
                          });
                        },
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