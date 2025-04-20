import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo para almacenar información sobre el consentimiento legal del usuario
class LegalConsentModel {
  /// ID único del consentimiento
  final String id;
  
  /// ID del usuario que dio el consentimiento
  final String userId;
  
  /// Versión de los términos y condiciones aceptados
  final String termsVersion;
  
  /// Versión de la política de privacidad aceptada
  final String privacyVersion;
  
  /// Fecha y hora en que se dio el consentimiento
  final DateTime consentDate;
  
  /// Dirección IP desde la que se dio el consentimiento (opcional)
  final String? ipAddress;
  
  /// Dispositivo desde el que se dio el consentimiento (opcional)
  final String? deviceInfo;

  /// Constructor
  LegalConsentModel({
    required this.id,
    required this.userId,
    required this.termsVersion,
    required this.privacyVersion,
    required this.consentDate,
    this.ipAddress,
    this.deviceInfo,
  });

  /// Crea una instancia desde un mapa de datos (para Firestore)
  factory LegalConsentModel.fromMap(Map<String, dynamic> map, String documentId) {
    return LegalConsentModel(
      id: documentId,
      userId: map['userId'] ?? '',
      termsVersion: map['termsVersion'] ?? '',
      privacyVersion: map['privacyVersion'] ?? '',
      consentDate: (map['consentDate'] as Timestamp).toDate(),
      ipAddress: map['ipAddress'],
      deviceInfo: map['deviceInfo'],
    );
  }

  /// Convierte la instancia a un mapa de datos (para Firestore)
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'termsVersion': termsVersion,
      'privacyVersion': privacyVersion,
      'consentDate': Timestamp.fromDate(consentDate),
      'ipAddress': ipAddress,
      'deviceInfo': deviceInfo,
    };
  }
}
