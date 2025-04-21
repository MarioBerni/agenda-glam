import 'package:agenda_glam/data/repositories/auth_repository.dart';
import 'package:agenda_glam/data/services/auth_service.dart';
import 'package:agenda_glam/domain/repositories/auth_repository_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_repository_test.mocks.dart';

@GenerateMocks([AuthService, User, UserCredential])
void main() {
  late MockAuthService mockAuthService;
  late AuthRepositoryInterface authRepository;
  late MockUser mockUser;
  late MockUserCredential mockUserCredential;

  setUp(() {
    mockAuthService = MockAuthService();
    authRepository = AuthRepository(mockAuthService);
    mockUser = MockUser();
    mockUserCredential = MockUserCredential();
    
    // Configuración básica de mocks
    when(mockUserCredential.user).thenReturn(mockUser);
  });

  group('AuthRepository', () {
    test('currentUser should return user from authService', () {
      // Arrange
      when(mockAuthService.currentUser).thenReturn(mockUser);

      // Act
      final result = authRepository.currentUser;

      // Assert
      expect(result, mockUser);
      verify(mockAuthService.currentUser).called(1);
    });

    test('isEmailVerified should return value from authService', () {
      // Arrange
      when(mockAuthService.isEmailVerified).thenReturn(true);

      // Act
      final result = authRepository.isEmailVerified;

      // Assert
      expect(result, true);
      verify(mockAuthService.isEmailVerified).called(1);
    });

    test('signInWithEmailAndPassword should call authService method', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      
      when(mockAuthService.signInWithEmailAndPassword(email, password))
          .thenAnswer((_) async => mockUserCredential);

      // Act
      final result = await authRepository.signInWithEmailAndPassword(email, password);

      // Assert
      expect(result, mockUserCredential);
      verify(mockAuthService.signInWithEmailAndPassword(email, password)).called(1);
    });

    test('createUserWithEmailAndPassword should call authService method', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      
      when(mockAuthService.createUserWithEmailAndPassword(email, password))
          .thenAnswer((_) async => mockUserCredential);

      // Act
      final result = await authRepository.createUserWithEmailAndPassword(email, password);

      // Assert
      expect(result, mockUserCredential);
      verify(mockAuthService.createUserWithEmailAndPassword(email, password)).called(1);
    });

    test('signInWithGoogle should call authService method', () async {
      // Arrange
      when(mockAuthService.signInWithGoogle())
          .thenAnswer((_) async => mockUserCredential);

      // Act
      final result = await authRepository.signInWithGoogle();

      // Assert
      expect(result, mockUserCredential);
      verify(mockAuthService.signInWithGoogle()).called(1);
    });

    test('signOut should call authService method', () async {
      // Arrange
      when(mockAuthService.signOut()).thenAnswer((_) async {});

      // Act
      await authRepository.signOut();

      // Assert
      verify(mockAuthService.signOut()).called(1);
    });

    test('sendPasswordResetEmail should call authService method', () async {
      // Arrange
      const email = 'test@example.com';
      when(mockAuthService.sendPasswordResetEmail(email)).thenAnswer((_) async {});

      // Act
      await authRepository.sendPasswordResetEmail(email);

      // Assert
      verify(mockAuthService.sendPasswordResetEmail(email)).called(1);
    });

    test('sendEmailVerification should call authService method', () async {
      // Arrange
      when(mockAuthService.sendEmailVerification()).thenAnswer((_) async {});

      // Act
      await authRepository.sendEmailVerification();

      // Assert
      verify(mockAuthService.sendEmailVerification()).called(1);
    });

    test('reloadUser should call authService method', () async {
      // Arrange
      when(mockAuthService.reloadUser()).thenAnswer((_) async {});

      // Act
      await authRepository.reloadUser();

      // Assert
      verify(mockAuthService.reloadUser()).called(1);
    });

    test('verifyPhoneNumber should call authService method with correct parameters', () async {
      // Arrange
      const phoneNumber = '+1234567890';
      void onCodeSent(String verificationId) {}
      void onVerificationCompleted(PhoneAuthCredential credential) {}
      void onError(String error) {}
      const isForRegistration = true;

      when(mockAuthService.verifyPhoneNumber(
        phoneNumber: anyNamed('phoneNumber'),
        onCodeSent: anyNamed('onCodeSent'),
        onVerificationCompleted: anyNamed('onVerificationCompleted'),
        onError: anyNamed('onError'),
        isForRegistration: anyNamed('isForRegistration'),
      )).thenAnswer((_) async {});

      // Act
      await authRepository.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        onCodeSent: onCodeSent,
        onVerificationCompleted: onVerificationCompleted,
        onError: onError,
        isForRegistration: isForRegistration,
      );

      // Assert
      verify(mockAuthService.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        onCodeSent: onCodeSent,
        onVerificationCompleted: onVerificationCompleted,
        onError: onError,
        isForRegistration: isForRegistration,
      )).called(1);
    });

    test('verifyPhoneSmsCode should call authService method with correct parameters', () async {
      // Arrange
      const verificationId = 'verification_id';
      const smsCode = '123456';
      const email = 'test@example.com';
      const password = 'password123';

      when(mockAuthService.verifyPhoneSmsCode(
        verificationId: anyNamed('verificationId'),
        smsCode: anyNamed('smsCode'),
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => mockUserCredential);

      // Act
      final result = await authRepository.verifyPhoneSmsCode(
        verificationId: verificationId,
        smsCode: smsCode,
        email: email,
        password: password,
      );

      // Assert
      expect(result, mockUserCredential);
      verify(mockAuthService.verifyPhoneSmsCode(
        verificationId: verificationId,
        smsCode: smsCode,
        email: email,
        password: password,
      )).called(1);
    });

    test('dispose should call authService dispose', () {
      // Arrange
      when(mockAuthService.dispose()).thenReturn(null);

      // Act
      authRepository.dispose();

      // Assert
      verify(mockAuthService.dispose()).called(1);
    });
  });
}
