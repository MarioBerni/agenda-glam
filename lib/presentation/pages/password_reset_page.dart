import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth.dart';
import 'password_reset/success_message.dart';
import 'password_reset/reset_form.dart';
import 'password_reset/password_reset_controller.dart';
import 'password_reset/animated_container.dart';

/// Enum para los métodos de recuperación de contraseña
enum RecoveryMethod {
  /// Recuperación por correo electrónico
  email,
  
  /// Recuperación por número de teléfono
  phone,
}

/// Página para solicitar el restablecimiento de contraseña
class PasswordResetPage extends StatefulWidget {
  /// Ruta para la navegación
  static const String routeName = '/password-reset';

  /// Constructor de la página de restablecimiento de contraseña
  /// 
  /// [showSuccessMessage] - Si es true, muestra directamente el mensaje de éxito
  const PasswordResetPage({super.key, this.showSuccessMessage = false});
  
  /// Indica si se debe mostrar el mensaje de éxito
  final bool showSuccessMessage;

  @override
  State<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> with SingleTickerProviderStateMixin {
  // Controlador de restablecimiento
  late PasswordResetController _resetController;
  
  // Controladores y estado del formulario
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _smsCodeController = TextEditingController();
  String _completePhoneNumber = '';
  String _verificationId = '';
  bool _isLoading = false;
  late bool _resetSent;
  bool _codeSent = false;
  PhoneVerificationStatus _phoneStatus = PhoneVerificationStatus.codeSent;
  
  // Método de recuperación seleccionado (email o teléfono)
  RecoveryMethod _recoveryMethod = RecoveryMethod.email;
  
  // Controlador para la animación
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // Inicializar el estado de resetSent según el parámetro showSuccessMessage
    _resetSent = widget.showSuccessMessage;
    
    // Configurar animaciones
    _setupAnimations();
    
    // Obtener el email de los argumentos de la ruta, si existe
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Inicializar el controlador de restablecimiento después de que el widget esté montado
      _resetController = PasswordResetController(context: context);
      
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is String) {
        setState(() {
          _emailController.text = args;
        });
      }
    });
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
        curve: const Interval(0.0, 0.65, curve: Curves.easeOutCubic),
      ),
    );
    
    // Iniciar animación
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _smsCodeController.dispose();
    _animationController.dispose();
    super.dispose();
  }
  
  /// Maneja la solicitud de restablecimiento de contraseña
  Future<void> _handleResetRequest() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      if (_recoveryMethod == RecoveryMethod.email) {
        // Solicitar restablecimiento de contraseña por email
        _resetController.requestEmailReset(_emailController.text);
      } else {
        // Recuperación por SMS
        if (!_codeSent) {
          await _sendVerificationCode();
        } else {
          await _verifyCode();
        }
      }
    }
  }
  
  /// Envía un código de verificación al número de teléfono
  Future<void> _sendVerificationCode() async {
    await _resetController.sendVerificationCode(
      phoneNumber: _completePhoneNumber,
      onVerificationIdReceived: (verificationId) {
        setState(() {
          _verificationId = verificationId;
          _codeSent = true;
        });
      },
      onLoading: () {
        setState(() {
          _isLoading = true;
        });
      },
      onComplete: () {
        setState(() {
          _isLoading = false;
        });
      },
    );
  }
  
  /// Verifica el código SMS ingresado
  Future<void> _verifyCode() async {
    if (!mounted) return;
    
    await _resetController.verifyCode(
      verificationId: _verificationId,
      smsCode: _smsCodeController.text,
      onLoading: () {
        setState(() {
          _isLoading = true;
        });
      },
      onComplete: () {
        setState(() {
          _isLoading = false;
        });
      },
      onStatusChanged: (status) {
        setState(() {
          _phoneStatus = status;
          _resetSent = status == PhoneVerificationStatus.verified;
        });
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar Contraseña'),
        elevation: 0,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: _handleAuthStateChanges,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: _resetSent
                ? SuccessMessage(
                    fadeInAnimation: _fadeInAnimation,
                    slideAnimation: _slideAnimation,
                    recoveryMethod: _recoveryMethod,
                    emailAddress: _emailController.text,
                    phoneNumber: _completePhoneNumber,
                    phoneStatus: _phoneStatus,
                    onResendPressed: _handleResendRequest,
                  )
                : _buildResetForm(),
          ),
        ),
      ),
    );
  }
  
  /// Maneja los cambios de estado de autenticación
  void _handleAuthStateChanges(BuildContext context, AuthState state) {
    setState(() {
      _isLoading = state.status == AuthStatus.loading;
    });
    
    if (state.status == AuthStatus.passwordResetSent) {
      setState(() {
        _resetSent = true;
      });
      
      // Mostrar mensaje de éxito para recuperación por email
      if (_recoveryMethod == RecoveryMethod.email && mounted) {
        _resetController.showResultMessage(
          isSuccess: true,
          message: 'Se ha enviado un correo de recuperación a ${_emailController.text}',
        );
      }
    } else if (state.status == AuthStatus.error && mounted) {
      // Mostrar mensaje de error
      _resetController.showResultMessage(
        isSuccess: false,
        message: state.errorMessage ?? 'Error al procesar la solicitud de recuperación',
      );
    }
  }
  
  /// Maneja la solicitud de reenvío
  void _handleResendRequest() {
    setState(() {
      _resetSent = false;
      _codeSent = false;
    });
  }
  
  /// Construye el formulario de recuperación
  Widget _buildResetForm() {
    return AnimatedResetContainer(
      fadeInAnimation: _fadeInAnimation,
      slideAnimation: _slideAnimation,
      child: ResetForm(
        formKey: _formKey,
        emailController: _emailController,
        phoneController: _phoneController,
        smsCodeController: _smsCodeController,
        recoveryMethod: _recoveryMethod,
        isLoading: _isLoading,
        codeSent: _codeSent,
        onMethodChanged: (method) {
          setState(() {
            _recoveryMethod = method;
          });
        },
        onPhoneChanged: (phone) {
          _completePhoneNumber = phone.completeNumber;
        },
        onSubmit: _handleResetRequest,
        onCancel: () => Navigator.of(context).pop(),
        fadeInAnimation: _fadeInAnimation,
        slideAnimation: _slideAnimation,
      ),
    );
  }
}