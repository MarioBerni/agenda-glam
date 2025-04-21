import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import 'core/di/injection.dart';
import 'firebase_options.dart';
import 'core/theme/theme.dart';

import 'presentation/pages/home_page.dart';
import 'presentation/pages/password_reset_page.dart';
import 'presentation/pages/welcome_page.dart';
import 'presentation/pages/auth/login_page.dart';
import 'presentation/pages/auth/register_page.dart';
import 'presentation/pages/auth/verify_email_page.dart';
import 'presentation/pages/auth/phone_verification_page.dart';
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
    // Configurar el idioma español para Firebase Auth
    await FirebaseAuth.instance.setLanguageCode('es');
    
    // Configurar la inyección de dependencias
    configureDependencies();
    
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
    // Configuración con inyección de dependencias ya inicializada
    
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => GetIt.instance<AuthBloc>()..add(AuthCheckRequested()),
        ),
      ],
      child: MaterialApp(
        title: 'Agenda Glam',
        theme: appTheme,
        debugShowCheckedModeBanner: false, // Eliminar banner de debug
        initialRoute: '/',
        onGenerateRoute: (settings) {
          
          switch (settings.name) {
            case PasswordResetPage.routeName:
              // Ruta para la página de recuperación de contraseña
              final args = settings.arguments;
              return MaterialPageRoute(
                builder: (context) => PasswordResetPage(
                  // Si hay argumentos y es un booleano, lo pasamos como showSuccessMessage
                  showSuccessMessage: args is bool ? args : false,
                ),
                settings: settings,
              );
              
            case LoginPage.routeName:
              // Ruta para la página de inicio de sesión
              final args = settings.arguments;
              return MaterialPageRoute(
                builder: (context) => LoginPage(
                  // Si hay argumentos y es un booleano, lo pasamos como fromRegistration
                  fromRegistration: args is bool ? args : false,
                ),
                settings: settings,
              );
              
            case RegisterPage.routeName:
              // Ruta para la página de registro
              return MaterialPageRoute(
                builder: (context) => const RegisterPage(),
                settings: settings,
              );
              
            default:
              return null; // Permitir que el sistema de rutas maneje las rutas no especificadas
          }
        },
        routes: {
          '/': (context) => const WelcomePage(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/home': (context) => const HomePage(),
          '/password-reset': (context) => const PasswordResetPage(),
          '/verify-email': (context) => VerifyEmailPage(
            email: (ModalRoute.of(context)?.settings.arguments as String?) ?? '',
          ),
          '/phone-verification': (context) {
            final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
            return PhoneVerificationPage(
              verificationId: args?['verificationId'] ?? '',
              phoneNumber: args?['phoneNumber'] ?? '',
              password: args?['password'],
              isForRegistration: args?['isForRegistration'] ?? false,
            );
          },
        },
      ),
    );
  }
}
