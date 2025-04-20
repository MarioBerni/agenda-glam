# Oleada de Implementaciones 6: Sistema de Consentimiento Legal

Fecha: 20 de abril de 2025

## Resumen

En esta oleada se ha implementado un sistema completo para gestionar el consentimiento legal de los usuarios en la aplicación Agenda Glam. El sistema permite registrar la aceptación de términos y condiciones y política de privacidad durante el registro, así como notificar y solicitar aceptación de nuevas versiones cuando se actualicen estos documentos.

## Funcionalidades Implementadas

### 1. Registro de Consentimiento

- Se ha creado un modelo `LegalConsentModel` para almacenar información detallada sobre el consentimiento del usuario:
  - Versión de los términos y condiciones aceptados
  - Versión de la política de privacidad aceptada
  - Fecha y hora del consentimiento
  - Información del dispositivo desde el que se dio el consentimiento
  - Dirección IP (opcional)

- Se ha modificado el proceso de registro para incluir la aceptación obligatoria de términos y condiciones:
  - Checkbox para aceptar términos y condiciones
  - Validación para asegurar que los términos sean aceptados antes de completar el registro
  - Almacenamiento del consentimiento en Firestore

### 2. Versionado de Documentos Legales

- Se ha creado un modelo `LegalDocumentModel` para gestionar diferentes versiones de documentos legales:
  - Cada documento tiene un ID, tipo, versión y estado (activo/inactivo)
  - Solo una versión de cada documento puede estar activa a la vez
  - Se mantiene un historial de todas las versiones anteriores

- Se ha implementado un servicio `LegalService` para gestionar los documentos legales:
  - Obtener la versión actual de un documento
  - Crear nuevas versiones de documentos
  - Desactivar versiones anteriores automáticamente

### 3. Verificación de Nuevos Términos

- Se ha implementado un sistema para verificar si hay nuevas versiones de los documentos legales:
  - Servicio `TermsVerificationService` que verifica al iniciar la aplicación
  - Comparación de la última versión aceptada por el usuario con la versión actual
  - Redirección a una página de actualización de términos si es necesario

- Se ha creado una página `TermsUpdatePage` para solicitar la aceptación de nuevos términos:
  - Muestra los nuevos términos y condiciones y política de privacidad
  - Requiere aceptación explícita del usuario
  - Cierra la sesión si el usuario no acepta los nuevos términos

### 4. Páginas Dedicadas para Documentos Legales

- Se han creado páginas específicas para mostrar los documentos legales:
  - `TermsAndConditionsPage`: Página de términos y condiciones
  - `PrivacyPolicyPage`: Página de política de privacidad

- Se han implementado enlaces interactivos en el formulario de registro para acceder a estos documentos antes de aceptarlos

## Archivos Creados/Modificados

### Nuevos Modelos y Servicios

- `data/models/legal_consent_model.dart`: Modelo para almacenar consentimientos
- `data/models/legal_document_model.dart`: Modelo para versiones de documentos
- `data/repositories/legal_repository.dart`: Repositorio para gestionar documentos legales
- `data/services/legal_service.dart`: Servicio para operaciones con documentos legales
- `data/services/terms_verification_service.dart`: Servicio para verificar términos actualizados

### Nuevas Páginas

- `presentation/pages/legal/terms_conditions_page.dart`: Página de términos y condiciones
- `presentation/pages/legal/privacy_policy_page.dart`: Página de política de privacidad
- `presentation/pages/legal/terms_update_page.dart`: Página para aceptar términos actualizados

### Modificaciones

- `presentation/blocs/auth/auth_event.dart`: Actualizado para incluir parámetro de consentimiento
- `presentation/blocs/auth/auth_bloc.dart`: Modificado para registrar el consentimiento
- `presentation/pages/auth/register/register_controller.dart`: Actualizado para pasar parámetros de consentimiento
- `presentation/pages/auth/register/register_form.dart`: Mejorado con enlaces a documentos legales
- `presentation/pages/auth/register_page.dart`: Actualizado para pasar el estado de aceptación
- `presentation/widgets/auth/register_form.dart`: Corregido para incluir el parámetro hasAcceptedTerms

## Correcciones de Código

- Eliminación del campo `_auth` no utilizado en `legal_service.dart`
- Reemplazo de `print` por `debugPrint` en código de producción
- Corrección del uso de métodos deprecados `withOpacity` por `withAlpha`
- Adición del parámetro requerido `hasAcceptedTerms` en el evento `SignUpRequested`

## Consideraciones Legales

- **Consentimiento explícito**: El sistema asegura que el consentimiento sea claro y explícito, requiriendo una acción afirmativa del usuario.
- **Accesibilidad**: Los documentos son fácilmente accesibles antes de la aceptación mediante enlaces interactivos.
- **Registro**: Se guarda la fecha, hora y versión de los documentos aceptados por cada usuario.
- **Versiones**: Se mantiene un registro de qué versión de los documentos aceptó cada usuario.

## Próximos Pasos

- Implementar un panel de administración para gestionar versiones de documentos legales
- Añadir estadísticas sobre aceptación de términos
- Mejorar el diseño de las páginas de documentos legales con elementos visuales adicionales
- Implementar soporte para múltiples idiomas en los documentos legales