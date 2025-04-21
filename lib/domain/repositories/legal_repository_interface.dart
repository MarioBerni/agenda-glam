import '../../data/models/legal_document_model.dart';
import '../../data/models/legal_consent_model.dart';

/// Interfaz para el repositorio de gestión legal
abstract class LegalRepositoryInterface {
  /// Registra el consentimiento legal del usuario
  Future<void> registerConsent({
    required String userId,
    String? ipAddress,
  });

  /// Verifica si el usuario ha aceptado la última versión de los términos y condiciones
  Future<bool> hasAcceptedLatestTerms(String userId);

  /// Obtiene la versión actual de los términos y condiciones
  Future<String> getCurrentTermsVersion();

  /// Obtiene la versión actual de la política de privacidad
  Future<String> getCurrentPrivacyPolicyVersion();
  
  /// Obtiene el documento legal activo por tipo
  Future<LegalDocumentModel?> getActiveDocument(LegalDocumentType type);

  /// Registra la aceptación de una nueva versión de los términos y condiciones
  Future<void> acceptNewTermsVersion({
    required String userId,
    required String termsVersion,
    required String privacyPolicyVersion,
    String? ipAddress,
  });
  
  /// Obtiene el historial de consentimientos de un usuario
  Future<List<LegalConsentModel>> getUserConsentHistory(String userId);

  /// Obtiene el historial de versiones de un tipo de documento
  Future<List<LegalDocumentModel>> getDocumentVersionHistory(
    LegalDocumentType type,
  );

  /// Crea una nueva versión de un documento legal
  Future<void> createNewDocumentVersion({
    required LegalDocumentType type,
    required String version,
    required String title,
    required String content,
    String? documentUrl,
  });
}
