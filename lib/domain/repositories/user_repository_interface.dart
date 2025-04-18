import 'package:firebase_auth/firebase_auth.dart';

abstract class UserRepositoryInterface {
  /// Obtiene los datos del usuario actual desde Firestore
  Future<Map<String, dynamic>?> getCurrentUserData();
  
  /// Verifica si es la primera vez que el usuario inicia sesión
  Future<bool> isFirstLogin();
  
  /// Actualiza el perfil del usuario en Firebase Auth y Firestore
  Future<void> updateUserProfile({
    String? displayName,
    String? phoneNumber,
    String? photoURL,
  });
  
  /// Guarda los datos iniciales del usuario después del registro
  Future<void> saveInitialUserData(User user);
  
  /// Obtiene el usuario actual de Firebase Auth
  User? get currentUser;
}
