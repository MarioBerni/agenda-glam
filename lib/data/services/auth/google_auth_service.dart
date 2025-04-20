import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logging/logging.dart';

import 'auth_exception_handler.dart';
import 'auth_models.dart';

/// Servicio especializado para autenticación con Google
class GoogleAuthService {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final Logger _logger = Logger('GoogleAuthService');

  GoogleAuthService({FirebaseAuth? auth, GoogleSignIn? googleSignIn}) 
    : _auth = auth ?? FirebaseAuth.instance,
      _googleSignIn = googleSignIn ?? GoogleSignIn(scopes: ['email']);

  /// Iniciar sesión con Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Configurar el idioma español para Firebase Auth antes de iniciar el flujo
      await _auth.setLanguageCode('es');
      _logger.info('Iniciando flujo de autenticación con Google');
      
      // Crear un proveedor de Google con configuración de idioma
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      
      // Añadir parámetros personalizados para forzar el idioma español
      googleProvider.setCustomParameters({
        'hl': 'es', // Código de idioma español
        'locale': 'es', // Configuración regional
      });
      
      // Intentar primero con signInWithPopup si estamos en web
      if (kIsWeb) {
        _logger.info('Usando signInWithPopup para plataforma web');
        try {
          return await _auth.signInWithPopup(googleProvider);
        } catch (e) {
          _logger.warning('Error con signInWithPopup: $e');
        }
      }
      
      // Método tradicional como respaldo
      _logger.info('Usando flujo estándar de GoogleSignIn');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        _logger.info('Usuario canceló el inicio de sesión con Google');
        throw AuthException(
          'sign-in-cancelled', 
          'Inicio de sesión con Google cancelado por el usuario.'
        );
      }

      // Obtener detalles de autenticación
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      _logger.info('Autenticación con Google exitosa para: ${googleUser.email}');

      // Crear credencial para Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Iniciar sesión con la credencial
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      if (e is FirebaseAuthException) {
        _logger.severe('Error de Firebase Auth en inicio de sesión con Google: ${e.code}');
        throw AuthExceptionHandler.handleException(e);
      }
      if (e is AuthException) {
        _logger.warning('Error de autenticación: ${e.code}');
        rethrow;
      }
      _logger.severe('Error inesperado en inicio de sesión con Google: $e');
      throw AuthException(
        'google-sign-in-error', 
        'Error al iniciar sesión con Google: ${e.toString()}'
      );
    }
  }

  /// Cerrar sesión de Google
  Future<void> signOut() async {
    _logger.info('Cerrando sesión de Google');
    await _googleSignIn.signOut();
  }
}
