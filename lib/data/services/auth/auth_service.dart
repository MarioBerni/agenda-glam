import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import 'auth_exception_handler.dart';
import 'auth_models.dart';
import 'auth_service_interface.dart';
import 'email_auth_service.dart';
import 'google_auth_service.dart';
import 'phone_auth_service.dart';

/// Servicio principal de autenticación que integra todos los servicios especializados
@LazySingleton(as: AuthServiceInterface)
class AuthService implements AuthServiceInterface {
  final FirebaseAuth _auth;
  final EmailAuthService _emailAuthService;
  final GoogleAuthService _googleAuthService;
  final PhoneAuthService _phoneAuthService;
  final Logger _logger = Logger('AuthService');

  /// Constructor con inyección de dependencias
  AuthService(
    this._auth,
    this._emailAuthService,
    this._googleAuthService,
    this._phoneAuthService,
  );

  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  @override
  User? get currentUser => _auth.currentUser;

  @override
  bool get isEmailVerified => _emailAuthService.isEmailVerified();

  /// Stream que emite cambios en el estado de autenticación por teléfono
  @override
  Stream<PhoneAuthState> get phoneAuthStateChanges => _phoneAuthService.phoneAuthStateChanges;

  @override
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) {
    return _emailAuthService.signInWithEmailAndPassword(email, password);
  }

  @override
  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) {
    return _emailAuthService.createUserWithEmailAndPassword(email, password);
  }

  @override
  Future<UserCredential> signInWithCredential(AuthCredential credential) async {
    try {
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw AuthExceptionHandler.handleException(e);
    }
  }

  @override
  Future<UserCredential> signInWithGoogle() {
    return _googleAuthService.signInWithGoogle();
  }

  @override
  Future<void> signOut() async {
    _logger.info('Cerrando sesión de usuario');
    // Cerrar sesión de Google primero
    await _googleAuthService.signOut();
    // Luego cerrar sesión de Firebase
    await _auth.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return _emailAuthService.sendPasswordResetEmail(email);
  }

  @override
  Future<void> sendEmailVerification() {
    return _emailAuthService.sendEmailVerification();
  }

  @override
  Future<void> reloadUser() {
    return _emailAuthService.reloadUser();
  }

  /// Iniciar sesión o registrar usuario con número de teléfono
  @override
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function(PhoneAuthCredential) onVerificationCompleted,
    required Function(String) onError,
    bool isForRegistration = false,
  }) {
    return _phoneAuthService.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      onCodeSent: onCodeSent,
      onVerificationCompleted: onVerificationCompleted,
      onError: onError,
      isForRegistration: isForRegistration,
    );
  }

  /// Verificar el código SMS recibido
  @override
  Future<UserCredential> verifyPhoneSmsCode({
    required String verificationId,
    required String smsCode,
    String? email,
    String? password,
  }) {
    return _phoneAuthService.verifyPhoneSmsCode(
      verificationId: verificationId,
      smsCode: smsCode,
      email: email,
      password: password,
    );
  }

  /// Enviar código de recuperación de contraseña por SMS
  @override
  Future<void> sendPasswordResetBySms({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function() onVerified,
    required Function(String) onError,
  }) {
    return _phoneAuthService.sendPasswordResetBySms(
      phoneNumber: phoneNumber,
      onCodeSent: onCodeSent,
      onVerified: onVerified,
      onError: onError,
    );
  }

  /// Actualizar contraseña después de verificación por teléfono
  @override
  Future<void> updatePasswordAfterPhoneVerification({
    required String verificationId,
    required String smsCode,
    required String newPassword,
  }) {
    return _phoneAuthService.updatePasswordAfterPhoneVerification(
      verificationId: verificationId,
      smsCode: smsCode,
      newPassword: newPassword,
    );
  }

  /// Configurar el idioma de Firebase Auth
  Future<void> setLanguageCode(String languageCode) async {
    _logger.info('Configurando idioma de Firebase Auth a: $languageCode');
    await _auth.setLanguageCode(languageCode);
  }

  @override
  void dispose() {
    _logger.info('Liberando recursos de AuthService');
    _phoneAuthService.dispose();
  }
}
