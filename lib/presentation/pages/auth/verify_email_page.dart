import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/auth.dart';
import '../../widgets/common/animated_background.dart';
import 'login_page.dart';

/// Página de verificación de correo electrónico
class VerifyEmailPage extends StatefulWidget {
  /// Ruta para la navegación
  static const String routeName = '/verify-email';

  /// Correo electrónico a verificar
  final String email;

  const VerifyEmailPage({
    super.key,
    required this.email,
  });

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  bool _emailSent = false;
  
  // Controlador para las animaciones
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;

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
  }
  
  @override
  void dispose() {
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
  
  /// Manejar el reenvío del correo de verificación
  void _handleResendEmail() {
    setState(() {
      _isLoading = true;
    });
    
    // Solicitar reenvío del correo de verificación
    context.read<AuthBloc>().add(SendEmailVerificationRequested());
  }
  
  /// Manejar la verificación manual de la cuenta
  void _handleCheckVerification() {
    setState(() {
      _isLoading = true;
    });
    
    // Recargar el usuario para verificar si el correo ya está verificado
    context.read<AuthBloc>().add(ReloadUserRequested());
  }
  
  /// Manejar la navegación a la página de inicio de sesión
  void _handleBackToLogin() {
    Navigator.pushReplacementNamed(
      context,
      LoginPage.routeName,
    );
  }
  
  /// Manejar la navegación al soporte
  void _handleContactSupport() {
    // Aquí se podría abrir un correo, chat o formulario de contacto
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Función de soporte en desarrollo'),
        backgroundColor: Colors.blue,
      ),
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
          'Verificación de Correo',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: AnimatedBackground(
        child: SafeArea(
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              // Desactivar el indicador de carga cuando cambia el estado
              if (state.status != AuthStatus.loading) {
                setState(() {
                  _isLoading = false;
                });
              }
              
              // Manejar los diferentes estados
              if (state.status == AuthStatus.authenticated) {
                // Si el usuario está autenticado, navegar a la página principal
                Navigator.pushReplacementNamed(context, '/home');
              } else if (state.status == AuthStatus.emailVerificationSent) {
                setState(() {
                  _emailSent = true;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Correo de verificación enviado. Revisa tu bandeja de entrada.'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (state.status == AuthStatus.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage ?? 'Error al verificar el correo'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: FadeTransition(
                  opacity: _fadeInAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Icono de verificación
                        const Icon(
                          Icons.mark_email_unread,
                          size: 80,
                          color: Colors.amber,
                        ),
                        const SizedBox(height: 24),
                        
                        // Título
                        const Text(
                          'Verifica tu correo electrónico',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        
                        // Mensaje
                        Text(
                          'Hemos enviado un correo de verificación a:\n${widget.email}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        
                        const Text(
                          'Revisa tu bandeja de entrada y haz clic en el enlace para activar tu cuenta.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        
                        // Botón para reenviar correo
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _isLoading ? null : _handleResendEmail,
                          icon: _isLoading 
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.black,
                                  ),
                                )
                              : const Icon(Icons.send),
                          label: Text(_emailSent ? 'Reenviar correo' : 'Enviar correo de verificación'),
                        ),
                        const SizedBox(height: 16),
                        
                        // Botón para verificar manualmente
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white54),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _isLoading ? null : _handleCheckVerification,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Ya verifiqué mi correo'),
                        ),
                        const SizedBox(height: 16),
                        
                        // Botón para volver al login
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white70,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: _handleBackToLogin,
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Volver a inicio de sesión'),
                        ),
                        const SizedBox(height: 32),
                        
                        // Sección de ayuda
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 13), // 0.05 * 255 = 12.75 ≈ 13
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '¿Necesitas ayuda?',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '• Revisa tu carpeta de spam o correo no deseado\n'
                                '• Verifica que hayas ingresado el correo correcto\n'
                                '• Si el problema persiste, contacta con soporte',
                                style: TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Center(
                                child: TextButton.icon(
                                  onPressed: _handleContactSupport,
                                  icon: const Icon(Icons.support_agent),
                                  label: const Text('Contactar soporte'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.amber,
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}
