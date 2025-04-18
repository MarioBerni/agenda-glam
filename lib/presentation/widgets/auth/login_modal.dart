import 'package:flutter/material.dart';
import 'login_form.dart';
import 'register_modal.dart';

/// Widget que muestra un formulario de inicio de sesión en un modal
class LoginModal extends StatelessWidget {
  const LoginModal({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;

    return Container(
      // Altura máxima del 90% de la pantalla
      constraints: BoxConstraints(maxHeight: size.height * 0.9),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Barra de arrastre
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withAlpha(51), // 0.2 * 255 = 51
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Text(
                    'Iniciar Sesión',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Subtítulo
                  Text(
                    'Ingresa tus credenciales para acceder a tu cuenta',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withAlpha(179), // 0.7 * 255 = 179
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),

            // Formulario de inicio de sesión
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: LoginForm(
                onLogin: () {
                  // Cerrar el modal después de iniciar sesión
                  Navigator.pop(context);
                },
              ),
            ),

            const SizedBox(height: 24),

            // Opción para registrarse
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¿No tienes una cuenta?',
                    style: TextStyle(
                      color: colorScheme.onSurface.withAlpha(179), // 0.7 * 255 = 179
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Cerrar el modal de inicio de sesión
                      Navigator.pop(context);

                      // Mostrar el modal de registro
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const RegisterModal(),
                      );
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
            ),
          ],
        ),
      ),
    );
  }
}

/// Función para mostrar el modal de inicio de sesión
void showLoginModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const LoginModal(),
  );
}
