import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth.dart';
import '../common/animated_form_container.dart';
import '../common/custom_snackbar.dart';
import 'google_sign_in_button.dart';

/// Widget que contiene el formulario de inicio de sesión con campos de texto,
/// opción de recordar contraseña y botón de inicio de sesión.
class LoginForm extends StatefulWidget {
  /// Función que se ejecuta cuando se intenta iniciar sesión
  final VoidCallback? onLogin;
  
  /// Función que se ejecuta cuando se presiona el botón de olvidar contraseña
  final VoidCallback? onForgotPassword;
  
  /// Animación de fade in para los elementos del formulario
  final Animation<double>? fadeInAnimation;
  
  /// Animación de deslizamiento para los elementos del formulario
  final Animation<Offset>? slideAnimation;

  const LoginForm({
    super.key, 
    this.onLogin,
    this.onForgotPassword,
    this.fadeInAnimation,
    this.slideAnimation,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
        context.read<AuthBloc>().add(
              SignInRequested(
                email: identifier,
                password: _passwordController.text,
              ),
            );
      } else {
        // Si es un teléfono, verificar que tenga el formato correcto
        String phoneNumber = identifier;
        
        // Asegurarse de que tenga el formato internacional
        if (!phoneNumber.startsWith('+')) {
          // Si no tiene el prefijo internacional, añadir el de Uruguay
          if (phoneNumber.startsWith('0')) {
            // Quitar el 0 inicial si existe
            phoneNumber = phoneNumber.substring(1);
          }
          // Añadir el código de país de Uruguay
          phoneNumber = '+598$phoneNumber';
        }
        
        // Solicitar verificación por teléfono
        context.read<AuthBloc>().add(
              PhoneVerificationRequested(
                phoneNumber: phoneNumber,
              ),
            );
      }
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
          // Mostrar mensaje de error con más detalles usando CustomSnackBar
          CustomSnackBar.showError(
            context: context,
            message: state.errorMessage ?? 'Error de autenticación',
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          );
        } else if (state.status == AuthStatus.authenticated) {
          // Mostrar mensaje de éxito antes de cerrar el modal
          CustomSnackBar.showSuccess(
            context: context,
            message: '¡Inicio de sesión exitoso!',
            duration: const Duration(seconds: 2),
            onVisible: () {
              // Ejecutar callback si existe después de un breve retraso
              Future.delayed(const Duration(milliseconds: 500), () {
                if (widget.onLogin != null) {
                  widget.onLogin!();
                }
              });
            },
          );
        } else if (state.status == AuthStatus.emailNotVerified) {
          // Mostrar mensaje de que el email no está verificado
          CustomSnackBar.showWarning(
            context: context,
            message: 'Tu correo electrónico no ha sido verificado. Por favor, verifica tu bandeja de entrada.',
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Reenviar',
              textColor: Colors.white,
              onPressed: () {
                context.read<AuthBloc>().add(SendEmailVerificationRequested());
              },
            ),
          );
        }
      },
      child: AnimatedFormContainer(
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
                  // Campo de Email/Teléfono
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email o Teléfono',
                      prefixIcon: Icon(Icons.person_outline),
                      hintText: 'Ingresa tu correo o número de teléfono',
                      helperText: 'Puedes usar tu email o número con código de país (+598)',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu email o teléfono';
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
                      hintText: 'Ingresa tu contraseña',
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
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu contraseña';
                      }
                      if (value.length < 6) {
                        return 'La contraseña debe tener al menos 6 caracteres';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _isLoading ? null : _handleLogin(),
                    enabled: !_isLoading,
                  ),
                  
                  const SizedBox(height: 16.0),
                  
                  // Opción Recordarme
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: _isLoading 
                            ? null 
                            : (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                        activeColor: colorScheme.secondary,
                      ),
                      const Text('Recordarme'),
                      
                      const Spacer(),
                      
                      // Olvidé mi contraseña
                      TextButton(
                        onPressed: _isLoading 
                            ? null 
                            : () {
                                // Obtener el email si está disponible (opcional)
                                final email = _emailController.text.trim();
                                
                                // Navegar directamente a la página de recuperación
                                Navigator.of(context).pushNamed(
                                  '/password-reset',
                                  // Pasar el email como argumento solo si está disponible
                                  arguments: email.isNotEmpty ? email : null,
                                );
                              },
                        child: Text(
                          'Olvidé mi contraseña',
                          style: TextStyle(
                            color: _isLoading ? colorScheme.secondary.withAlpha(128) : colorScheme.secondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24.0),
                  
                  // Botón Iniciar Sesión
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                    ),
                    onPressed: _isLoading ? null : _handleLogin,
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
                              Text('INICIANDO SESIÓN...'),
                            ],
                          )
                        : const Text('INICIAR SESIÓN'),
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
                  GoogleSignInButton(onSignIn: widget.onLogin),
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
