import 'package:flutter/material.dart';

/// Enum para representar la fortaleza de la contraseña
enum PasswordStrength {
  /// Contraseña vacía
  empty,
  
  /// Contraseña débil (menos de 6 caracteres)
  weak,
  
  /// Contraseña media (al menos 6 caracteres)
  medium,
  
  /// Contraseña fuerte (al menos 8 caracteres con números y letras)
  strong,
  
  /// Contraseña muy fuerte (al menos 8 caracteres con números, letras y símbolos)
  veryStrong,
}

/// Widget que muestra un indicador visual de la fortaleza de la contraseña
class PasswordStrengthIndicator extends StatelessWidget {
  /// La contraseña a evaluar
  final String password;
  
  /// Constructor del indicador de fortaleza de contraseña
  const PasswordStrengthIndicator({
    super.key,
    required this.password,
  });
  
  /// Evalúa la fortaleza de la contraseña
  PasswordStrength _calculatePasswordStrength() {
    if (password.isEmpty) {
      return PasswordStrength.empty;
    }
    
    if (password.length < 6) {
      return PasswordStrength.weak;
    }
    
    // Verificar si contiene números
    final hasNumbers = password.contains(RegExp(r'[0-9]'));
    
    // Verificar si contiene letras
    final hasLetters = password.contains(RegExp(r'[a-zA-Z]'));
    
    // Verificar si contiene símbolos
    final hasSymbols = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    
    if (password.length >= 8 && hasNumbers && hasLetters && hasSymbols) {
      return PasswordStrength.veryStrong;
    }
    
    if (password.length >= 8 && hasNumbers && hasLetters) {
      return PasswordStrength.strong;
    }
    
    return PasswordStrength.medium;
  }
  
  /// Obtiene el color correspondiente a la fortaleza de la contraseña
  Color _getColor(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.empty:
        return Colors.grey.shade300;
      case PasswordStrength.weak:
        return Colors.red;
      case PasswordStrength.medium:
        return Colors.orange;
      case PasswordStrength.strong:
        return Colors.green;
      case PasswordStrength.veryStrong:
        return Colors.green.shade800;
    }
  }
  
  /// Obtiene el texto descriptivo de la fortaleza de la contraseña
  String _getText(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.empty:
        return 'Ingresa una contraseña';
      case PasswordStrength.weak:
        return 'Contraseña débil';
      case PasswordStrength.medium:
        return 'Contraseña media';
      case PasswordStrength.strong:
        return 'Contraseña fuerte';
      case PasswordStrength.veryStrong:
        return 'Contraseña muy fuerte';
    }
  }
  
  /// Obtiene el valor de progreso para la barra de fortaleza
  double _getProgress(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.empty:
        return 0.0;
      case PasswordStrength.weak:
        return 0.25;
      case PasswordStrength.medium:
        return 0.5;
      case PasswordStrength.strong:
        return 0.75;
      case PasswordStrength.veryStrong:
        return 1.0;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final strength = _calculatePasswordStrength();
    final color = _getColor(strength);
    final text = _getText(strength);
    final progress = _getProgress(strength);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Barra de progreso
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 4),
        
        // Texto descriptivo
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
        
        // Consejos para mejorar la contraseña
        if (strength == PasswordStrength.weak || strength == PasswordStrength.medium)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Sugerencia: Incluye letras, números y símbolos para mayor seguridad.',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }
}
