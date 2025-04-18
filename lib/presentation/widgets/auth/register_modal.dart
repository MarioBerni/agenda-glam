import 'package:flutter/material.dart';
import 'register_form.dart';
import 'login_modal.dart';

/// Modal deslizante para el registro de usuarios
class RegisterModal extends StatelessWidget {
  const RegisterModal({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      // Altura máxima del 90% de la pantalla
      constraints: BoxConstraints(maxHeight: size.height * 0.9),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Barra de arrastre
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 24),
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withAlpha(51), // 0.2 * 255 = 51
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          // Título y subtítulo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Crear Cuenta',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Regístrate para acceder a todas las funcionalidades',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withAlpha(179), // 0.7 * 255 = 179
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Formulario de registro
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: RegisterForm(
                onRegister: () {
                  // Cerrar el modal después de un registro exitoso
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          
          // Pie del modal
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '¿Ya tienes una cuenta?',
                  style: TextStyle(
                    color: colorScheme.onSurface.withAlpha(179), // 0.7 * 255 = 179
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Mostrar el modal de inicio de sesión
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const LoginModal(),
                    );
                  },
                  child: Text(
                    'Iniciar Sesión',
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
    );
  }
}

/// Función para mostrar el modal de registro
void showRegisterModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const RegisterModal(),
  );
}
