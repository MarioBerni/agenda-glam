import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/legal_repository_interface.dart';
import '../../presentation/pages/legal/terms_update_page.dart';

/// Servicio para verificar si el usuario necesita aceptar términos actualizados
@injectable
class TermsVerificationService {
  final LegalRepositoryInterface _legalRepository;
  final FirebaseAuth _auth;
  
  TermsVerificationService(this._legalRepository, this._auth);

  /// Verifica si hay términos actualizados que el usuario necesita aceptar
  Future<void> checkForUpdatedTerms(BuildContext context) async {
    try {
      // Verificar si hay un usuario autenticado
      final user = _auth.currentUser;
      if (user == null) {
        return; // No hay usuario autenticado, no es necesario verificar
      }

      // Verificar si el usuario necesita aceptar nuevos términos
      final needsToAccept = !(await _legalRepository.hasAcceptedLatestTerms(user.uid));
      
      if (needsToAccept && context.mounted) {
        // Mostrar la página de términos actualizados
        final result = await Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (context) => TermsUpdatePage(userId: user.uid),
          ),
        );
        
        // Si el usuario no aceptó los términos, cerrar sesión
        if (result != true && context.mounted) {
          await _auth.signOut();
          
          // Mostrar mensaje explicando por qué se cerró la sesión
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Has cerrado sesión porque no aceptaste los nuevos términos y condiciones.',
                ),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 5),
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Error al verificar términos actualizados: $e');
      // No interrumpir el flujo de la aplicación en caso de error
    }
  }
}
