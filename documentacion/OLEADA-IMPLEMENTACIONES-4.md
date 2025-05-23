# Oleada de Implementaciones 4: Autenticación por Teléfono y Mejoras de Diseño

## Fecha: 20 de abril de 2025 (actualizado)

## Resumen

En esta oleada de implementaciones se ha añadido la funcionalidad de autenticación mediante número de teléfono a la aplicación Agenda Glam. Esta característica permite a los usuarios registrarse e iniciar sesión utilizando su número de teléfono, además de la autenticación tradicional por correo electrónico. Adicionalmente, se ha realizado una importante refactorización del código para mejorar la estructura, el diseño y el rendimiento de las páginas de autenticación.

## Características implementadas

### 1. Refactorización y mejora de la estructura del código

- **Arquitectura modular**: Se ha reorganizado el código de las páginas de autenticación siguiendo un patrón modular consistente.
- **Componentes reutilizables**: Se han creado componentes específicos para encabezados, formularios y pies de página.
- **Optimización de rendimiento**: Se ha mejorado el uso de constructores `const` y eliminado código redundante.
- **Actualización de APIs obsoletas**: Se han reemplazado métodos obsoletos como `withOpacity` por alternativas recomendadas como `withAlpha`.

### 2. Mejoras en el diseño visual

- **Fondo animado unificado**: Implementación de un fondo animado común para todas las páginas de autenticación.
- **Estilo visual coherente**: Aplicación de una paleta de colores y estilos consistentes en todos los formularios.
- **Animaciones fluidas**: Mejora de las transiciones y animaciones para una experiencia más agradable.

### 3. Autenticación por número de teléfono

- **Registro de usuarios**: Los usuarios ahora pueden registrarse utilizando su número de teléfono.
- **Inicio de sesión**: Se ha modificado el formulario de inicio de sesión para aceptar tanto correo electrónico como número de teléfono.
- **Verificación por SMS**: Implementación de verificación mediante códigos SMS enviados al teléfono del usuario.
- **Recuperación de contraseña**: Los usuarios pueden restablecer su contraseña utilizando su número de teléfono.

### 2. Mejoras en la interfaz de usuario

- **Formulario de registro con pestañas**: Se ha actualizado el modal de registro para incluir pestañas que permiten al usuario elegir entre registro por correo electrónico o por teléfono.
- **Formulario de inicio de sesión adaptativo**: El formulario detecta automáticamente si el usuario está ingresando un correo electrónico o un número de teléfono.
- **Mensajes de error mejorados**: Se han implementado mensajes de error más descriptivos para facilitar la resolución de problemas durante el proceso de autenticación.

### 3. Mejoras técnicas

- **Integración con Firebase Authentication**: Se ha configurado Firebase para soportar la autenticación por teléfono.
- **Manejo de flujo reCAPTCHA**: Implementación de verificación mediante reCAPTCHA para mejorar la compatibilidad con emuladores y entornos de desarrollo.
- **Soporte para números de teléfono de prueba**: Se ha añadido la capacidad de utilizar números de teléfono de prueba durante el desarrollo.
- **Formato automático de números**: El sistema añade automáticamente el prefijo internacional (+598) si no está presente.

## Detalles técnicos

### Modificaciones en AuthService

```dart
// Verificación de número de teléfono
Future<void> verifyPhoneNumber({
  required String phoneNumber,
  required Function(String) onCodeSent,
  required Function(PhoneAuthCredential) onVerificationCompleted,
  required Function(String) onError,
  bool isForRegistration = false,
}) async {
  // Configuraciones para entorno de desarrollo
  if (kDebugMode) {
    // Forzar el uso de reCAPTCHA en lugar de Play Integrity
    _auth.setSettings(forceRecaptchaFlow: true);
    
    // Configurar números de teléfono de prueba
    if (phoneNumber == '+598123456789') {
      _auth.setSettings(phoneNumber: phoneNumber, smsCode: '123456');
    }
  }
  
  // Resto de la implementación...
}
```

