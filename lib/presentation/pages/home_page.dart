import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth.dart';
import '../widgets/home/user_profile_card.dart';
import '../widgets/home/app_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Agenda Glam'),
            actions: [
              // Mostrar avatar del usuario en el AppBar
              if (state.status == AuthStatus.authenticated)
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: state.user?.photoURL != null
                        ? NetworkImage(state.user!.photoURL!)
                        : null,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: state.user?.photoURL == null
                        ? Text(
                            _getInitials(state),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                ),
            ],
          ),
          drawer: const AppDrawer(),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, AuthState state) {
    switch (state.status) {
      case AuthStatus.authenticated:
      case AuthStatus.phoneVerified:
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tarjeta de perfil del usuario
              UserProfileCard(user: state.user, userModel: state.userModel),
              
              const SizedBox(height: 24),
              
              // Sección de próximas citas
              _buildSection(
                context,
                title: 'Próximas Citas',
                icon: Icons.calendar_today,
                child: const Card(
                  margin: EdgeInsets.only(top: 8),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'No tienes citas programadas',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Sección de servicios populares
              _buildSection(
                context,
                title: 'Servicios Populares',
                icon: Icons.star,
                child: const Card(
                  margin: EdgeInsets.only(top: 8),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _ServiceItem(
                          name: 'Corte de Cabello',
                          icon: Icons.content_cut,
                        ),
                        Divider(),
                        _ServiceItem(
                          name: 'Afeitado Profesional',
                          icon: Icons.face,
                        ),
                        Divider(),
                        _ServiceItem(
                          name: 'Tratamiento Facial',
                          icon: Icons.spa,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      
      case AuthStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case AuthStatus.initial:
      case AuthStatus.error:
      case AuthStatus.unauthenticated:
      case AuthStatus.emailNotVerified:
      case AuthStatus.emailVerificationSent:
      case AuthStatus.passwordResetSent:
      case AuthStatus.firstLogin:
      case AuthStatus.phoneVerificationSent:
      case AuthStatus.phoneVerificationError:
      case AuthStatus.phonePasswordResetSent:
      case AuthStatus.phonePasswordUpdated:
        // Estados que no deberían aparecer en la HomePage
        // Serán manejados por el AppRouter
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Estado no esperado',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Estado actual: ${state.status}'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(SignOutRequested());
                },
                child: const Text('CERRAR SESIÓN'),
              ),
            ],
          ),
        );
    }
  }

  Widget _buildSection(BuildContext context, {
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.secondary),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        child,
      ],
    );
  }

  String _getInitials(AuthState state) {
    if (state.userModel?.displayName != null && state.userModel!.displayName!.isNotEmpty) {
      return state.userModel!.displayName![0].toUpperCase();
    } else if (state.user?.displayName != null && state.user!.displayName!.isNotEmpty) {
      return state.user!.displayName![0].toUpperCase();
    } else if (state.user?.email != null && state.user!.email!.isNotEmpty) {
      return state.user!.email![0].toUpperCase();
    }
    return 'U';
  }
}

// Widget para mostrar un servicio popular
class _ServiceItem extends StatelessWidget {
  final String name;
  final IconData icon;

  const _ServiceItem({
    required this.name,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(width: 16),
          Text(
            name,
            style: const TextStyle(fontSize: 16),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              // Acción para reservar este servicio
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Funcionalidad en desarrollo'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              textStyle: const TextStyle(fontSize: 12),
            ),
            child: const Text('RESERVAR'),
          ),
        ],
      ),
    );
  }
}
