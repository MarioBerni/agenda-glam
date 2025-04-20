import '../models/legal_consent_model.dart';
import '../models/legal_document_model.dart';
import '../services/legal_service.dart';

/// Repositorio para gestionar documentos legales y consentimientos
class LegalRepository {
  final LegalService _legalService = LegalService();

  /// Registra el consentimiento del usuario
  Future<void> registerConsent({
    required String userId,
    String? ipAddress,
  }) async {
    await _legalService.registerConsent(
      userId: userId,
      ipAddress: ipAddress,
    );
  }

  /// Verifica si el usuario necesita aceptar nuevos términos
  Future<bool> needsToAcceptNewTerms(String userId) async {
    return await _legalService.needsToAcceptNewTerms(userId);
  }

  /// Obtiene el documento legal activo por tipo
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
