import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository_interface.dart';
import '../services/auth_service.dart';

class AuthRepository implements AuthRepositoryInterface {
  final AuthService _authService;

  AuthRepository({AuthService? authService})
      : _authService = authService ?? AuthService();

  @override
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  @override
  User? get currentUser => _authService.currentUser;

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
}
