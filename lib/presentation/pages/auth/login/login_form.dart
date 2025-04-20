import 'package:flutter/material.dart';

/// Formulario para la página de inicio de sesión
class LoginForm extends StatefulWidget {
  /// Controlador para el campo de email
  final TextEditingController emailController;
  
  /// Controlador para el campo de contraseña
  final TextEditingController passwordController;
  
  /// Indica si se está procesando la solicitud
  final bool isLoading;
  
  /// Callback cuando se envía el formulario
  final VoidCallback onSubmit;
  
  /// Callback cuando se presiona el botón de recuperar contraseña
  final VoidCallback onForgotPassword;
  
  /// Animación de desvanecimiento
  final Animation<double> fadeInAnimation;
  
  /// Animación de deslizamiento
  final Animation<Offset> slideAnimation;
  
  /// Constructor del formulario
  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.onSubmit,
    required this.onForgotPassword,
    required this.fadeInAnimation,
    required this.slideAnimation,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscurePassword = true;
  bool _rememberMe = false;
  
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: widget.fadeInAnimation,
      child: SlideTransition(
        position: widget.slideAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Campo de email o teléfono
            TextFormField(
              controller: widget.emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Email o Teléfono',
                prefixIcon: const Icon(Icons.person, color: Colors.amber),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.amber),
                ),
                labelStyle: const TextStyle(color: Colors.white70),
                hintText: 'Puedes usar tu email o número con código de país...',
                hintStyle: const TextStyle(color: Colors.white30, fontSize: 12),
                filled: true,
                fillColor: Colors.white.withAlpha(13),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu email o teléfono';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Campo de contraseña
            TextFormField(
              controller: widget.passwordController,
              obscureText: _obscurePassword,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: const Icon(Icons.lock, color: Colors.amber),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.amber),
                ),
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withAlpha(13),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu contraseña';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Opciones adicionales
            Row(
              children: [
                // Opción de recordar sesión
                Transform.scale(
                  scale: 0.9,
                  child: Checkbox(
                    value: _rememberMe,
                    activeColor: Colors.amber,
                    checkColor: Colors.black,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value ?? false;
                      });
                    },
                  ),
                ),
                const Text(
                  'Recordarme',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const Spacer(),
                // Enlace para recuperar contraseña
                TextButton(
                  onPressed: widget.onForgotPassword,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.amber,
                  ),
                  child: const Text('Olvidé mi contraseña'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Botón de inicio de sesión
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              onPressed: widget.isLoading ? null : widget.onSubmit,
              child: widget.isLoading
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
                        Text('Iniciando sesión...'),
                      ],
                    )
                  : const Text('INICIAR SESIÓN'),
            ),
          ],
        ),
      ),
    );
  }
}
