import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// Evento para verificar el estado de autenticación al iniciar la app
class AuthCheckRequested extends AuthEvent {}

// Evento para iniciar sesión con email y contraseña
class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

// Evento para iniciar sesión con Google
class GoogleSignInRequested extends AuthEvent {}

// Evento para registrar un nuevo usuario
class SignUpRequested extends AuthEvent {
  final String email;
  final String password;

  const SignUpRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

// Evento para cerrar sesión
class SignOutRequested extends AuthEvent {}

// Evento para recuperar contraseña
class PasswordResetRequested extends AuthEvent {
  final String email;

  const PasswordResetRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

// Evento para enviar email de verificación
class SendEmailVerificationRequested extends AuthEvent {}

// Evento para recargar el usuario y verificar si el email está verificado
class ReloadUserRequested extends AuthEvent {}
