import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'core/theme/theme.dart';
// import 'presentation/pages/home_page.dart';
// import 'presentation/pages/auth/login_page.dart';
import 'presentation/pages/welcome_page.dart';
import 'presentation/blocs/auth/auth.dart';

// Función para inicializar Firebase
Future<void> _initializeFirebase() async {
  try {
    // Inicializar Firebase para todas las plataformas
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Firebase inicializado correctamente
  } catch (e) {
    // Error al inicializar Firebase: $e
    // Intentar inicializar sin opciones como último recurso
    try {
      await Firebase.initializeApp();
      // Firebase inicializado sin opciones
    } catch (e) {
      // Error fatal al inicializar Firebase: $e
      // No relanzamos la excepción para permitir que la app funcione sin Firebase
    }
  }
}

Future<void> main() async {
  // Asegurarse de que Flutter esté inicializado
  WidgetsFlutterBinding.ensureInitialized();
  
  // Variable para controlar si Firebase está disponible
  bool firebaseAvailable = true;
  
  // Inicializar Firebase y manejar errores
  try {
    await _initializeFirebase();
    // Firebase inicializado exitosamente
  } catch (e) {
    // Error durante la inicialización de Firebase: $e
    firebaseAvailable = false;
  }
  
  // Iniciar la aplicación, incluso si Firebase no está disponible
  runApp(MyApp(firebaseAvailable: firebaseAvailable));
}

class MyApp extends StatelessWidget {
  final bool firebaseAvailable;
  
  const MyApp({super.key, this.firebaseAvailable = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc()..add(AuthCheckRequested()),
      child: MaterialApp(
        title: 'Agenda Glam',
        theme: appTheme,
        debugShowCheckedModeBanner: false, // Eliminar banner de debug
        home: const WelcomePage(),
      ),
    );
  }
}
