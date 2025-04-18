import 'package:flutter/material.dart';

/// Tipo de SnackBar para diferentes contextos
enum SnackBarType {
  /// Para mensajes de éxito
  success,
  
  /// Para mensajes de error
  error,
  
  /// Para mensajes de advertencia
  warning,
  
  /// Para mensajes informativos
  info,
}

/// Clase para mostrar SnackBars personalizados en toda la aplicación
class CustomSnackBar {
  /// Muestra un SnackBar personalizado con animación y estilo mejorado
  static void show({
    required BuildContext context,
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
    VoidCallback? onVisible,
  }) {
    // Eliminar SnackBars anteriores
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    
    // Configurar colores según el tipo
    final IconData icon;
    final Color backgroundColor;
    
    switch (type) {
      case SnackBarType.success:
        icon = Icons.check_circle_outline;
        backgroundColor = Colors.green.shade800;
        break;
      case SnackBarType.error:
        icon = Icons.error_outline;
        backgroundColor = Colors.red.shade800;
        break;
      case SnackBarType.warning:
        icon = Icons.warning_amber_outlined;
        backgroundColor = Colors.orange.shade800;
        break;
      case SnackBarType.info:
        icon = Icons.info_outline;
        backgroundColor = Colors.blue.shade800;
        break;
    }
    
    // Mostrar el SnackBar
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      duration: duration,
      action: action,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      onVisible: onVisible,
    );
    
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  
  /// Muestra un SnackBar de éxito
  static void showSuccess({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    VoidCallback? onVisible,
  }) {
    show(
      context: context,
      message: message,
      type: SnackBarType.success,
      duration: duration,
      action: action,
      onVisible: onVisible,
    );
  }
  
  /// Muestra un SnackBar de error
  static void showError({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 5),
    SnackBarAction? action,
    VoidCallback? onVisible,
  }) {
    show(
      context: context,
      message: message,
      type: SnackBarType.error,
      duration: duration,
      action: action,
      onVisible: onVisible,
    );
  }
  
  /// Muestra un SnackBar de advertencia
  static void showWarning({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
    VoidCallback? onVisible,
  }) {
    show(
      context: context,
      message: message,
      type: SnackBarType.warning,
      duration: duration,
      action: action,
      onVisible: onVisible,
    );
  }
  
  /// Muestra un SnackBar informativo
  static void showInfo({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    VoidCallback? onVisible,
  }) {
    show(
      context: context,
      message: message,
      type: SnackBarType.info,
      duration: duration,
      action: action,
      onVisible: onVisible,
    );
  }
}
