import 'package:flutter/material.dart';
import 'core/theme/theme.dart';
// import 'presentation/pages/home_page.dart';
// import 'presentation/pages/auth/login_page.dart';
import 'presentation/pages/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda Glam',
      theme: appTheme,
      debugShowCheckedModeBanner: false, // Eliminar banner de debug
      home: const WelcomePage(),
    );
  }
}
