import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/auth.dart';
import '../../widgets/auth/sms_code_input.dart';
import '../../widgets/common/animated_background.dart';

/// Página para verificación de número de teléfono mediante código SMS
class PhoneVerificationPage extends StatefulWidget {
  /// Ruta para la navegación
  static const String routeName = '/phone-verification';

  /// ID de verificación recibido de Firebase
  final String verificationId;
  
  /// Número de teléfono que se está verificando
  final String phoneNumber;
  
  /// Contraseña para el registro (solo si es para registro)
  final String? password;
  
  /// Indica si es para registro o inicio de sesión
  final bool isForRegistration;

  const PhoneVerificationPage({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
    this.password,
    this.isForRegistration = false,
  });

  @override
  State<PhoneVerificationPage> createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> with SingleTickerProviderStateMixin {
  final _smsCodeController = TextEditingController();
  bool _isLoading = false;
  bool _isResending = false;
  
  // Controlador para las animaciones
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;
  
  // Contador para reenvío de código
  int _resendCountdown = 60;
  bool _canResend = false;

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
    
    // Iniciar contador para reenvío
    _startResendTimer();
  }
  
  @override
  void dispose() {
    _smsCodeController.dispose();
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
  
  /// Inicia el contador para permitir reenviar el código
  void _startResendTimer() {
    setState(() {
      _resendCountdown = 60;
      _canResend = false;
    });
    
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _resendCountdown--;
        });
        
        if (_resendCountdown > 0) {
          _startResendTimer();
        } else {
          setState(() {
            _canResend = true;
          });
        }
      }
    });
  }
  
  /// Manejar la verificación del código SMS
  void _handleVerifySmsCode() {
    if (_smsCodeController.text.length == 6) {
      setState(() {
        _isLoading = true;
      });
      
      // Verificar el código SMS
      if (widget.isForRegistration && widget.password != null) {
        // Para registro con teléfono
        context.read<AuthBloc>().add(
          VerifySmsCodeRequested(
            verificationId: widget.verificationId,
            smsCode: _smsCodeController.text,
            password: widget.password,
          ),
        );
      } else {
        // Para inicio de sesión con teléfono
        context.read<AuthBloc>().add(
          VerifySmsCodeRequested(
            verificationId: widget.verificationId,
            smsCode: _smsCodeController.text,
          ),
        );
      }
    } else {
      // Mostrar error si el código no está completo
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingresa el código completo de 6 dígitos'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  /// Manejar el reenvío del código SMS
  void _handleResendCode() {
    if (_canResend && !_isResending) {
      setState(() {
        _isResending = true;
      });
      
      // Solicitar nuevo código
      context.read<AuthBloc>().add(
        PhoneVerificationRequested(
          phoneNumber: widget.phoneNumber,
          isForRegistration: widget.isForRegistration,
        ),
      );
      
      // Reiniciar contador
      _startResendTimer();
    }
  }
  
  /// Manejar la cancelación y volver a la página anterior
  void _handleCancel() {
    Navigator.of(context).pop();
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
          'Verificación por SMS',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: AnimatedBackground(
        child: SafeArea(
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              // Desactivar indicadores de carga
              if (state.status != AuthStatus.loading) {
                setState(() {
                  _isLoading = false;
                  _isResending = false;
                });
              }
              
              // Manejar los diferentes estados
              if (state.status == AuthStatus.authenticated || 
                  state.status == AuthStatus.phoneVerified) {
                // Si es para registro y se verificó, navegar a la página principal
                Navigator.pushReplacementNamed(context, '/home');
              } else if (state.status == AuthStatus.phoneVerificationSent) {
                // Si se reenvió el código, mostrar mensaje
                if (_isResending) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Código reenviado. Revisa tus mensajes.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } else if (state.status == AuthStatus.error) {
                // Mostrar mensaje de error
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage ?? 'Error al verificar el código'),
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
                        // Icono
                        const Icon(
                          Icons.sms,
                          size: 80,
                          color: Colors.amber,
                        ),
                        const SizedBox(height: 24),
                        
                        // Título
                        const Text(
                          'Verificación de teléfono',
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
                          'Hemos enviado un código de verificación al número:\n${widget.phoneNumber}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        
                        const Text(
                          'Ingresa el código de 6 dígitos para verificar tu número',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        
                        // Campo para el código SMS
                        SmsCodeInput(
                          controller: _smsCodeController,
                          enabled: !_isLoading,
                          onCompleted: (_) => _handleVerifySmsCode(),
                        ),
                        const SizedBox(height: 32),
                        
                        // Botón para verificar
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _isLoading ? null : _handleVerifySmsCode,
                          child: _isLoading
                              ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text('Verificando...'),
                                  ],
                                )
                              : const Text('VERIFICAR CÓDIGO'),
                        ),
                        const SizedBox(height: 16),
                        
                        // Botón para reenviar código
                        TextButton(
                          onPressed: _canResend && !_isResending ? _handleResendCode : null,
                          style: TextButton.styleFrom(
                            foregroundColor: _canResend ? Colors.amber : Colors.white60,
                          ),
                          child: _isResending
                              ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.amber,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text('Reenviando...'),
                                  ],
                                )
                              : Text(_canResend 
                                  ? 'Reenviar código' 
                                  : 'Reenviar código en $_resendCountdown s'),
                        ),
                        const SizedBox(height: 8),
                        
                        // Botón para cancelar
                        TextButton(
                          onPressed: _isLoading ? null : _handleCancel,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white70,
                          ),
                          child: const Text('Cancelar'),
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
