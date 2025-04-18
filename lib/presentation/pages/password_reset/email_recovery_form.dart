import 'package:flutter/material.dart';

/// Formulario para recuperación de contraseña por email
class EmailRecoveryForm extends StatelessWidget {
  /// Constructor del formulario de recuperación por email
  const EmailRecoveryForm({
    super.key,
    required this.controller,
    required this.isLoading,
  });

  /// Controlador del campo de texto para el email
  final TextEditingController controller;
  
  /// Indica si el formulario está en estado de carga
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Ingresa tu correo electrónico y te enviaremos un enlace para restablecer tu contraseña.',
          style: TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Correo electrónico',
            hintText: 'ejemplo@correo.com',
            prefixIcon: Icon(Icons.email),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa tu correo electrónico';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Por favor ingresa un correo electrónico válido';
            }
            return null;
          },
          enabled: !isLoading,
        ),
      ],
    );
  }
}
