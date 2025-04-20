import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth.dart';
import '../common/animated_form_container.dart';
import '../common/custom_snackbar.dart';
import 'google_sign_in_button.dart';
import 'password_strength_indicator.dart';

/// Widget que contiene el formulario de registro con campos de texto
/// y botón de registro.
class RegisterForm extends StatefulWidget {
  /// Función que se ejecuta cuando se completa el registro
  final VoidCallback? onRegister;
  
  /// Animación de fade in para los elementos del formulario
  final Animation<double>? fadeInAnimation;
  
  /// Animación de deslizamiento para los elementos del formulario
  final Animation<Offset>? slideAnimation;

  const RegisterForm({
    super.key, 
    this.onRegister,
    this.fadeInAnimation,
    this.slideAnimation,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _acceptTerms = false;
  String _currentPassword = '';

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_updatePasswordStrength);
  }

  @override
  void dispose() {
    _passwordController.removeListener(_updatePasswordStrength);
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  
  void _updatePasswordStrength() {
    setState(() {
      _currentPassword = _passwordController.text;
    });
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      if (!_acceptTerms) {
        CustomSnackBar.showWarning(
          context: context,
          message: 'Debes aceptar los términos y condiciones para registrarte.',
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // Registrar con Firebase a través del BLoC
      context.read<AuthBloc>().add(
            SignUpRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text,
              hasAcceptedTerms: _acceptTerms,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final secondaryWithLowOpacity = colorScheme.secondary.withAlpha(26); // 0.1 * 255 = 26
    
    // Escuchar cambios en el estado de autenticación
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // Actualizar estado de carga
        setState(() {
          _isLoading = state.status == AuthStatus.loading;
        });

        if (state.status == AuthStatus.error) {
          // Mostrar mensaje de error con más detalles
          CustomSnackBar.showError(
            context: context,
            message: state.errorMessage ?? 'Error de registro',
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          );
        } else if (state.status == AuthStatus.emailVerificationSent) {
          // Mostrar mensaje de verificación de correo enviada
          CustomSnackBar.showSuccess(
            context: context,
            message: 'Te hemos enviado un correo de verificación. Por favor, revisa tu bandeja de entrada y confirma tu correo.',
            duration: const Duration(seconds: 8),
            onVisible: () {
              // Ejecutar callback si existe después de un breve retraso
              Future.delayed(const Duration(seconds: 2), () {
                if (widget.onRegister != null) {
                  widget.onRegister!();
                }
              });
            },
          );
        }
      },
      child: AnimatedFormContainer(
        delay: const Duration(milliseconds: 200),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: secondaryWithLowOpacity,
                blurRadius: 12,
              ),
            ],
          ),
          child: Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Campo de Email
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      hintText: 'Ingresa tu correo electrónico',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu email';
                      }
                      final emailRegExp = RegExp(
                        r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
                      );
                      if (!emailRegExp.hasMatch(value)) {
                        return 'Por favor ingresa un email válido';
                      }
                      return null;
                    },
                    enabled: !_isLoading,
                  ),
                  
                  const SizedBox(height: 16.0),
                  
                  // Campo de Contraseña
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock_outline),
                      hintText: 'Crea una contraseña segura',
                      helperText: 'Mínimo 6 caracteres',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa una contraseña';
                      }
                      if (value.length < 6) {
                        return 'La contraseña debe tener al menos 6 caracteres';
                      }
                      return null;
                    },
                    enabled: !_isLoading,
                  ),
                  
                  // Indicador de fortaleza de contraseña
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: PasswordStrengthIndicator(password: _currentPassword),
                  ),
                  
                  const SizedBox(height: 16.0),
                  
                  // Campo de Confirmar Contraseña
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirmar Contraseña',
                      prefixIcon: const Icon(Icons.lock_outline),
                      hintText: 'Repite tu contraseña',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscureConfirmPassword,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor confirma tu contraseña';
                      }
                      if (value != _passwordController.text) {
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _isLoading ? null : _handleRegister(),
                    enabled: !_isLoading,
                  ),
                  
                  const SizedBox(height: 16.0),
                  
                  // Aceptar términos y condiciones
                  Row(
                    children: [
                      Checkbox(
                        value: _acceptTerms,
                        onChanged: _isLoading 
                            ? null 
                            : (value) {
                                setState(() {
                                  _acceptTerms = value ?? false;
                                });
                              },
                        activeColor: colorScheme.secondary,
                      ),
                      Expanded(
                        child: Text(
                          'Acepto los términos y condiciones y la política de privacidad',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24.0),
                  
                  // Botón Registrarse
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                    ),
                    onPressed: _isLoading ? null : _handleRegister,
                    child: _isLoading
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                              SizedBox(width: 12),
                              Text('PROCESANDO...'),
                            ],
                          )
                        : const Text('REGISTRARSE'),
                  ),
                  
                  const SizedBox(height: 16.0),
                  
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'O',
                          style: TextStyle(color: colorScheme.onSurface.withAlpha(128)),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  
                  const SizedBox(height: 16.0),
                  
                  // Botón de Google
                  GoogleSignInButton(onSignIn: widget.onRegister),
                  
                  const SizedBox(height: 16.0),
                  
                  // Nota sobre verificación de correo
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withAlpha(20),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.withAlpha(50)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.blue),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Después de registrarte, te enviaremos un correo de verificación. Por favor, revisa tu bandeja de entrada y confirma tu correo.',
                            style: theme.textTheme.bodySmall,
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
    );
  }
}
