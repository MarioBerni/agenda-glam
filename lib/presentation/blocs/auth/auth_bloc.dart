import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/repositories/legal_repository.dart';
import '../../../data/services/auth_service.dart'; // Importamos para acceder a PhoneAuthState
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final LegalRepository _legalRepository;
  StreamSubscription<User?>? _authStateSubscription;
  StreamSubscription<PhoneAuthState>? _phoneAuthStateSubscription;

  AuthBloc({
    AuthRepository? authRepository,
    UserRepository? userRepository,
    LegalRepository? legalRepository,
  })  : _authRepository = authRepository ?? AuthRepository(),
        _userRepository = userRepository ?? UserRepository(),
        _legalRepository = legalRepository ?? LegalRepository(),
        super(AuthState.initial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<SignInRequested>(_onSignInRequested);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<PasswordResetRequested>(_onPasswordResetRequested);
    on<SendEmailVerificationRequested>(_onSendEmailVerificationRequested);
    on<ReloadUserRequested>(_onReloadUserRequested);
    
    // Eventos para autenticación por teléfono
    on<PhoneVerificationRequested>(_onPhoneVerificationRequested);
    on<VerifySmsCodeRequested>(_onVerifySmsCodeRequested);
    on<PasswordResetBySmsRequested>(_onPasswordResetBySmsRequested);
    on<UpdatePasswordAfterPhoneVerificationRequested>(_onUpdatePasswordAfterPhoneVerification);
    on<SmsCodeSentReceived>(_onSmsCodeSentReceived);
    on<PhoneVerificationCompletedReceived>(_onPhoneVerificationCompletedReceived);
    on<PhoneVerificationErrorReceived>(_onPhoneVerificationErrorReceived);
    on<PhonePasswordUpdatedEvent>(_onPhonePasswordUpdated);

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
    
    // Suscribirse a los cambios de estado de autenticación por teléfono
    _phoneAuthStateSubscription = _authRepository.phoneAuthStateChanges.listen(
      (PhoneAuthState phoneState) {
        // Manejar cambios en el estado de autenticación por teléfono
        if (phoneState == PhoneAuthState.passwordUpdated) {
          // Usar add en lugar de emit en listeners
          add(PhonePasswordUpdatedEvent());
        }
        // Los demás estados se manejan en los callbacks
      },
    );
  }

  Future<void> _onAuthCheckRequested(
      AuthCheckRequested event, Emitter<AuthState> emit,) async {
    final User? currentUser = _authRepository.currentUser;
    if (currentUser != null) {
      // Verificar si es el primer inicio de sesión
      bool isFirstLogin = false;
      try {
        isFirstLogin = await _userRepository.isFirstLogin();
      } catch (e) {
        // Si hay error al verificar, asumimos que no es el primer inicio de sesión
      }
      
      // Intentar obtener datos adicionales del usuario desde Firestore
      Map<String, dynamic>? userData;
      try {
        userData = await _userRepository.getCurrentUserData();
      } catch (e) {
        // Si hay error al obtener datos, continuamos con los datos básicos
      }
      
      // Crear un modelo de usuario con los datos disponibles
      final UserModel userModel = userData != null 
          ? UserModel.fromFirestore(userData)
          : UserModel.fromFirebaseUser(currentUser);
      
      // Si el usuario se autenticó con email y no ha verificado su correo
      if (currentUser.providerData.any((provider) => provider.providerId == 'password') &&
          !currentUser.emailVerified) {
        emit(AuthState.emailNotVerified(currentUser, userModel: userModel));
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
        
        // Verificar si es el primer inicio de sesión para mostrar la pantalla de bienvenida
        if (isFirstLogin) {
          emit(AuthState.firstLogin(currentUser, authMethod: authMethod, userModel: userModel));
        } else {
          emit(AuthState.authenticated(currentUser, authMethod: authMethod, userModel: userModel));
        }
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
      
      // Actualizar la fecha de último inicio de sesión
      try {
        await _userRepository.saveInitialUserData(userCredential.user!);
      } catch (e) {
        // Si falla la actualización de datos, continuamos con el flujo principal
      }
      
      // Verificar si el email está verificado
      if (!userCredential.user!.emailVerified) {
        final userModel = UserModel.fromFirebaseUser(userCredential.user!);
        emit(AuthState.emailNotVerified(userCredential.user!, userModel: userModel));
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
      final userCredential = await _authRepository.signInWithGoogle();
      
      // Guardar o actualizar datos del usuario en Firestore
      try {
        await _userRepository.saveInitialUserData(userCredential.user!);
      } catch (e) {
        // Si falla la actualización de datos, continuamos con el flujo principal
      }
      
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
      // Verificar que se aceptaron los términos y condiciones
      if (!event.hasAcceptedTerms) {
        emit(AuthState.error('Debes aceptar los términos y condiciones para registrarte'));
        return;
      }
      
      final userCredential = await _authRepository.createUserWithEmailAndPassword(
        event.email,
        event.password,
      );
      
      // Guardar datos iniciales del usuario en Firestore
      try {
        await _userRepository.saveInitialUserData(userCredential.user!);
      } catch (e) {
        // Si falla la creación de datos, continuamos con el flujo principal
      }
      
      // Crear modelo de usuario
      final userModel = UserModel.fromFirebaseUser(userCredential.user!);
      
      // Registrar el consentimiento legal
      if (userCredential.user != null) {
        try {
          await _legalRepository.registerConsent(
            userId: userCredential.user!.uid,
            ipAddress: event.ipAddress,
          );
        } catch (legalError) {
          // Registramos el error pero no interrumpimos el flujo
          debugPrint('Error al registrar consentimiento legal: $legalError');
        }
      }
      
      // Enviar email de verificación
      await _authRepository.sendEmailVerification();
      // Después del registro, el usuario necesita verificar su email
      emit(AuthState.emailVerificationSent(userCredential.user!, userModel: userModel));
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
      emit(AuthState.passwordResetSent(event.email));
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

  Future<void> _onPhoneVerificationRequested(
      PhoneVerificationRequested event, Emitter<AuthState> emit) async {
    emit(AuthState.loading());
    
    try {
      await _authRepository.verifyPhoneNumber(
        phoneNumber: event.phoneNumber,
        isForRegistration: event.isForRegistration,
        onCodeSent: (String verificationId) {
          add(SmsCodeSentReceived(verificationId: verificationId));
        },
        onVerificationCompleted: (PhoneAuthCredential credential) {
          add(PhoneVerificationCompletedReceived(credential: credential));
        },
        onError: (String errorMessage) {
          add(PhoneVerificationErrorReceived(errorMessage: errorMessage));
        },
      );
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> _onVerifySmsCodeRequested(
      VerifySmsCodeRequested event, Emitter<AuthState> emit) async {
    emit(AuthState.loading());
    
    try {
      final userCredential = await _authRepository.verifyPhoneSmsCode(
        verificationId: event.verificationId,
        smsCode: event.smsCode,
        email: event.email,
        password: event.password,
      );
      
      if (userCredential.user != null) {
        final isFirstLogin = await _userRepository.isFirstLogin();
        emit(AuthState.phoneVerified(
          userCredential.user!,
          isFirstLogin: isFirstLogin,
        ));
      } else {
        emit(AuthState.error('Error al verificar el código SMS'));
      }
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> _onPasswordResetBySmsRequested(
      PasswordResetBySmsRequested event, Emitter<AuthState> emit) async {
    emit(AuthState.loading());
    
    try {
      await _authRepository.sendPasswordResetBySms(
        phoneNumber: event.phoneNumber,
        onCodeSent: (String verificationId) {
          emit(AuthState.phonePasswordResetSent(verificationId, event.phoneNumber));
        },
        onVerified: () {
          emit(AuthState.phonePasswordUpdated());
        },
        onError: (String errorMessage) {
          emit(AuthState.error(errorMessage));
        },
      );
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> _onUpdatePasswordAfterPhoneVerification(
      UpdatePasswordAfterPhoneVerificationRequested event, Emitter<AuthState> emit) async {
    emit(AuthState.loading());
    
    try {
      await _authRepository.updatePasswordAfterPhoneVerification(
        verificationId: event.verificationId,
        smsCode: event.smsCode,
        newPassword: event.newPassword,
      );
      
      emit(AuthState.phonePasswordUpdated());
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  void _onSmsCodeSentReceived(
      SmsCodeSentReceived event, Emitter<AuthState> emit) {
    final currentState = state;
    final phoneNumber = currentState.phoneNumber;
    
    if (phoneNumber != null) {
      emit(AuthState.phoneVerificationSent(event.verificationId, phoneNumber));
    } else {
      // Si no tenemos el número de teléfono en el estado, usamos uno genérico
      emit(AuthState.phoneVerificationSent(event.verificationId, 'tu teléfono'));
    }
  }

  Future<void> _onPhoneVerificationCompletedReceived(
      PhoneVerificationCompletedReceived event, Emitter<AuthState> emit) async {
    emit(AuthState.loading());
    
    try {
      final userCredential = await _authRepository.signInWithCredential(event.credential);
      
      if (userCredential.user != null) {
        final isFirstLogin = await _userRepository.isFirstLogin();
        emit(AuthState.phoneVerified(
          userCredential.user!,
          isFirstLogin: isFirstLogin,
        ));
      } else {
        emit(AuthState.error('Error al verificar automáticamente'));
      }
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  void _onPhoneVerificationErrorReceived(
      PhoneVerificationErrorReceived event, Emitter<AuthState> emit) {
    emit(AuthState.phoneVerificationError(event.errorMessage));
  }

  Future<void> _onPhonePasswordUpdated(
      PhonePasswordUpdatedEvent event, Emitter<AuthState> emit) async {
    emit(AuthState.phonePasswordUpdated());
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    _phoneAuthStateSubscription?.cancel();
    _authRepository.dispose();
    return super.close();
  }
}
