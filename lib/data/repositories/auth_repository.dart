import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/auth_repository_interface.dart';
import '../services/auth/auth_models.dart';
import '../services/auth/auth_service_interface.dart';

/// Implementación del repositorio de autenticación
@LazySingleton(as: AuthRepositoryInterface)
class AuthRepository implements AuthRepositoryInterface {
  final AuthServiceInterface _authService;

  AuthRepository(this._authService);

  @override
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  @override
  User? get currentUser => _authService.currentUser;
  
  @override
  Stream<PhoneAuthState> get phoneAuthStateChanges => _authService.phoneAuthStateChanges;

  @override
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password,) {
    return _authService.signInWithEmailAndPassword(email, password);
  }

  @override
  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password,) {
    return _authService.createUserWithEmailAndPassword(email, password);
  }

  @override
  Future<UserCredential> signInWithGoogle() {
    return _authService.signInWithGoogle();
  }
  
  @override
  Future<UserCredential> signInWithCredential(AuthCredential credential) {
    return _authService.signInWithCredential(credential);
  }

  @override
  Future<void> signOut() {
    return _authService.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return _authService.sendPasswordResetEmail(email);
  }
  
  @override
  Future<void> sendEmailVerification() {
    return _authService.sendEmailVerification();
  }
  
  @override
  bool get isEmailVerified => _authService.isEmailVerified;
  
  @override
  Future<void> reloadUser() {
    return _authService.reloadUser();
  }
  
  @override
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function(PhoneAuthCredential) onVerificationCompleted,
    required Function(String) onError,
    bool isForRegistration = false,
  }) {
    return _authService.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      onCodeSent: onCodeSent,
      onVerificationCompleted: onVerificationCompleted,
      onError: onError,
      isForRegistration: isForRegistration,
    );
  }
  
  @override
  Future<UserCredential> verifyPhoneSmsCode({
    required String verificationId,
    required String smsCode,
    String? email,
    String? password,
  }) {
    return _authService.verifyPhoneSmsCode(
      verificationId: verificationId,
      smsCode: smsCode,
      email: email,
      password: password,
    );
  }
  
  @override
  Future<void> sendPasswordResetBySms({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function() onVerified,
    required Function(String) onError,
  }) {
    return _authService.sendPasswordResetBySms(
      phoneNumber: phoneNumber,
      onCodeSent: onCodeSent,
      onVerified: onVerified,
      onError: onError,
    );
  }
  
  @override
  Future<void> updatePasswordAfterPhoneVerification({
    required String verificationId,
    required String smsCode,
    required String newPassword,
  }) {
    return _authService.updatePasswordAfterPhoneVerification(
      verificationId: verificationId,
      smsCode: smsCode,
      newPassword: newPassword,
    );
  }
  
  @override
  void dispose() {
    _authService.dispose();
  }
}
