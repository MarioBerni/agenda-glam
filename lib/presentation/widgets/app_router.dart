import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth.dart';
import '../pages/home_page.dart';
import '../pages/password_reset_page.dart';
import '../pages/welcome_after_login_page.dart';
import '../pages/welcome_page.dart';

/// Widget que maneja la navegación basada en el estado de autenticación.
class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        switch (state.status) {
          case AuthStatus.initial:
          case AuthStatus.loading:
            // Mostrar pantalla de carga mientras se verifica la autenticación
            return const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Cargando...'),
                  ],
                ),
              ),
            );
            
          case AuthStatus.authenticated:
          case AuthStatus.phoneVerified:
            // Usuario autenticado, mostrar la página principal
            return const HomePage();
            
          case AuthStatus.emailNotVerified:
          case AuthStatus.emailVerificationSent:
            // Usuario registrado pero email no verificado
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.mark_email_unread,
                        size: 64,
                        color: Colors.amber,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Verifica tu correo electrónico',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Hemos enviado un correo de verificación a ${state.user?.email}. '
                        'Por favor, revisa tu bandeja de entrada y confirma tu correo para continuar.',
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<AuthBloc>().add(ReloadUserRequested());
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('VERIFICAR ESTADO'),
                      ),
                      const SizedBox(height: 16),
                      TextButton.icon(
                        onPressed: () {
                          context.read<AuthBloc>().add(SendEmailVerificationRequested());
                        },
                        icon: const Icon(Icons.email),
                        label: const Text('REENVIAR CORREO'),
                      ),
                      const SizedBox(height: 16),
                      TextButton.icon(
                        onPressed: () {
                          context.read<AuthBloc>().add(SignOutRequested());
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('CERRAR SESIÓN'),
                      ),
                    ],
                  ),
                ),
              ),
            );
            
          case AuthStatus.error:
            // Error de autenticación, mostrar mensaje y redirigir a bienvenida
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    const Text(
                      'Error de autenticación',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        state.errorMessage ?? 'Ha ocurrido un error inesperado.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/welcome');
                      },
                      child: const Text('VOLVER AL INICIO'),
                    ),
                  ],
                ),
              ),
            );
            
          case AuthStatus.unauthenticated:
            // Usuario no autenticado, mostrar página de bienvenida
            return const WelcomePage();
            
          case AuthStatus.passwordResetSent:
            // Se ha enviado un correo para restablecer la contraseña
            return const PasswordResetPage(showSuccessMessage: true);
            
          case AuthStatus.firstLogin:
            // Primera vez que el usuario inicia sesión, mostrar página de bienvenida personalizada
            return const WelcomeAfterLoginPage();
            
          // Nuevos estados para autenticación por teléfono
          case AuthStatus.phoneVerificationSent:
          case AuthStatus.phonePasswordResetSent:
            // Se ha enviado un código de verificación por SMS
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.sms_outlined,
                        size: 64,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Código de verificación enviado',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Hemos enviado un código de verificación al número ${state.phoneNumber}. '
                        'Por favor, revisa tus mensajes e ingresa el código para continuar.',
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('VOLVER'),
                      ),
                    ],
                  ),
                ),
              ),
            );
            
          case AuthStatus.phoneVerificationError:
            // Error en la verificación por teléfono
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    const Text(
                      'Error de verificación',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        state.errorMessage ?? 'Error al verificar el número de teléfono.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('VOLVER'),
                    ),
                  ],
                ),
              ),
            );
            
          case AuthStatus.phonePasswordUpdated:
            // Contraseña actualizada después de verificación por teléfono
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
                    const SizedBox(height: 16),
                    const Text(
                      'Contraseña actualizada',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        'Tu contraseña ha sido actualizada correctamente. Ya puedes iniciar sesión con tu nueva contraseña.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/welcome');
                      },
                      child: const Text('IR AL INICIO'),
                    ),
                  ],
                ),
              ),
            );
        }
      },
    );
  }
}
