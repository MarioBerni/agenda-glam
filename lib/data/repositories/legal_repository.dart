import 'package:injectable/injectable.dart';

import '../../domain/repositories/legal_repository_interface.dart';
import '../models/legal_consent_model.dart';
import '../models/legal_document_model.dart';
import '../services/legal_service.dart';

/// Repositorio para gestionar documentos legales y consentimientos
@LazySingleton(as: LegalRepositoryInterface)
class LegalRepository implements LegalRepositoryInterface {
  final LegalService _legalService;

  LegalRepository(this._legalService);

  /// Registra el consentimiento del usuario
  @override
  Future<void> registerConsent({
    required String userId,
    String? ipAddress,
  }) async {
    await _legalService.registerConsent(
      userId: userId,
      ipAddress: ipAddress,
    );
  }

  /// Verifica si el usuario ha aceptado la última versión de los términos y condiciones
  @override
  Future<bool> hasAcceptedLatestTerms(String userId) async {
    return !(await _legalService.needsToAcceptNewTerms(userId));
  }

  /// Obtiene el documento legal activo por tipo
  @override
  Future<LegalDocumentModel?> getActiveDocument(LegalDocumentType type) async {
    return await _legalService.getActiveDocument(type);
  }

  /// Obtiene el historial de consentimientos de un usuario
  Future<List<LegalConsentModel>> getUserConsentHistory(String userId) async {
    return await _legalService.getUserConsentHistory(userId);
  }

  /// Obtiene el historial de versiones de un tipo de documento
  Future<List<LegalDocumentModel>> getDocumentVersionHistory(
    LegalDocumentType type,
  ) async {
    return await _legalService.getDocumentVersionHistory(type);
  }

  /// Obtiene la versión actual de los términos y condiciones
  @override
  Future<String> getCurrentTermsVersion() async {
    final document = await _legalService.getActiveDocument(LegalDocumentType.termsAndConditions);
    return document?.version ?? '1.0';
  }

  /// Obtiene la versión actual de la política de privacidad
  @override
  Future<String> getCurrentPrivacyPolicyVersion() async {
    final document = await _legalService.getActiveDocument(LegalDocumentType.privacyPolicy);
    return document?.version ?? '1.0';
  }

  /// Registra la aceptación de una nueva versión de los términos y condiciones
  @override
  Future<void> acceptNewTermsVersion({
    required String userId,
    required String termsVersion,
    required String privacyPolicyVersion,
    String? ipAddress,
  }) async {
    await _legalService.registerConsent(
      userId: userId,
      ipAddress: ipAddress,
      termsVersion: termsVersion,
      privacyPolicyVersion: privacyPolicyVersion,
    );
  }

  /// Crea una nueva versión de un documento legal
  Future<void> createNewDocumentVersion({
    required LegalDocumentType type,
    required String version,
    required String title,
    required String content,
    String? documentUrl,
  }) async {
    await _legalService.createNewDocumentVersion(
      type: type,
      version: version,
      title: title,
      content: content,
      documentUrl: documentUrl,
    );
  }
}