### Modificaciones en AuthBloc

Se han añadido nuevos eventos y estados para manejar la autenticación por teléfono:

- `PhoneVerificationRequested`: Evento para solicitar la verificación de un número de teléfono.
- `VerifySmsCodeRequested`: Evento para verificar el código SMS recibido.
- `PhonePasswordResetRequested`: Evento para solicitar el restablecimiento de contraseña por teléfono.

### Configuración en Firebase

Para que la autenticación por teléfono funcione correctamente, se requiere:

1. **Plan Blaze de Firebase**: La autenticación por teléfono requiere el plan de pago por uso.
2. **Configuración de huellas digitales**: Tanto SHA-1 como SHA-256 deben estar configuradas en la consola de Firebase.
   ```
   SHA-1: 7C:51:A7:98:CB:16:32:3E:85:BC:6F:3C:B8:46:43:69:C2:B4:A9:6B
   SHA-256: E6:26:36:E3:F4:19:88:48:A1:E9:AF:7E:68:34:3E:1E:DC:52:04:91:33:F1:3F:4C:46:E4:77:25:93:9B:B5:2E
   ```
3. **Números de teléfono de prueba**: Para desarrollo, se pueden configurar números de teléfono de prueba en la consola de Firebase.

## Solución de problemas comunes

### Error "Invalid app info in play_integrity_token"

Este error ocurre cuando hay problemas con la verificación de integridad de Play Store. Soluciones:

1. Verificar que las huellas SHA-1 y SHA-256 estén correctamente configuradas en Firebase.
2. Forzar el flujo de reCAPTCHA mediante `_auth.setSettings(forceRecaptchaFlow: true)`.
3. Asegurarse de que la aplicación esté utilizando el plan Blaze de Firebase.

### SMS no recibidos

Si los usuarios no reciben los SMS de verificación:

1. Verificar que el número tenga el formato internacional correcto (+598XXXXXXXX).
2. Comprobar que no se haya excedido la cuota de SMS en Firebase.
3. Verificar que el país del usuario esté habilitado para recibir SMS de Firebase.



## Notas adicionales

- La autenticación por teléfono es menos segura que otros métodos, por lo que se recomienda ofrecer opciones adicionales de seguridad.
- Se debe informar a los usuarios sobre las tarifas estándar de SMS que podrían aplicarse.
- Para pruebas en desarrollo, se recomienda usar los números de teléfono de prueba configurados en Firebase.

## Detalles de la refactorización

### Estructura modular implementada

```
├── pages/
│   ├── auth/
│   │   ├── login_page.dart
│   │   ├── register_page.dart
│   │   ├── login/
│   │   │   ├── login_widgets.dart (barrel file)
│   │   │   ├── login_controller.dart
│   │   │   ├── login_header.dart
│   │   │   ├── login_form.dart
│   │   │   ├── login_footer.dart
│   │   │   └── social_login_buttons.dart
│   │   └── register/
│   │       ├── register_widgets.dart (barrel file)
│   │       ├── register_controller.dart
│   │       ├── register_header.dart
│   │       ├── register_form.dart
│   │       ├── register_footer.dart
│   │       └── social_register_buttons.dart
│   └── password_reset/
│       ├── password_reset_widgets.dart (barrel file)
│       ├── password_reset_controller.dart
│       ├── password_reset_header.dart
│       ├── reset_form.dart
│       ├── password_reset_footer.dart
│       └── ...
└── widgets/
    └── common/
        └── animated_background.dart
```

### Beneficios de la nueva estructura

- **Mejor mantenibilidad**: Cada componente tiene una responsabilidad única y clara.
- **Facilidad para pruebas**: La separación de lógica facilita la implementación de pruebas unitarias.
- **Reutilización de código**: Los componentes pueden ser reutilizados en diferentes partes de la aplicación.
- **Escalabilidad**: Facilita la adición de nuevas funcionalidades sin afectar el código existente.
