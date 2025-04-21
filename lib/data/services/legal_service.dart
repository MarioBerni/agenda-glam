import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../models/legal_consent_model.dart';
import '../models/legal_document_model.dart';

/// Servicio para gestionar documentos legales y consentimientos
@injectable
class LegalService {
  final FirebaseFirestore _firestore;
  final DeviceInfoPlugin _deviceInfo;
  
  LegalService(this._firestore) : _deviceInfo = DeviceInfoPlugin();

  /// Colección de documentos legales
  final String _legalDocumentsCollection = 'legal_documents';
  
  /// Colección de consentimientos
  final String _consentCollection = 'legal_consents';

  /// Obtiene la versión actual de un tipo de documento legal
  Future<String> getCurrentDocumentVersion(LegalDocumentType type) async {
    try {
      final querySnapshot = await _firestore
          .collection(_legalDocumentsCollection)
          .where('documentType', isEqualTo: type.toString().split('.').last)
          .where('isActive', isEqualTo: true)
          .orderBy('publishDate', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final document = LegalDocumentModel.fromMap(
          querySnapshot.docs.first.data(),
          querySnapshot.docs.first.id,
        );
        return document.version;
      }
      return '1.0'; // Versión por defecto si no hay documentos
    } catch (e) {
      debugPrint('Error al obtener la versión del documento: $e');
      return '1.0';
    }
  }

  /// Obtiene el documento legal activo por tipo
  Future<LegalDocumentModel?> getActiveDocument(LegalDocumentType type) async {
    try {
      final querySnapshot = await _firestore
          .collection(_legalDocumentsCollection)
          .where('documentType', isEqualTo: type.toString().split('.').last)
          .where('isActive', isEqualTo: true)
          .orderBy('publishDate', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return LegalDocumentModel.fromMap(
          querySnapshot.docs.first.data(),
          querySnapshot.docs.first.id,
        );
      }
      return null;
    } catch (e) {
      debugPrint('Error al obtener el documento: $e');
      return null;
    }
  }

  /// Registra el consentimiento del usuario
  Future<void> registerConsent({
    required String userId,
    String? ipAddress,
    String? termsVersion,
    String? privacyPolicyVersion,
  }) async {
    try {
      // Usar las versiones proporcionadas o obtener las actuales
      final finalTermsVersion = termsVersion ?? 
          await getCurrentDocumentVersion(LegalDocumentType.termsAndConditions);
      final finalPrivacyVersion = privacyPolicyVersion ?? 
          await getCurrentDocumentVersion(LegalDocumentType.privacyPolicy);

      // Obtener información del dispositivo
      final deviceInfoStr = await _getDeviceInfo();
      
      // Crear el modelo de consentimiento
      final consent = LegalConsentModel(
        id: '', // Firestore generará el ID
        userId: userId,
        termsVersion: finalTermsVersion,
        privacyVersion: finalPrivacyVersion,
        consentDate: DateTime.now(),
        ipAddress: ipAddress,
        deviceInfo: deviceInfoStr,
      );

      // Guardar en Firestore
      await _firestore.collection(_consentCollection).add(consent.toMap());
    } catch (e) {
      debugPrint('Error al registrar el consentimiento: $e');
      rethrow;
    }
  }

  /// Verifica si el usuario necesita aceptar nuevos términos
  Future<bool> needsToAcceptNewTerms(String userId) async {
    try {
      // Obtener el último consentimiento del usuario
      final querySnapshot = await _firestore
          .collection(_consentCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('consentDate', descending: true)
          .limit(1)
          .get();

      // Si no hay consentimientos previos, necesita aceptar
      if (querySnapshot.docs.isEmpty) {
        return true;
      }

      // Obtener el último consentimiento
      final lastConsent = LegalConsentModel.fromMap(
        querySnapshot.docs.first.data(),
        querySnapshot.docs.first.id,
      );

      // Obtener las versiones actuales
      final currentTermsVersion = await getCurrentDocumentVersion(
        LegalDocumentType.termsAndConditions,
      );
      final currentPrivacyVersion = await getCurrentDocumentVersion(
        LegalDocumentType.privacyPolicy,
      );

      // Verificar si las versiones son diferentes
      return lastConsent.termsVersion != currentTermsVersion ||
          lastConsent.privacyVersion != currentPrivacyVersion;
    } catch (e) {
      debugPrint('Error al verificar términos: $e');
      return true; // En caso de error, pedir aceptación por seguridad
    }
  }

  /// Obtiene información del dispositivo como string
  Future<String> _getDeviceInfo() async {
    try {
      // Obtener información de la app
      final packageInfo = await PackageInfo.fromPlatform();
      final appVersion = '${packageInfo.appName} ${packageInfo.version}';
      
      // Información específica según la plataforma
      String deviceDetails = '';
      
      if (defaultTargetPlatform == TargetPlatform.android) {
        final androidInfo = await _deviceInfo.androidInfo;
        deviceDetails = 'Android ${androidInfo.version.release}, '
            '${androidInfo.manufacturer} ${androidInfo.model}';
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        deviceDetails = '${iosInfo.systemName} ${iosInfo.systemVersion}, '
            '${iosInfo.model}';
      } else {
        deviceDetails = defaultTargetPlatform.toString();
      }
      
      return '$appVersion - $deviceDetails';
    } catch (e) {
      return 'Error al obtener información del dispositivo';
    }
  }

  /// Obtiene el historial de consentimientos de un usuario
  Future<List<LegalConsentModel>> getUserConsentHistory(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_consentCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('consentDate', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => LegalConsentModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      debugPrint('Error al obtener historial de consentimientos: $e');
      return [];
    }
  }

  /// Obtiene el historial de versiones de un tipo de documento
  Future<List<LegalDocumentModel>> getDocumentVersionHistory(
    LegalDocumentType type,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection(_legalDocumentsCollection)
          .where('documentType', isEqualTo: type.toString().split('.').last)
          .orderBy('publishDate', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => LegalDocumentModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      debugPrint('Error al obtener historial de versiones: $e');
      return [];
    }
  }

  /// Crea una nueva versión de un documento legal
  Future<void> createNewDocumentVersion({
    required LegalDocumentType type,
    required String version,
    required String title,
    required String content,
    String? documentUrl,
  }) async {
    try {
      // Desactivar versiones anteriores
      final batch = _firestore.batch();
      final previousDocs = await _firestore
          .collection(_legalDocumentsCollection)
          .where('documentType', isEqualTo: type.toString().split('.').last)
          .where('isActive', isEqualTo: true)
          .get();

      for (var doc in previousDocs.docs) {
        batch.update(doc.reference, {'isActive': false});
      }

      // Crear nuevo documento
      final newDoc = LegalDocumentModel(
        id: '',
        documentType: type,
        version: version,
        title: title,
        content: content,
        publishDate: DateTime.now(),
        isActive: true,
        documentUrl: documentUrl,
      );

      // Añadir el nuevo documento
      batch.set(
        _firestore.collection(_legalDocumentsCollection).doc(),
        newDoc.toMap(),
      );

      // Ejecutar las operaciones en batch
      await batch.commit();
    } catch (e) {
      debugPrint('Error al crear nueva versión del documento: $e');
      rethrow;
    }
  }
}
