import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart'; // Importación explícita de PhoneNumber

/// Formulario para recuperación de contraseña por teléfono
class PhoneRecoveryForm extends StatelessWidget {
  /// Constructor del formulario de recuperación por teléfono
  const PhoneRecoveryForm({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.onPhoneChanged,
  });

  /// Controlador del campo de texto para el teléfono
  final TextEditingController controller;
  
  /// Indica si el formulario está en estado de carga
  final bool isLoading;
  
  /// Callback que se ejecuta cuando cambia el número de teléfono
  final Function(PhoneNumber) onPhoneChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Ingresa tu número de teléfono y te enviaremos un código de verificación por SMS.',
          style: TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        IntlPhoneField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Número de teléfono',
            hintText: '9 1234 5678',
          ),
          initialCountryCode: 'UY', // Código de país para Uruguay
          onChanged: onPhoneChanged,
          validator: (value) {
            if (value == null || value.number.isEmpty) {
              return 'Por favor ingresa tu número de teléfono';
            }
            return null;
          },
          enabled: !isLoading,
        ),
      ],
    );
  }
}
