import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state.user;
        final userModel = state.userModel;
        
        return Drawer(
          child: Column(
            children: [
              // Cabecera del drawer con información del usuario
              UserAccountsDrawerHeader(
                accountName: Text(
                  _getDisplayName(user, userModel),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                accountEmail: Text(user?.email ?? ''),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : null,
                  backgroundColor: theme.colorScheme.primary,
                  child: user?.photoURL == null
                      ? Text(
                          _getInitials(user, userModel),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                ),
              ),
              
              // Opciones del menú
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Inicio'),
                onTap: () {
                  Navigator.of(context).pop(); // Cerrar el drawer
                  Navigator.of(context).pushReplacementNamed('/home');
                },
              ),
              
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Mis Reservas'),
                onTap: () {
                  Navigator.of(context).pop(); // Cerrar el drawer
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Funcionalidad en desarrollo'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              
              ListTile(
                leading: const Icon(Icons.search),
                title: const Text('Buscar Servicios'),
                onTap: () {
                  Navigator.of(context).pop(); // Cerrar el drawer
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Funcionalidad en desarrollo'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              
              ListTile(
                leading: const Icon(Icons.favorite),
                title: const Text('Favoritos'),
                onTap: () {
                  Navigator.of(context).pop(); // Cerrar el drawer
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Funcionalidad en desarrollo'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              
              const Divider(),
              
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Mi Perfil'),
                onTap: () {
                  Navigator.of(context).pop(); // Cerrar el drawer
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Funcionalidad en desarrollo'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Configuración'),
                onTap: () {
                  Navigator.of(context).pop(); // Cerrar el drawer
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Funcionalidad en desarrollo'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              
              const Spacer(),
              
              // Opción de cerrar sesión en la parte inferior
              if (state.status == AuthStatus.authenticated)
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    'Cerrar Sesión',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.of(context).pop(); // Cerrar el drawer
                    _showLogoutConfirmationDialog(context);
                  },
                ),
              
              // Versión de la aplicación
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Agenda Glam v1.0.0',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(128), // 0.5 * 255 = 128
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Obtener el nombre a mostrar
  String _getDisplayName(user, userModel) {
    if (userModel?.displayName != null && userModel!.displayName!.isNotEmpty) {
      return userModel!.displayName!;
    } else if (user?.displayName != null && user!.displayName!.isNotEmpty) {
      return user!.displayName!;
    } else if (user?.email != null) {
      // Usar la parte del email antes del @
      return user!.email!.split('@').first;
    }
    return 'Usuario';
  }

  // Obtener iniciales para el avatar
  String _getInitials(user, userModel) {
    if (userModel?.displayName != null && userModel!.displayName!.isNotEmpty) {
      return userModel!.displayName![0].toUpperCase();
    } else if (user?.displayName != null && user!.displayName!.isNotEmpty) {
      return user!.displayName![0].toUpperCase();
    } else if (user?.email != null && user!.email!.isNotEmpty) {
      return user!.email![0].toUpperCase();
    }
    return 'U';
  }

  // Mostrar diálogo de confirmación para cerrar sesión
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AuthBloc>().add(SignOutRequested());
              
              // Navegar a la página de bienvenida
              Navigator.of(context).pushReplacementNamed('/welcome');
            },
            child: const Text('CERRAR SESIÓN'),
          ),
        ],
      ),
    );
  }
}
