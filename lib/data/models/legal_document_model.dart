import 'package:cloud_firestore/cloud_firestore.dart';

/// Tipo de documento legal
enum LegalDocumentType {
  /// Términos y condiciones
  termsAndConditions,
  
  /// Política de privacidad
  privacyPolicy
}

/// Modelo para almacenar versiones de documentos legales
class LegalDocumentModel {
  /// ID único del documento
  final String id;
  
  /// Tipo de documento legal
  final LegalDocumentType documentType;
  
  /// Versión del documento
  final String version;
  
  /// Título del documento
  final String title;
  
  /// Contenido del documento
  final String content;
  
  /// Fecha de publicación
  final DateTime publishDate;
  
  /// Indica si es la versión activa
  final bool isActive;
  
  /// URL del documento (opcional, para documentos externos)
  final String? documentUrl;

  /// Constructor
  LegalDocumentModel({
    required this.id,
    required this.documentType,
    required this.version,
    required this.title,
    required this.content,
    required this.publishDate,
    required this.isActive,
    this.documentUrl,
  });

  /// Crea una instancia desde un mapa de datos (para Firestore)
  factory LegalDocumentModel.fromMap(Map<String, dynamic> map, String documentId) {
    return LegalDocumentModel(
      id: documentId,
      documentType: LegalDocumentType.values.firstWhere(
        (e) => e.toString().split('.').last == map['documentType'],
        orElse: () => LegalDocumentType.termsAndConditions,
      ),
      version: map['version'] ?? '1.0',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      publishDate: (map['publishDate'] as Timestamp).toDate(),
      isActive: map['isActive'] ?? false,
      documentUrl: map['documentUrl'],
    );
  }

  /// Convierte la instancia a un mapa de datos (para Firestore)
  Map<String, dynamic> toMap() {
    return {
      'documentType': documentType.toString().split('.').last,
      'version': version,
      'title': title,
      'content': content,
      'publishDate': Timestamp.fromDate(publishDate),
      'isActive': isActive,
      'documentUrl': documentUrl,
    };
  }
}
