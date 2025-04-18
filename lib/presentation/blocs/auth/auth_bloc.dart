import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<User?>? _authStateSubscription;

  AuthBloc({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository(),
        super(AuthState.initial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<SignInRequested>(_onSignInRequested);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<PasswordResetRequested>(_onPasswordResetRequested);
    on<SendEmailVerificationRequested>(_onSendEmailVerificationRequested);
    on<ReloadUserRequested>(_onReloadUserRequested);

    // Suscribirse a los cambios de estado de autenticación
    _authStateSubscription = _authRepository.authStateChanges.listen(
      (User? user) {
        if (user != null) {
          add(AuthCheckRequested());
        } else {
          add(AuthCheckRequested());
        }
      },
    );
  }

  Future<void> _onAuthCheckRequested(
      AuthCheckRequested event, Emitter<AuthState> emit,) async {
    final User? currentUser = _authRepository.currentUser;
    if (currentUser != null) {
      // Si el usuario se autenticó con email y no ha verificado su correo
      if (currentUser.providerData.any((provider) => provider.providerId == 'password') &&
          !currentUser.emailVerified) {
        emit(AuthState.emailNotVerified(currentUser));
      } else {
        // Determinar el método de autenticación
        String? authMethod;
        if (currentUser.providerData.isNotEmpty) {
          final providerId = currentUser.providerData.first.providerId;
          if (providerId == 'password') {
            authMethod = 'email';
          } else if (providerId == 'google.com') {
            authMethod = 'google';
          }
        }
        emit(AuthState.authenticated(currentUser, authMethod: authMethod));
      }
    } else {
      emit(AuthState.unauthenticated());
    }
  }

  Future<void> _onSignInRequested(
      SignInRequested event, Emitter<AuthState> emit,) async {
    emit(AuthState.loading());
    try {
      final userCredential = await _authRepository.signInWithEmailAndPassword(
        event.email,
        event.password,
      );
      
      // Verificar si el email está verificado
      if (!userCredential.user!.emailVerified) {
        emit(AuthState.emailNotVerified(userCredential.user!));
      }
      // No emitimos estado de autenticación aquí, ya que el listener de authStateChanges
      // actualizará el estado automáticamente
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> _onGoogleSignInRequested(
      GoogleSignInRequested event, Emitter<AuthState> emit,) async {
    emit(AuthState.loading());
    try {
      await _authRepository.signInWithGoogle();
      // No emitimos estado aquí, ya que el listener de authStateChanges
      // actualizará el estado automáticamente
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> _onSignUpRequested(
      SignUpRequested event, Emitter<AuthState> emit,) async {
    emit(AuthState.loading());
    try {
      final userCredential = await _authRepository.createUserWithEmailAndPassword(
        event.email,
        event.password,
      );
      
      // Después del registro, el usuario necesita verificar su email
      emit(AuthState.emailVerificationSent(userCredential.user!));
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> _onSignOutRequested(
      SignOutRequested event, Emitter<AuthState> emit,) async {
    try {
      await _authRepository.signOut();
      // No emitimos estado aquí, ya que el listener de authStateChanges
      // actualizará el estado automáticamente
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> _onPasswordResetRequested(
      PasswordResetRequested event, Emitter<AuthState> emit,) async {
    emit(AuthState.loading());
    try {
      await _authRepository.sendPasswordResetEmail(event.email);
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: 'Se ha enviado un correo para restablecer tu contraseña',
      ));
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> _onSendEmailVerificationRequested(
      SendEmailVerificationRequested event, Emitter<AuthState> emit,) async {
    if (state.user == null) return;
    
    emit(AuthState.loading());
    try {
      await _authRepository.sendEmailVerification();
      emit(AuthState.emailVerificationSent(state.user!));
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> _onReloadUserRequested(
      ReloadUserRequested event, Emitter<AuthState> emit,) async {
    if (state.user == null) return;
    
    emit(AuthState.loading());
    try {
      await _authRepository.reloadUser();
      add(AuthCheckRequested());
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
