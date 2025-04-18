import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AuthStatus { 
  initial, 
  authenticated, 
  unauthenticated, 
  loading, 
  error, 
  emailNotVerified,
  emailVerificationSent
}

class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;
  final bool isEmailVerified;
  final String? authMethod; // 'email', 'google', etc.

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.isEmailVerified = false,
    this.authMethod,
  });

  // Estados iniciales
  factory AuthState.initial() => const AuthState();
  
  factory AuthState.loading() => const AuthState(status: AuthStatus.loading);
  
  factory AuthState.authenticated(User user, {String? authMethod}) => 
      AuthState(
        status: AuthStatus.authenticated, 
        user: user, 
        isEmailVerified: user.emailVerified,
        authMethod: authMethod,
      );
  
  factory AuthState.unauthenticated() => 
      const AuthState(status: AuthStatus.unauthenticated);
  
  factory AuthState.error(String message) => 
      AuthState(status: AuthStatus.error, errorMessage: message);

  factory AuthState.emailNotVerified(User user) =>
      AuthState(
        status: AuthStatus.emailNotVerified, 
        user: user,
        authMethod: 'email',
      );

  factory AuthState.emailVerificationSent(User user) =>
      AuthState(
        status: AuthStatus.emailVerificationSent, 
        user: user,
        authMethod: 'email',
      );

  // Método para copiar el estado con nuevos valores
  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
    bool? isEmailVerified,
    String? authMethod,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      authMethod: authMethod ?? this.authMethod,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage, isEmailVerified, authMethod];
}
