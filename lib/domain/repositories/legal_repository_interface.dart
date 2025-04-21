import '../../data/models/legal_document_model.dart';

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
}
