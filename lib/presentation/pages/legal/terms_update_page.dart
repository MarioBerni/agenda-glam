import 'package:flutter/material.dart';
import '../../../data/models/legal_document_model.dart';
import '../../../data/repositories/legal_repository.dart';

/// Página para mostrar y solicitar aceptación de términos actualizados
class TermsUpdatePage extends StatefulWidget {
  /// ID del usuario
  final String userId;

  /// Constructor
  const TermsUpdatePage({
    super.key,
    required this.userId,
  });

  @override
  State<TermsUpdatePage> createState() => _TermsUpdatePageState();
}

class _TermsUpdatePageState extends State<TermsUpdatePage> {
  final LegalRepository _legalRepository = LegalRepository();
  bool _isLoading = true;
  bool _hasAccepted = false;
  bool _isSubmitting = false;
  
  LegalDocumentModel? _termsDocument;
  LegalDocumentModel? _privacyDocument;
  
  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }
  
  /// Carga los documentos legales actuales
  Future<void> _loadDocuments() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final termsDoc = await _legalRepository.getActiveDocument(
        LegalDocumentType.termsAndConditions,
      );
      
      final privacyDoc = await _legalRepository.getActiveDocument(
        LegalDocumentType.privacyPolicy,
      );
      
      setState(() {
        _termsDocument = termsDoc;
        _privacyDocument = privacyDoc;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar los documentos: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  /// Registra la aceptación de los nuevos términos
  Future<void> _acceptTerms() async {
    if (_hasAccepted) {
      setState(() {
        _isSubmitting = true;
      });
      
      try {
        await _legalRepository.registerConsent(
          userId: widget.userId,
        );
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Has aceptado los nuevos términos y condiciones'),
              backgroundColor: Colors.green,
            ),
          );
          
          // Volver a la pantalla anterior
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al registrar el consentimiento: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes aceptar los términos para continuar'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Términos Actualizados'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF1A1A1A)],
          ),
        ),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.amber,
                ),
              )
            : SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Hemos actualizado nuestros términos',
                              style: TextStyle(
                                color: Colors.amber,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Para continuar usando Agenda Glam, debes aceptar nuestros términos y condiciones actualizados y nuestra política de privacidad.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Términos y condiciones
                            if (_termsDocument != null) ...[
                              _buildSectionTitle('Términos y Condiciones'),
                              _buildSectionSubtitle(
                                'Versión ${_termsDocument!.version} - ${_formatDate(_termsDocument!.publishDate)}',
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(13),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _termsDocument!.content,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                            
                            // Política de privacidad
                            if (_privacyDocument != null) ...[
                              _buildSectionTitle('Política de Privacidad'),
                              _buildSectionSubtitle(
                                'Versión ${_privacyDocument!.version} - ${_formatDate(_privacyDocument!.publishDate)}',
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(13),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _privacyDocument!.content,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    
                    // Sección de aceptación
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(204),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(128),
                            blurRadius: 10,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _hasAccepted,
                                onChanged: (value) {
                                  setState(() {
                                    _hasAccepted = value ?? false;
                                  });
                                },
                                activeColor: Colors.amber,
                                checkColor: Colors.black,
                              ),
                              const Expanded(
                                child: Text(
                                  'He leído y acepto los términos y condiciones y la política de privacidad actualizados',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    // Volver sin aceptar
                                    Navigator.of(context).pop(false);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    side: const BorderSide(color: Colors.white54),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                  ),
                                  child: const Text('No aceptar'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _isSubmitting ? null : _acceptTerms,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.amber,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                  ),
                                  child: _isSubmitting
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.black,
                                          ),
                                        )
                                      : const Text('Aceptar'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Widget _buildSectionSubtitle(String subtitle) {
    return Text(
      subtitle,
      style: const TextStyle(
        color: Colors.amber,
        fontSize: 14,
        fontStyle: FontStyle.italic,
      ),
    );
  }
  
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
