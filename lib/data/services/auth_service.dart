import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Estado del usuario actual
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Usuario actual
  User? get currentUser => _auth.currentUser;

  // Iniciar sesión con email y contraseña
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password,) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Registrar usuario con email y contraseña
  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password,) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Enviar email de verificación
      await credential.user?.sendEmailVerification();
      
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Iniciar sesión con Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Iniciar el flujo de autenticación de Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        throw Exception('Inicio de sesión con Google cancelado por el usuario.');
      }

      // Obtener detalles de autenticación de la solicitud
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Crear credencial para Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Iniciar sesión con la credencial
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      if (e is FirebaseAuthException) {
        throw _handleAuthException(e);
      }
      throw Exception('Error al iniciar sesión con Google: ${e.toString()}');
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    // Cerrar sesión de Google si está activa
    await _googleSignIn.signOut();
    // Cerrar sesión de Firebase
    await _auth.signOut();
  }

  // Recuperar contraseña
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Verificar email del usuario
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Verificar si el email está verificado
  bool get isEmailVerified {
    return _auth.currentUser?.emailVerified ?? false;
  }

  // Recargar usuario para actualizar estado de verificación
  Future<void> reloadUser() async {
    try {
      await _auth.currentUser?.reload();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Manejo de excepciones de autenticación
  Exception _handleAuthException(FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'user-not-found':
        message = 'No existe un usuario con este correo electrónico.';
        break;
      case 'wrong-password':
        message = 'Contraseña incorrecta. Por favor, verifica tus credenciales.';
        break;
      case 'email-already-in-use':
        message = 'Este correo electrónico ya está registrado. Intenta iniciar sesión.';
        break;
      case 'weak-password':
        message = 'La contraseña es demasiado débil. Debe tener al menos 6 caracteres.';
        break;
      case 'invalid-email':
        message = 'El formato del correo electrónico es inválido.';
        break;
      case 'account-exists-with-different-credential':
        message = 'Ya existe una cuenta con este email pero con otro método de autenticación.';
        break;
      case 'invalid-credential':
        message = 'Las credenciales proporcionadas son inválidas.';
        break;
      case 'operation-not-allowed':
        message = 'Esta operación no está permitida. Contacta al soporte.';
        break;
      case 'user-disabled':
        message = 'Esta cuenta ha sido deshabilitada. Contacta al soporte.';
        break;
      case 'too-many-requests':
        message = 'Demasiados intentos fallidos. Intenta más tarde.';
        break;
      case 'network-request-failed':
        message = 'Error de conexión. Verifica tu conexión a internet.';
        break;
      default:
        message = 'Ha ocurrido un error: ${e.message ?? e.code}';
    }
    return Exception(message);
  }
}
