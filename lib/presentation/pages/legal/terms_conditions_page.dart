import 'package:flutter/material.dart';

/// Página que muestra los términos y condiciones de la aplicación
class TermsAndConditionsPage extends StatelessWidget {
  /// Constructor
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Términos y Condiciones'),
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Términos y Condiciones de Uso',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('1. Aceptación de Términos'),
                _buildParagraph(
                  'Al acceder y utilizar la aplicación Agenda Glam, usted acepta estar legalmente obligado por estos Términos y Condiciones. Si no está de acuerdo con alguno de estos términos, no debe utilizar la aplicación.',
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('2. Descripción del Servicio'),
                _buildParagraph(
                  'Agenda Glam es una plataforma que permite a los usuarios buscar, reservar y gestionar citas para servicios estéticos masculinos en Uruguay. La aplicación facilita la conexión entre proveedores de servicios y clientes.',
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('3. Registro de Cuenta'),
                _buildParagraph(
                  'Para utilizar ciertas funcionalidades de la aplicación, deberá registrarse y crear una cuenta. Usted es responsable de mantener la confidencialidad de su información de cuenta y de todas las actividades que ocurran bajo su cuenta.',
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('4. Responsabilidades del Usuario'),
                _buildParagraph(
                  'Al utilizar Agenda Glam, usted se compromete a:',
                ),
                _buildBulletPoint(
                  'Proporcionar información precisa y actualizada durante el proceso de registro.',
                ),
                _buildBulletPoint(
                  'No utilizar la aplicación para fines ilegales o no autorizados.',
                ),
                _buildBulletPoint(
                  'Respetar las citas programadas o cancelarlas con la antelación establecida.',
                ),
                _buildBulletPoint(
                  'No intentar acceder a áreas restringidas de la aplicación.',
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('5. Política de Cancelación'),
                _buildParagraph(
                  'Las cancelaciones de citas deben realizarse con al menos 24 horas de anticipación. Las cancelaciones tardías o la ausencia a citas programadas pueden resultar en cargos o restricciones en el uso futuro de la aplicación.',
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('6. Propiedad Intelectual'),
                _buildParagraph(
                  'Todo el contenido presente en Agenda Glam, incluyendo pero no limitado a textos, gráficos, logotipos, iconos, imágenes, clips de audio, descargas digitales y compilaciones de datos, es propiedad de Agenda Glam o sus proveedores de contenido y está protegido por las leyes de propiedad intelectual.',
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('7. Limitación de Responsabilidad'),
                _buildParagraph(
                  'Agenda Glam no será responsable por daños directos, indirectos, incidentales, especiales, consecuentes o punitivos, incluidos pero no limitados a, daños por pérdida de beneficios, buena voluntad, uso, datos u otras pérdidas intangibles.',
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('8. Modificaciones de los Términos'),
                _buildParagraph(
                  'Agenda Glam se reserva el derecho de modificar estos Términos y Condiciones en cualquier momento. Las modificaciones entrarán en vigor inmediatamente después de su publicación en la aplicación. El uso continuado de la aplicación después de dichas modificaciones constituirá su consentimiento a tales cambios.',
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('9. Ley Aplicable'),
                _buildParagraph(
                  'Estos Términos y Condiciones se regirán e interpretarán de acuerdo con las leyes de Uruguay, sin tener en cuenta sus disposiciones sobre conflictos de leyes.',
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('10. Contacto'),
                _buildParagraph(
                  'Si tiene alguna pregunta sobre estos Términos y Condiciones, puede contactarnos a través de soporte@agendaglam.com.',
                ),
                const SizedBox(height: 16),
                _buildParagraph(
                  'Última actualización: 20 de abril de 2025',
                  isBold: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
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

  Widget _buildParagraph(String text, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white70,
          fontSize: 16,
          height: 1.5,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '•',
            style: TextStyle(
              color: Colors.amber,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
