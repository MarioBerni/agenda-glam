import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/user_repository_interface.dart';

@LazySingleton(as: UserRepositoryInterface)
class UserRepository implements UserRepositoryInterface {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  
  UserRepository(this._firestore, this._auth);

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    
    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      // En caso de error, devolvemos null y manejamos el error en la capa superior
      return null;
    }
  }
  
  @override
  Future<bool> isFirstLogin() async {
    final user = _auth.currentUser;
    if (user == null) return false;
    
    try {
      // Verificar en SharedPreferences si el usuario ya ha visto la pantalla de bienvenida
      final prefs = await SharedPreferences.getInstance();
      final key = 'first_login_${user.uid}';
      final hasSeenWelcome = prefs.getBool(key) ?? false;
      
      if (!hasSeenWelcome) {
        // Marcar que el usuario ha visto la pantalla de bienvenida
        await prefs.setBool(key, true);
        return true;
      }
      
      return false;
    } catch (e) {
      // En caso de error, asumimos que no es el primer inicio de sesión
      return false;
    }
  }
  
  @override
  Future<void> updateUserProfile({
    String? displayName,
    String? phoneNumber,
    String? photoURL,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;
    
    try {
      // Actualizar en Firebase Auth
      if (displayName != null && displayName.isNotEmpty) {
        await user.updateDisplayName(displayName);
      }
      
      if (photoURL != null && photoURL.isNotEmpty) {
        await user.updatePhotoURL(photoURL);
      }
      
      // Actualizar en Firestore
      final userData = <String, dynamic>{
        'email': user.email,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      if (displayName != null && displayName.isNotEmpty) {
        userData['displayName'] = displayName;
      }
      
      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        userData['phoneNumber'] = phoneNumber;
      }
      
      if (photoURL != null && photoURL.isNotEmpty) {
        userData['photoURL'] = photoURL;
      }
      
      await _firestore.collection('users').doc(user.uid).set(
        userData,
        SetOptions(merge: true),
      );
    } catch (e) {
      // Manejar errores en la capa superior
      rethrow;
    }
  }
  
  @override
  Future<void> saveInitialUserData(User user) async {
    try {
      // Datos básicos del usuario para guardar en Firestore
      final userData = {
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'photoURL': user.photoURL,
        'emailVerified': user.emailVerified,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
      };
      
      // Guardar en Firestore
      await _firestore.collection('users').doc(user.uid).set(
        userData,
        SetOptions(merge: true),
      );
    } catch (e) {
      // Manejar errores en la capa superior
      rethrow;
    }
  }
}
