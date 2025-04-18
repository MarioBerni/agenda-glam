import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

// Evento para solicitar verificación de número de teléfono
class PhoneVerificationRequested extends AuthEvent {
  final String phoneNumber;
  final bool isForRegistration;
  
  const PhoneVerificationRequested({
    required this.phoneNumber,
    this.isForRegistration = false,
  });
  
  @override
  List<Object?> get props => [phoneNumber, isForRegistration];
}

// Evento para verificar el código SMS recibido
class VerifySmsCodeRequested extends AuthEvent {
  final String verificationId;
  final String smsCode;
  final String? email;
  final String? password;
  
  const VerifySmsCodeRequested({
    required this.verificationId,
    required this.smsCode,
    this.email,
    this.password,
  });
  
  @override
  List<Object?> get props => [verificationId, smsCode, email, password];
}

// Evento para solicitar recuperación de contraseña por SMS
class PasswordResetBySmsRequested extends AuthEvent {
  final String phoneNumber;
  
  const PasswordResetBySmsRequested({required this.phoneNumber});
  
  @override
  List<Object?> get props => [phoneNumber];
}

// Evento para actualizar contraseña después de verificación por teléfono
class UpdatePasswordAfterPhoneVerificationRequested extends AuthEvent {
  final String verificationId;
  final String smsCode;
  final String newPassword;
  
  const UpdatePasswordAfterPhoneVerificationRequested({
    required this.verificationId,
    required this.smsCode,
    required this.newPassword,
  });
  
  @override
  List<Object?> get props => [verificationId, smsCode, newPassword];
}

// Evento cuando se recibe un código de verificación por SMS
class SmsCodeSentReceived extends AuthEvent {
  final String verificationId;
  
  const SmsCodeSentReceived({required this.verificationId});
  
  @override
  List<Object?> get props => [verificationId];
}

// Evento cuando la verificación por teléfono se completa automáticamente
class PhoneVerificationCompletedReceived extends AuthEvent {
  final PhoneAuthCredential credential;
  
  const PhoneVerificationCompletedReceived({required this.credential});
  
  @override
  List<Object?> get props => [credential];
}

// Evento cuando ocurre un error en la verificación por teléfono
class PhoneVerificationErrorReceived extends AuthEvent {
  final String errorMessage;
  
  const PhoneVerificationErrorReceived({required this.errorMessage});
  
  @override
  List<Object?> get props => [errorMessage];
}

// Evento cuando la contraseña se actualiza después de verificación por teléfono
class PhonePasswordUpdatedEvent extends AuthEvent {}

