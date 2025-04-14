import 'package:flutter/material.dart';
import 'core/theme/theme.dart';
// import 'presentation/pages/home_page.dart'; 
import 'presentation/pages/auth/login_page.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda Glam',
      theme: appTheme,
      // home: const MyHomePage(title: 'Agenda Glam Home'), 
      home: const LoginPage(), 
    );
  }
}
