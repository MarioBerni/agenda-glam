import 'package:agenda_glam/data/models/legal_consent_model.dart';
import 'package:agenda_glam/data/models/legal_document_model.dart';
import 'package:agenda_glam/data/repositories/legal_repository.dart';
import 'package:agenda_glam/data/services/legal_service.dart';
import 'package:agenda_glam/domain/repositories/legal_repository_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'legal_repository_test.mocks.dart';

@GenerateMocks([LegalService])
void main() {
  late MockLegalService mockLegalService;
  late LegalRepositoryInterface legalRepository;

  setUp(() {
    mockLegalService = MockLegalService();
    legalRepository = LegalRepository(mockLegalService);
  });

  group('LegalRepository', () {
    const userId = 'test_user_id';
    const ipAddress = '192.168.1.1';
    const termsVersion = '1.1';
    const privacyPolicyVersion = '1.2';

    test('registerConsent should call legalService.registerConsent', () async {
      // Arrange
      when(mockLegalService.registerConsent(
        userId: anyNamed('userId'),
        ipAddress: anyNamed('ipAddress'),
      )).thenAnswer((_) async {});

      // Act
      await legalRepository.registerConsent(
        userId: userId,
        ipAddress: ipAddress,
      );

      // Assert
      verify(mockLegalService.registerConsent(
        userId: userId,
        ipAddress: ipAddress,
      )).called(1);
    });

    test('hasAcceptedLatestTerms should return true when user has accepted latest terms', () async {
      // Arrange
      when(mockLegalService.needsToAcceptNewTerms(userId))
          .thenAnswer((_) async => false);

      // Act
      final result = await legalRepository.hasAcceptedLatestTerms(userId);

      // Assert
      expect(result, true);
      verify(mockLegalService.needsToAcceptNewTerms(userId)).called(1);
    });

    test('getActiveDocument should return document from legalService', () async {
      // Arrange
      final document = LegalDocumentModel(
        id: 'doc1',
        documentType: LegalDocumentType.termsAndConditions,
        version: '1.0',
        title: 'Términos y Condiciones',
        content: 'Contenido de los términos',
        publishDate: DateTime.now(),
        isActive: true,
      );

      when(mockLegalService.getActiveDocument(LegalDocumentType.termsAndConditions))
          .thenAnswer((_) async => document);

      // Act
      final result = await legalRepository.getActiveDocument(LegalDocumentType.termsAndConditions);

      // Assert
      expect(result, document);
      verify(mockLegalService.getActiveDocument(LegalDocumentType.termsAndConditions)).called(1);
    });

    test('getCurrentTermsVersion should return correct version', () async {
      // Arrange
      final document = LegalDocumentModel(
        id: 'doc1',
        documentType: LegalDocumentType.termsAndConditions,
        version: '1.0',
        title: 'Términos y Condiciones',
        content: 'Contenido de los términos',
        publishDate: DateTime.now(),
        isActive: true,
      );

      when(mockLegalService.getActiveDocument(LegalDocumentType.termsAndConditions))
          .thenAnswer((_) async => document);

      // Act
      final result = await legalRepository.getCurrentTermsVersion();

      // Assert
      expect(result, '1.0');
      verify(mockLegalService.getActiveDocument(LegalDocumentType.termsAndConditions)).called(1);
    });

    test('getCurrentPrivacyPolicyVersion should return correct version', () async {
      // Arrange
      final document = LegalDocumentModel(
        id: 'doc1',
        documentType: LegalDocumentType.privacyPolicy,
        version: '1.0',
        title: 'Política de Privacidad',
        content: 'Contenido de la política',
        publishDate: DateTime.now(),
        isActive: true,
      );

      when(mockLegalService.getActiveDocument(LegalDocumentType.privacyPolicy))
          .thenAnswer((_) async => document);

      // Act
      final result = await legalRepository.getCurrentPrivacyPolicyVersion();

      // Assert
      expect(result, '1.0');
      verify(mockLegalService.getActiveDocument(LegalDocumentType.privacyPolicy)).called(1);
    });

    test('acceptNewTermsVersion should call legalService.registerConsent with correct parameters', () async {
      // Arrange
      when(mockLegalService.registerConsent(
        userId: anyNamed('userId'),
        ipAddress: anyNamed('ipAddress'),
        termsVersion: anyNamed('termsVersion'),
        privacyPolicyVersion: anyNamed('privacyPolicyVersion'),
      )).thenAnswer((_) async {});

      // Act
      await legalRepository.acceptNewTermsVersion(
        userId: userId,
        termsVersion: termsVersion,
        privacyPolicyVersion: privacyPolicyVersion,
        ipAddress: ipAddress,
      );

      // Assert
      verify(mockLegalService.registerConsent(
        userId: userId,
        ipAddress: ipAddress,
        termsVersion: termsVersion,
        privacyPolicyVersion: privacyPolicyVersion,
      )).called(1);
    });

    test('getUserConsentHistory should return consent history from legalService', () async {
      // Arrange
      final consentHistory = [
        LegalConsentModel(
          id: 'consent1',
          userId: userId,
          termsVersion: '1.0',
          privacyVersion: '1.0',
          consentDate: DateTime.now(),
          ipAddress: ipAddress,
        ),
      ];

      when(mockLegalService.getUserConsentHistory(userId))
          .thenAnswer((_) async => consentHistory);

      // Act
      final result = await legalRepository.getUserConsentHistory(userId);

      // Assert
      expect(result, consentHistory);
      verify(mockLegalService.getUserConsentHistory(userId)).called(1);
    });

    test('getDocumentVersionHistory should return document history from legalService', () async {
      // Arrange
      final documentHistory = [
        LegalDocumentModel(
          id: 'doc1',
          documentType: LegalDocumentType.termsAndConditions,
          version: '1.0',
          title: 'Términos y Condiciones',
          content: 'Contenido de los términos',
          publishDate: DateTime.now(),
          isActive: true,
        ),
      ];

      when(mockLegalService.getDocumentVersionHistory(LegalDocumentType.termsAndConditions))
          .thenAnswer((_) async => documentHistory);

      // Act
      final result = await legalRepository.getDocumentVersionHistory(LegalDocumentType.termsAndConditions);

      // Assert
      expect(result, documentHistory);
      verify(mockLegalService.getDocumentVersionHistory(LegalDocumentType.termsAndConditions)).called(1);
    });

    test('createNewDocumentVersion should call legalService.createNewDocumentVersion with correct parameters', () async {
      // Arrange
      const type = LegalDocumentType.termsAndConditions;
      const version = '1.1';
      const title = 'Términos y Condiciones';
      const content = 'Nuevo contenido de los términos';
      const documentUrl = 'https://example.com/terms.pdf';

      when(mockLegalService.createNewDocumentVersion(
        type: anyNamed('type'),
        version: anyNamed('version'),
        title: anyNamed('title'),
        content: anyNamed('content'),
        documentUrl: anyNamed('documentUrl'),
      )).thenAnswer((_) async {});

      // Act
      await legalRepository.createNewDocumentVersion(
        type: type,
        version: version,
        title: title,
        content: content,
        documentUrl: documentUrl,
      );

      // Assert
      verify(mockLegalService.createNewDocumentVersion(
        type: type,
        version: version,
        title: title,
        content: content,
        documentUrl: documentUrl,
      )).called(1);
    });
  });
}
