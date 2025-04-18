import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/models/user_model.dart';

enum AuthStatus { 
  initial, 
  authenticated, 
  unauthenticated, 
  loading, 
  error, 
  emailNotVerified,
  emailVerificationSent,
  passwordResetSent,
  firstLogin,
  // Estados para autenticación por teléfono
  phoneVerificationSent,
  phoneVerified,
  phoneVerificationError,
  phonePasswordResetSent,
  phonePasswordUpdated
}

class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;
  final UserModel? userModel;
  final String? errorMessage;
  final bool isEmailVerified;
  final String? authMethod; // 'email', 'google', 'phone', etc.
  final bool isFirstLogin;
  final String? verificationId; // Para autenticación por teléfono
  final String? phoneNumber; // Número de teléfono para autenticación

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.userModel,
    this.errorMessage,
    this.isEmailVerified = false,
    this.authMethod,
    this.isFirstLogin = false,
    this.verificationId,
    this.phoneNumber,
  });

  // Estados iniciales
  factory AuthState.initial() => const AuthState();
  
  factory AuthState.loading() => const AuthState(status: AuthStatus.loading);
  
  factory AuthState.authenticated(User user, {String? authMethod, UserModel? userModel, bool isFirstLogin = false}) => 
      AuthState(
        status: AuthStatus.authenticated, 
        user: user, 
        userModel: userModel,
        isEmailVerified: user.emailVerified,
        authMethod: authMethod,
        isFirstLogin: isFirstLogin,
      );
      
  factory AuthState.firstLogin(User user, {String? authMethod, UserModel? userModel}) => 
      AuthState(
        status: AuthStatus.firstLogin, 
        user: user, 
        userModel: userModel,
        isEmailVerified: user.emailVerified,
        authMethod: authMethod,
        isFirstLogin: true,
      );
  
  factory AuthState.unauthenticated() => 
      const AuthState(status: AuthStatus.unauthenticated);
  
  factory AuthState.error(String message) => 
      AuthState(status: AuthStatus.error, errorMessage: message);

  factory AuthState.emailNotVerified(User user, {UserModel? userModel}) =>
      AuthState(
        status: AuthStatus.emailNotVerified, 
        user: user,
        userModel: userModel,
        authMethod: 'email',
      );

  factory AuthState.emailVerificationSent(User user, {UserModel? userModel}) =>
      AuthState(
        status: AuthStatus.emailVerificationSent, 
        user: user,
        userModel: userModel,
        authMethod: 'email',
      );

  factory AuthState.passwordResetSent(String email) =>
      AuthState(
        status: AuthStatus.passwordResetSent, 
        errorMessage: email, // Usamos errorMessage para almacenar el email temporalmente
      );

  // Estados para autenticación por teléfono
  factory AuthState.phoneVerificationSent(String verificationId, String phoneNumber) =>
      AuthState(
        status: AuthStatus.phoneVerificationSent,
        verificationId: verificationId,
        phoneNumber: phoneNumber,
        authMethod: 'phone',
      );
      
  factory AuthState.phoneVerified(User user, {UserModel? userModel, bool isFirstLogin = false}) =>
      AuthState(
        status: AuthStatus.phoneVerified,
        user: user,
        userModel: userModel,
        authMethod: 'phone',
        isFirstLogin: isFirstLogin,
      );
      
  factory AuthState.phoneVerificationError(String errorMessage) =>
      AuthState(
        status: AuthStatus.phoneVerificationError,
        errorMessage: errorMessage,
      );
      
  factory AuthState.phonePasswordResetSent(String verificationId, String phoneNumber) =>
      AuthState(
        status: AuthStatus.phonePasswordResetSent,
        verificationId: verificationId,
        phoneNumber: phoneNumber,
      );
      
  factory AuthState.phonePasswordUpdated() =>
      const AuthState(
        status: AuthStatus.phonePasswordUpdated,
      );

  // Método para copiar el estado con nuevos valores
  AuthState copyWith({
    AuthStatus? status,
    User? user,
    UserModel? userModel,
    String? errorMessage,
    bool? isEmailVerified,
    String? authMethod,
    bool? isFirstLogin,
    String? verificationId,
    String? phoneNumber,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      userModel: userModel ?? this.userModel,
      errorMessage: errorMessage ?? this.errorMessage,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      authMethod: authMethod ?? this.authMethod,
      isFirstLogin: isFirstLogin ?? this.isFirstLogin,
      verificationId: verificationId ?? this.verificationId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  List<Object?> get props => [status, user, userModel, errorMessage, isEmailVerified, authMethod, isFirstLogin];
}
