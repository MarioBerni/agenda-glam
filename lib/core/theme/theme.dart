import 'package:flutter/material.dart';

// Paleta de colores para Agenda Glam (Elegante Oscura)
const Color _primaryColor = Color(0xFF0A1128);    // Azul marino profundo (AppBar)
const Color _accentColor = Color(0xFFFFC107);     // Dorado/Ámbar (Acento/Botones)
const Color _backgroundColor = Color(0xFF050A14);  // Negro azulado muy oscuro (Fondo)
const Color _surfaceColor = Color(0xFF1E2A3B);     // Gris azulado oscuro (Superficies/Cards)
const Color _textColor = Color(0xFFFFFFFF);        // Blanco (Texto principal)
const Color _secondaryTextColor = Color(0xFFB0B8C1); // Gris plateado (Texto secundario)
const Color _errorColor = Color(0xFFCF6679);       // Rojo error oscuro
const Color _onPrimaryColor = _textColor;          // Texto sobre primario
const Color _onAccentColor = Colors.black;         // Texto sobre acento (negro sobre dorado)

// Color con opacidad para usar en varios lugares
// Usamos withAlpha en lugar de withOpacity para evitar el warning de deprecación
final Color _accentColorWithOpacity = _accentColor.withAlpha(102);      // 0.4 * 255 = 102
final Color _secondaryTextColorWithOpacity = _secondaryTextColor.withAlpha(179); // 0.7 * 255 = 179
final Color _surfaceColorWithOpacity = _surfaceColor.withAlpha(179);     // 0.7 * 255 = 179
final Color _accentColorLightBg = _accentColor.withAlpha(51);           // 0.2 * 255 = 51
final Color _blackWithOpacity = Colors.black.withAlpha(77);             // 0.3 * 255 = 77

final ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: _primaryColor,
  scaffoldBackgroundColor: _backgroundColor,
  colorScheme: const ColorScheme.dark(
    primary: _primaryColor,
    secondary: _accentColor,
    surface: _surfaceColor,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: _primaryColor,
    elevation: 2, // Ligera elevación para dar profundidad
    shadowColor: Colors.black45, // Sombra sutil
    iconTheme: IconThemeData(color: _onPrimaryColor),
    titleTextStyle: TextStyle(
      color: _onPrimaryColor,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5, // Espaciado de letras para elegancia
    ),
    centerTitle: true, // Centrar título por defecto
  ),
  textTheme: const TextTheme(
    // Títulos
    displayLarge: TextStyle(
      color: _textColor,
      fontWeight: FontWeight.w300,
      letterSpacing: 0.5,
    ),
    displayMedium: TextStyle(
      color: _textColor,
      fontWeight: FontWeight.w300,
      letterSpacing: 0.5,
    ),
    displaySmall: TextStyle(
      color: _textColor,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
    ),

    // Encabezados
    headlineLarge: TextStyle(
      color: _textColor,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    ),
    headlineMedium: TextStyle(
      color: _textColor,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.25,
    ),
    headlineSmall: TextStyle(
      color: _textColor,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.25,
    ),

    // Cuerpo de texto
    bodyLarge: TextStyle(color: _textColor, letterSpacing: 0.15),
    bodyMedium: TextStyle(color: _secondaryTextColor, letterSpacing: 0.15),
    bodySmall: TextStyle(color: _secondaryTextColor, letterSpacing: 0.1),

    // Etiquetas y botones
    labelLarge: TextStyle(
      color: _accentColor,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    ),
    labelMedium: TextStyle(
      color: _accentColor,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
    labelSmall: TextStyle(
      color: _secondaryTextColor,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
  ),

  // Botones elevados (principales)
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _accentColor,
      foregroundColor: _onAccentColor,
      elevation: 3, // Mayor elevación para destacar
      shadowColor: _accentColorWithOpacity, // Sombra del color de acento
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      textStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    ),
  ),

  // Botones de texto (secundarios)
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: _accentColor,
      textStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
    ),
  ),

  // Botones con contorno
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: _accentColor,
      side: const BorderSide(color: _accentColor, width: 1.5),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    ),
  ),

  // Campos de texto
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: _surfaceColor,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: _accentColor, width: 2.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: _errorColor),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: _errorColor, width: 2.0),
    ),
    labelStyle: const TextStyle(color: _secondaryTextColor),
    hintStyle: TextStyle(color: _secondaryTextColorWithOpacity),
    prefixIconColor: _secondaryTextColor,
    suffixIconColor: _secondaryTextColor,
  ),

  // Tarjetas
  cardTheme: CardTheme(
    elevation: 4,
    shadowColor: _blackWithOpacity,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    color: _surfaceColor,
    clipBehavior:
        Clip.antiAlias, // Para imágenes y contenido que podría desbordar
  ),

  // Diálogos
  dialogTheme: DialogTheme(
    backgroundColor: _surfaceColor,
    elevation: 8,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
  ),

  // Chips
  chipTheme: ChipThemeData(
    backgroundColor: _surfaceColor,
    disabledColor: _surfaceColorWithOpacity,
    selectedColor: _accentColorLightBg,
    secondarySelectedColor: _accentColor,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    labelStyle: const TextStyle(color: _textColor),
    secondaryLabelStyle: const TextStyle(color: _onAccentColor),
    brightness: Brightness.dark,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
      side: const BorderSide(color: _accentColor),
    ),
  ),

  // Iconos
  iconTheme: const IconThemeData(color: _secondaryTextColor, size: 24),

  // Divisores
  dividerTheme: const DividerThemeData(
    color: Color(0xFF2D3A4A), // Un poco más claro que el color de superficie
    thickness: 1,
    space: 24,
  ),

  // SnackBar
  snackBarTheme: SnackBarThemeData(
    backgroundColor: _surfaceColor,
    contentTextStyle: const TextStyle(color: _textColor),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    behavior: SnackBarBehavior.floating,
    actionTextColor: _accentColor,
  ),
);
