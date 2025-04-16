import 'package:flutter/material.dart';

/// Widget que contiene los botones principales de acción
class ActionButtons extends StatelessWidget {
  final VoidCallback onRegister;
  final VoidCallback onLogin;

  const ActionButtons({
    super.key,
    required this.onRegister,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Column(
        children: [
          // Botón principal "Quiero Agendarme"
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: onRegister,
            child: const Text('QUIERO AGENDARME'),
          ),
          const SizedBox(height: 16),
          // Botón secundario "Iniciar Sesión"
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: onLogin,
            child: const Text('INICIAR SESIÓN'),
          ),
        ],
      ),
    );
  }
}
