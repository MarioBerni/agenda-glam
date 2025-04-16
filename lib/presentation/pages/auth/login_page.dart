import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Definir colores con opacidad para evitar errores de compilación
    final onBackgroundWithOpacity = colorScheme.onBackground.withOpacity(0.7);
    final secondaryWithLowOpacity = colorScheme.secondary.withOpacity(0.1);
    final onBackgroundWithLowOpacity = colorScheme.onBackground.withOpacity(0.5);
    
    return Scaffold(
      // Eliminamos el AppBar para un diseño más limpio
      body: Container(
        // Fondo con gradiente sutil
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.background,
              Color(0xFF0A1A30), // Un tono ligeramente más claro para el gradiente
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      // Logo con efecto de brillo
                      Container(
                        padding: const EdgeInsets.only(bottom: 40.0),
                        child: Column(
                          children: [
                            // Logo
                            SvgPicture.asset(
                              'assets/images/logo_agenda_glam.svg',
                              height: 120.0,
                              // Añadir colorFilter para aplicar el color dorado al logo si es monocromático
                              colorFilter: const ColorFilter.mode(
                                Color(0xFFFFC107), // Color dorado
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Texto de bienvenida
                            Text(
                              'Bienvenido a Agenda Glam',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tu agenda de servicios estéticos',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: onBackgroundWithOpacity,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      // Card con efecto de brillo en los bordes
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: secondaryWithLowOpacity,
                              blurRadius: 12,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Card(
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // Título del formulario
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 24.0),
                                  child: Text(
                                    'Iniciar Sesión',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                                
                                // Campo Email/Usuario
                                TextFormField(
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    labelText: 'Email o Usuario',
                                    prefixIcon: Icon(Icons.person_outline),
                                    hintText: 'ejemplo@correo.com',
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Por favor, ingresa tu email o usuario';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20.0),

                                // Campo Contraseña
                                TextFormField(
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                    labelText: 'Contraseña',
                                    hintText: '********',
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                        color: colorScheme.secondary,
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
                                      return 'Por favor, ingresa tu contraseña';
                                    }
                                    if (value.length < 6) {
                                      return 'La contraseña debe tener al menos 6 caracteres';
                                    }
                                    return null;
                                  },
                                ),
                                
                                // Olvidé mi contraseña
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      // TODO: Implementar recuperación de contraseña
                                    },
                                    child: Text(
                                      'Olvidé mi contraseña',
                                      style: TextStyle(
                                        color: colorScheme.secondary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(height: 24.0),

                                // Botón Iniciar Sesión
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(double.infinity, 56),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      // TODO: Implementar lógica real de inicio de sesión
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Iniciando sesión...'),
                                          backgroundColor: colorScheme.surface,
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text('INICIAR SESIÓN'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32.0),

                      // Opción para registrarse
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '¿No tienes una cuenta?',
                            style: TextStyle(
                              color: onBackgroundWithOpacity,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // TODO: Implementar navegación a pantalla de registro
                            },
                            child: Text(
                              'Regístrate',
                              style: TextStyle(
                                color: colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      // Versión de la aplicación
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                        child: Text(
                          'Versión 1.0.0',
                          style: TextStyle(
                            color: onBackgroundWithLowOpacity,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
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
