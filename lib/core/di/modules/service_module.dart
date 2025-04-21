import 'package:injectable/injectable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Módulo para registrar servicios externos como Firebase
@module
abstract class ServiceModule {
  // Firebase Auth
  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;
  
  // Firestore
  @lazySingleton
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  
  // Firebase Storage
  @lazySingleton
  FirebaseStorage get storage => FirebaseStorage.instance;
  
  // Google Sign In
  @lazySingleton
  GoogleSignIn get googleSignIn => GoogleSignIn(scopes: ['email']);
}
