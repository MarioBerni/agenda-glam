import 'package:flutter/material.dart';

// Importar los widgets modulares desde el archivo de barril
import '../../widgets/auth/auth_widgets.dart';

/// Página de inicio de sesión que utiliza componentes modulares para una mejor organización
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Eliminamos el AppBar para un diseño más limpio
      body: Container(
        // Fondo con gradiente sutil
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surface,
              const Color(0xFF0A1A30), // Un tono ligeramente más claro para el gradiente
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Encabezado con logo y textos de bienvenida
                    const LoginHeader(),
                    
                    // Formulario de inicio de sesión
                    LoginForm(
                      onLogin: () {
                        // Aquí se implementará la lógica real de inicio de sesión
                        // Por ahora solo muestra un mensaje en la consola
                        debugPrint('Iniciando sesión...');
                      },
                    ),
                    
                    // Pie de página con opciones de registro y versión
                    LoginFooter(
                      onRegister: () {
                        // Aquí se implementará la navegación a la pantalla de registro
                        debugPrint('Navegando a pantalla de registro...');
                      },
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
