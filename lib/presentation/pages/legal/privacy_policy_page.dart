import 'package:flutter/material.dart';

/// Página que muestra la política de privacidad de la aplicación
class PrivacyPolicyPage extends StatelessWidget {
  /// Constructor
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Política de Privacidad'),
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
                  'Política de Privacidad',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildParagraph(
                  'En Agenda Glam, valoramos y respetamos su privacidad. Esta Política de Privacidad describe cómo recopilamos, utilizamos, procesamos y protegemos su información personal cuando utiliza nuestra aplicación móvil.',
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('1. Información que Recopilamos'),
                _buildParagraph(
                  'Podemos recopilar los siguientes tipos de información:',
                ),
                _buildBulletPoint(
                  'Información de registro: nombre, dirección de correo electrónico, número de teléfono y contraseña.',
                ),
                _buildBulletPoint(
                  'Información de perfil: fotografía, preferencias y otra información que decida proporcionar.',
                ),
                _buildBulletPoint(
                  'Información de uso: datos sobre cómo interactúa con nuestra aplicación, incluyendo historial de reservas, búsquedas y preferencias.',
                ),
                _buildBulletPoint(
                  'Información del dispositivo: modelo, sistema operativo, identificadores únicos y datos de red móvil.',
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('2. Cómo Utilizamos su Información'),
                _buildParagraph(
                  'Utilizamos la información recopilada para:',
                ),
                _buildBulletPoint(
                  'Proporcionar, mantener y mejorar nuestros servicios.',
                ),
                _buildBulletPoint(
                  'Procesar y gestionar sus reservas y pagos.',
                ),
                _buildBulletPoint(
                  'Comunicarnos con usted sobre actualizaciones, promociones y eventos.',
                ),
                _buildBulletPoint(
                  'Personalizar su experiencia y ofrecerle recomendaciones.',
                ),
                _buildBulletPoint(
                  'Detectar, prevenir y abordar problemas técnicos y de seguridad.',
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('3. Compartir de Información'),
                _buildParagraph(
                  'Podemos compartir su información personal con:',
                ),
                _buildBulletPoint(
                  'Proveedores de servicios: compartimos información con los proveedores de servicios que usted selecciona para reservar citas.',
                ),
                _buildBulletPoint(
                  'Proveedores de servicios técnicos: utilizamos terceros para servicios como procesamiento de pagos, análisis de datos y mensajería.',
                ),
                _buildBulletPoint(
                  'Requisitos legales: podemos divulgar información si es requerido por ley o en respuesta a solicitudes legales válidas.',
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('4. Seguridad de Datos'),
                _buildParagraph(
                  'Implementamos medidas de seguridad técnicas y organizativas para proteger su información personal contra acceso no autorizado, pérdida o alteración. Sin embargo, ningún sistema es completamente seguro, y no podemos garantizar la seguridad absoluta de su información.',
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('5. Sus Derechos'),
                _buildParagraph(
                  'Dependiendo de su ubicación, puede tener ciertos derechos relacionados con su información personal, incluyendo:',
                ),
                _buildBulletPoint(
                  'Acceder a su información personal.',
                ),
                _buildBulletPoint(
                  'Corregir información inexacta o incompleta.',
                ),
                _buildBulletPoint(
                  'Eliminar su información personal.',
                ),
                _buildBulletPoint(
                  'Oponerse o restringir el procesamiento de su información.',
                ),
                _buildBulletPoint(
                  'Solicitar la portabilidad de sus datos.',
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('6. Retención de Datos'),
                _buildParagraph(
                  'Conservamos su información personal mientras mantenga una cuenta activa o según sea necesario para proporcionarle servicios. También podemos retener y utilizar su información según sea necesario para cumplir con nuestras obligaciones legales, resolver disputas y hacer cumplir nuestros acuerdos.',
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('7. Cambios a esta Política'),
                _buildParagraph(
                  'Podemos actualizar nuestra Política de Privacidad periódicamente. Le notificaremos cualquier cambio publicando la nueva Política de Privacidad en esta página y actualizando la fecha de "última actualización".',
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('8. Contacto'),
                _buildParagraph(
                  'Si tiene preguntas sobre esta Política de Privacidad, contáctenos en privacidad@agendaglam.com.',
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
