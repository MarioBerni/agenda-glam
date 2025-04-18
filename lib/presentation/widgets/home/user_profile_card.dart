import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/user_model.dart';
import '../../blocs/auth/auth.dart';

class UserProfileCard extends StatelessWidget {
  final User? user;
  final UserModel? userModel;

  const UserProfileCard({
    super.key,
    required this.user,
    this.userModel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Avatar del usuario
                CircleAvatar(
                  radius: 40,
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : null,
                  backgroundColor: theme.colorScheme.primary,
                  child: user?.photoURL == null
                      ? Text(
                          _getInitials(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                
                // Información del usuario
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getDisplayName(),
                        style: theme.textTheme.headlineSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? '',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(179), // 0.7 * 255 = 179
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            user?.emailVerified == true
                                ? Icons.verified_user
                                : Icons.warning,
                            size: 16,
                            color: user?.emailVerified == true
                                ? Colors.green
                                : Colors.orange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            user?.emailVerified == true
                                ? 'Verificado'
                                : 'Pendiente de verificación',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: user?.emailVerified == true
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            
            // Botones de acción
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ProfileActionButton(
                  icon: Icons.edit,
                  label: 'Editar Perfil',
                  onPressed: () {
                    // Mostrar modal para editar perfil
                    _showEditProfileModal(context);
                  },
                ),
                _ProfileActionButton(
                  icon: Icons.history,
                  label: 'Historial',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Funcionalidad en desarrollo'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                _ProfileActionButton(
                  icon: Icons.logout,
                  label: 'Cerrar Sesión',
                  onPressed: () {
                    // Mostrar diálogo de confirmación
                    _showLogoutConfirmationDialog(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Obtener el nombre a mostrar
  String _getDisplayName() {
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
  String _getInitials() {
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

  // Mostrar modal para editar perfil
  void _showEditProfileModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 16,
          left: 16,
          right: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.edit),
                const SizedBox(width: 8),
                Text(
                  'Editar Perfil',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Esta funcionalidad estará disponible próximamente.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('ENTENDIDO'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// Widget para los botones de acción del perfil
class _ProfileActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ProfileActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.secondary),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
