import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';

/// Widget mejorado para entrada de número de teléfono con selección de país
class PhoneInputField extends StatefulWidget {
  /// Controlador para el campo de teléfono
  final TextEditingController controller;
  
  /// Indica si el campo está habilitado
  final bool enabled;
  
  /// Función de validación
  final String? Function(String?)? validator;
  
  /// Función que se llama cuando cambia el valor
  final Function(String)? onChanged;

  const PhoneInputField({
    super.key,
    required this.controller,
    this.enabled = true,
    this.validator,
    this.onChanged,
  });
  
  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  // Contador de dígitos para mostrar en el formato 'X/9'
  String _counterText = '0/9';
  
  @override
  void initState() {
    super.initState();
    // Inicializar el contador con el valor actual
    if (widget.controller.text.isNotEmpty) {
      _updateCounter(widget.controller.text);
    }
  }
  
  // Actualizar el contador de dígitos
  void _updateCounter(String value) {
    // Contar solo dígitos, ignorando espacios y otros caracteres
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    setState(() {
      _counterText = '${digitsOnly.length}/9';
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Theme(
      // Aplicar tema personalizado para que coincida con el estilo de la app
      data: Theme.of(context).copyWith(
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: const TextStyle(color: Colors.white70),
          hintStyle: const TextStyle(color: Colors.white38),
          filled: true,
          fillColor: Colors.white.withAlpha(13),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white30),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white30),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.amber),
          ),
        ),
        textTheme: Theme.of(context).textTheme.copyWith(
          bodyMedium: const TextStyle(color: Colors.white),
        ),
      ),
      child: IntlPhoneField(
        controller: widget.controller,
        enabled: widget.enabled,
        decoration: InputDecoration(
          labelText: 'Número de teléfono',
          counterText: _counterText, // Contador dinámico en formato X/9
        ),
        initialCountryCode: 'UY', // Uruguay por defecto
        disableLengthCheck: false,
        dropdownTextStyle: const TextStyle(color: Colors.white),
        dropdownIcon: const Icon(Icons.arrow_drop_down, color: Colors.amber),
        flagsButtonPadding: const EdgeInsets.symmetric(horizontal: 8),
        showDropdownIcon: true,
        invalidNumberMessage: 'Número de teléfono inválido',
        // Usar pickerDialogStyle en lugar de searchText (que está obsoleto)
        pickerDialogStyle: PickerDialogStyle(
          backgroundColor: Colors.grey[900],
          countryNameStyle: const TextStyle(color: Colors.white),
          countryCodeStyle: const TextStyle(color: Colors.white70),
          searchFieldInputDecoration: InputDecoration(
            hintText: 'Buscar por nombre o código',
            hintStyle: const TextStyle(color: Colors.white54),
            prefixIcon: const Icon(Icons.search, color: Colors.amber),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white30),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white30),
            ),
          ),
        ),
        onChanged: (phone) {
          // Actualizar el contador
          _updateCounter(phone.number);
          
          // Llamar al callback si existe
          if (widget.onChanged != null) {
            widget.onChanged!(phone.completeNumber);
          }
        },
        validator: (phone) {
          if (widget.validator != null) {
            return widget.validator!(phone?.completeNumber);
          }
          
          // Validación por defecto
          if (phone == null || phone.number.isEmpty) {
            return 'Por favor ingresa tu número de teléfono';
          }
          
          // Validación de longitud para Uruguay
          if (phone.countryCode == '+598' && phone.number.length < 8) {
            return 'El número debe tener al menos 8 dígitos';
          }
          
          return null;
        },
      ),
    );
  }
}
