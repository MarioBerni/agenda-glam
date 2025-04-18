import 'package:flutter/material.dart';

/// Formulario para ingresar el código de verificación recibido por SMS
class VerificationCodeForm extends StatelessWidget {
  /// Constructor del formulario de verificación
  const VerificationCodeForm({
    super.key,
    required this.controller,
    required this.isLoading,
  });

  /// Controlador para el campo de código
  final TextEditingController controller;
  
  /// Indica si se está procesando la solicitud
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        const Text(
          'Ingresa el código de verificación que recibiste por SMS',
          style: TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          maxLength: 6,
          decoration: const InputDecoration(
            labelText: 'Código de verificación',
            hintText: '123456',
            prefixIcon: Icon(Icons.sms),
            counterText: '',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa el código de verificación';
            }
            if (value.length < 6) {
              return 'El código debe tener 6 dígitos';
            }
            return null;
          },
          enabled: !isLoading,
        ),
      ],
    );
  }
}
