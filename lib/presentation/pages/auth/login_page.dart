import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget { 
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> { 
  final _formKey = GlobalKey<FormState>(); 
  bool _obscurePassword = true; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido a Agenda Glam'), 
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0), 
        child: Center(
          child: SingleChildScrollView( 
            child: Form( 
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // TODO: Añadir logo o imagen de bienvenida aquí si se desea
                  const SizedBox(height: 48.0),

                  // --- Campo Email/Usuario ---
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email o Usuario',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    // TODO: Añadir validator
                  ),
                  const SizedBox(height: 16.0),

                  // --- Campo Contraseña ---
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscurePassword,
                    // TODO: Añadir validator
                  ),
                  const SizedBox(height: 24.0),

                  // --- Botón Iniciar Sesión ---
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implementar lógica de inicio de sesión
                      // if (_formKey.currentState!.validate()) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     const SnackBar(content: Text('Procesando...')),
                      //   );
                      // }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text('Iniciar Sesión'),
                  ),
                  const SizedBox(height: 16.0),

                  // --- Opción Registrarse / Olvidó Contraseña ---
                  TextButton(
                    onPressed: () {
                      // TODO: Implementar navegación a pantalla de registro
                    },
                    child: Text(
                      '¿No tienes cuenta? Regístrate',
                      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                  // Podríamos añadir aquí un botón para 'Olvidó contraseña'
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
