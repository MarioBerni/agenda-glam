/// Archivo puente para exportar las clases y enumeraciones de autenticación
/// desde la subcarpeta auth para mantener compatibilidad con las importaciones existentes.
library auth_service;

export 'auth/auth_service.dart';
export 'auth/auth_models.dart';
export 'auth/auth_exception_handler.dart';
export 'auth/auth_service_interface.dart';
export 'auth/email_auth_service.dart';
export 'auth/google_auth_service.dart';
export 'auth/phone_auth_service.dart';
