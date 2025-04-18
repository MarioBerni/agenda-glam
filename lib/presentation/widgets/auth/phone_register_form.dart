import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../blocs/auth/auth.dart';
import '../common/animated_form_container.dart';
import '../common/custom_snackbar.dart';

/// Widget que contiene el formulario de registro con número de teléfono
class PhoneRegisterForm extends StatefulWidget {
  /// Función que se ejecuta cuando se completa el registro
  final VoidCallback? onRegister;

  const PhoneRegisterForm({super.key, this.onRegister});

  @override
  State<PhoneRegisterForm> createState() => _PhoneRegisterFormState();
}

class _PhoneRegisterFormState extends State<PhoneRegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _smsCodeController = TextEditingController();
  final _emailController = TextEditingController(); // Opcional para vincular email
  final _passwordController = TextEditingController(); // Opcional para vincular email
  
  bool _isLoading = false;
  bool _acceptTerms = false;
  bool _codeSent = false;
  String _completePhoneNumber = '';
  String _verificationId = '';

  @override
  void dispose() {
    _phoneController.dispose();
    _smsCodeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handlePhoneVerification() {
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

      if (!_codeSent) {
        // Solicitar verificación de teléfono
        context.read<AuthBloc>().add(
          PhoneVerificationRequested(
            phoneNumber: _completePhoneNumber,
            isForRegistration: true,
          ),
        );
      } else {
        // Verificar código SMS
        context.read<AuthBloc>().add(
          VerifySmsCodeRequested(
            verificationId: _verificationId,
            smsCode: _smsCodeController.text.trim(),
            email: _emailController.text.isNotEmpty ? _emailController.text.trim() : null,
            password: _passwordController.text.isNotEmpty ? _passwordController.text : null,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final secondaryWithLowOpacity = colorScheme.secondary.withAlpha(26);
    
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // Actualizar estado de carga
        setState(() {
          _isLoading = state.status == AuthStatus.loading;
        });

        if (state.status == AuthStatus.phoneVerificationSent) {
          setState(() {
            _codeSent = true;
            _verificationId = state.verificationId!;
            _isLoading = false;
          });
          
          CustomSnackBar.showSuccess(
            context: context,
            message: 'Se ha enviado un código de verificación a tu número de teléfono.',
          );
        } else if (state.status == AuthStatus.phoneVerified || 
                  state.status == AuthStatus.authenticated) {
          CustomSnackBar.showSuccess(
            context: context,
            message: 'Registro exitoso. ¡Bienvenido!',
            duration: const Duration(seconds: 5),
            onVisible: () {
              // Ejecutar callback si existe después de un breve retraso
              Future.delayed(const Duration(seconds: 2), () {
                if (widget.onRegister != null) {
                  widget.onRegister!();
                }
              });
            },
          );
        } else if (state.status == AuthStatus.error || 
                  state.status == AuthStatus.phoneVerificationError) {
          CustomSnackBar.showError(
            context: context,
            message: state.errorMessage ?? 'Error en la verificación',
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
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
                    if (!_codeSent) ...[
                      // Campo de teléfono
                      IntlPhoneField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Número de teléfono',
                          hintText: 'Ingresa tu número de teléfono',
                        ),
                        initialCountryCode: 'UY', // Uruguay
                        onChanged: (phone) {
                          _completePhoneNumber = phone.completeNumber;
                        },
                        validator: (phone) {
                          if (phone == null || phone.number.isEmpty) {
                            return 'Por favor ingresa tu número de teléfono';
                          }
                          return null;
                        },
                        enabled: !_isLoading,
                      ),
                      
                      const SizedBox(height: 16.0),
                      
                      // Campos opcionales para vincular email
                      ExpansionTile(
                        title: const Text('Vincular con email (opcional)'),
                        children: [
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email (opcional)',
                              prefixIcon: Icon(Icons.email_outlined),
                              hintText: 'Ingresa tu correo electrónico',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                final emailRegExp = RegExp(
                                  r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
                                );
                                if (!emailRegExp.hasMatch(value)) {
                                  return 'Por favor ingresa un email válido';
                                }
                              }
                              return null;
                            },
                            enabled: !_isLoading,
                          ),
                          
                          const SizedBox(height: 16.0),
                          
                          TextFormField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Contraseña (opcional)',
                              prefixIcon: Icon(Icons.lock_outline),
                              hintText: 'Crea una contraseña',
                              helperText: 'Mínimo 6 caracteres',
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value != null && value.isNotEmpty && value.length < 6) {
                                return 'La contraseña debe tener al menos 6 caracteres';
                              }
                              return null;
                            },
                            enabled: !_isLoading,
                          ),
                        ],
                      ),
                    ] else ...[
                      // Campo de código SMS
                      TextFormField(
                        controller: _smsCodeController,
                        decoration: const InputDecoration(
                          labelText: 'Código de verificación',
                          prefixIcon: Icon(Icons.sms_outlined),
                          hintText: 'Ingresa el código recibido por SMS',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa el código de verificación';
                          }
                          return null;
                        },
                        enabled: !_isLoading,
                      ),
                      
                      const SizedBox(height: 8.0),
                      
                      // Información sobre el número al que se envió el código
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
                                'Se ha enviado un código de verificación al número $_completePhoneNumber',
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 8.0),
                      
                      // Botón para reenviar código
                      TextButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                setState(() {
                                  _codeSent = false;
                                });
                              },
                        child: const Text('Cambiar número o reenviar código'),
                      ),
                    ],
                    
                    const SizedBox(height: 16.0),
                    
                    // Aceptar términos y condiciones
                    if (!_codeSent)
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
                    
                    // Botón de acción
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                      ),
                      onPressed: _isLoading ? null : _handlePhoneVerification,
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
                          : Text(_codeSent ? 'VERIFICAR CÓDIGO' : 'ENVIAR CÓDIGO'),
                    ),
                    
                    const SizedBox(height: 16.0),
                    
                    // Nota sobre verificación
                    if (!_codeSent)
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
                                'Te enviaremos un código de verificación por SMS. Se aplicarán las tarifas estándar de mensajería.',
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
