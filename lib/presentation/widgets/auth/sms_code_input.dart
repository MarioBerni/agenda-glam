import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Widget para ingresar el código de verificación SMS
class SmsCodeInput extends StatefulWidget {
  /// Controlador para el código SMS
  final TextEditingController controller;
  
  /// Función que se llama cuando se completa el código
  final Function(String)? onCompleted;
  
  /// Número de dígitos del código (por defecto 6)
  final int codeLength;
  
  /// Indica si el campo está habilitado
  final bool enabled;

  const SmsCodeInput({
    super.key,
    required this.controller,
    this.onCompleted,
    this.codeLength = 6,
    this.enabled = true,
  });

  @override
  State<SmsCodeInput> createState() => _SmsCodeInputState();
}

class _SmsCodeInputState extends State<SmsCodeInput> {
  /// Lista de controladores para cada dígito
  late List<TextEditingController> _digitControllers;
  
  /// Lista de focus nodes para cada dígito
  late List<FocusNode> _focusNodes;
  
  @override
  void initState() {
    super.initState();
    
    // Inicializar controladores y focus nodes
    _digitControllers = List.generate(
      widget.codeLength, 
      (_) => TextEditingController(),
    );
    
    _focusNodes = List.generate(
      widget.codeLength, 
      (_) => FocusNode(),
    );
    
    // Si ya hay un valor en el controlador principal, distribuirlo
    if (widget.controller.text.isNotEmpty) {
      _setDigitsFromController();
    }
    
    // Escuchar cambios en el controlador principal
    widget.controller.addListener(_setDigitsFromController);
  }
  
  @override
  void dispose() {
    // Limpiar controladores y focus nodes
    for (var i = 0; i < widget.codeLength; i++) {
      _digitControllers[i].dispose();
      _focusNodes[i].dispose();
    }
    
    // Eliminar listener
    widget.controller.removeListener(_setDigitsFromController);
    
    super.dispose();
  }
  
  /// Distribuye los dígitos del controlador principal a los controladores individuales
  void _setDigitsFromController() {
    final text = widget.controller.text;
    
    for (var i = 0; i < widget.codeLength; i++) {
      if (i < text.length) {
        _digitControllers[i].text = text[i];
      } else {
        _digitControllers[i].text = '';
      }
    }
  }
  
  /// Actualiza el controlador principal con los dígitos individuales
  void _updateMainController() {
    final buffer = StringBuffer();
    
    for (var controller in _digitControllers) {
      buffer.write(controller.text);
    }
    
    final code = buffer.toString();
    widget.controller.text = code;
    
    // Si se completó el código, llamar al callback
    if (code.length == widget.codeLength && widget.onCompleted != null) {
      widget.onCompleted!(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        widget.codeLength,
        (index) => _buildDigitField(index),
      ),
    );
  }
  
  /// Construye un campo para un dígito individual
  Widget _buildDigitField(int index) {
    return SizedBox(
      width: 45,
      height: 55,
      child: TextFormField(
        controller: _digitControllers[index],
        focusNode: _focusNodes[index],
        enabled: widget.enabled,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white30),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.amber),
          ),
          filled: true,
          fillColor: Colors.white.withAlpha(13),
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (value) {
          if (value.isNotEmpty) {
            // Mover al siguiente campo
            if (index < widget.codeLength - 1) {
              _focusNodes[index + 1].requestFocus();
            } else {
              // Último campo, ocultar teclado
              FocusScope.of(context).unfocus();
            }
          }
          
          _updateMainController();
        },
      ),
    );
  }
}
