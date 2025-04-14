import 'package:flutter/material.dart';

// Paleta de colores sugerida para Agenda Glam (tema oscuro)
const Color _primaryColor = Color(0xFF1A1A1A); // Negro/Gris muy oscuro
const Color _accentColor = Color(0xFFBB86FC);  // Un toque de color violeta (puede ajustarse)
const Color _backgroundColor = Color(0xFF121212); // Fondo oscuro
const Color _surfaceColor = Color(0xFF1E1E1E);   // Superficies ligeramente más claras
const Color _textColor = Color(0xFFE0E0E0);      // Texto claro
const Color _secondaryTextColor = Color(0xFFB0B0B0); // Texto secundario
const Color _errorColor = Color(0xFFCF6679);      // Color de error estándar en temas oscuros

final ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: _primaryColor,
  scaffoldBackgroundColor: _backgroundColor,
  colorScheme: const ColorScheme.dark(
    primary: _primaryColor,
    secondary: _accentColor, // Accent color
    background: _backgroundColor,
    surface: _surfaceColor,
    onPrimary: _textColor, // Color del texto sobre primario
    onSecondary: Colors.black, // Color del texto sobre secundario
    onBackground: _textColor, // Color del texto sobre fondo
    onSurface: _textColor, // Color del texto sobre superficies
    error: _errorColor,
    onError: Colors.black, // Color del texto sobre error
  ),
  appBarTheme: const AppBarTheme(
    color: _primaryColor,
    elevation: 0, // Sin sombra por defecto
    iconTheme: IconThemeData(color: _textColor),
    titleTextStyle: TextStyle(
      color: _textColor,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(color: _textColor, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(color: _textColor, fontWeight: FontWeight.w600),
    headlineSmall: TextStyle(color: _textColor, fontWeight: FontWeight.w500),
    bodyLarge: TextStyle(color: _textColor),
    bodyMedium: TextStyle(color: _secondaryTextColor),
    labelLarge: TextStyle(color: _accentColor, fontWeight: FontWeight.bold), // Para botones, etc.
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: _accentColor,
    textTheme: ButtonTextTheme.primary, // Usa color de texto adecuado para el botón
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _accentColor,
      foregroundColor: Colors.black, // Texto del botón
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: _surfaceColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide.none,
    ),
    labelStyle: const TextStyle(color: _secondaryTextColor),
    hintStyle: const TextStyle(color: _secondaryTextColor),
  ),
  cardTheme: CardTheme(
    color: _surfaceColor,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
  ),
  // Puedes añadir más personalizaciones aquí (FloatingActionButton, etc.)
);
