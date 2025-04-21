# Agenda Glam - Informe del Proyecto
Fecha: 21 de abril de 2025

## Introducción a Agenda Glam

Agenda Glam es una plataforma innovadora diseñada para transformar la gestión de servicios estéticos orientados al público masculino en Uruguay. Nuestra misión es simplificar el proceso de reserva para los clientes mientras ofrecemos herramientas eficientes para que los proveedores administren sus negocios. La aplicación estará disponible en múltiples plataformas (web, móvil y escritorio) y proporcionará una experiencia de usuario intuitiva, atractiva y alineada con un diseño estético masculino.

La plataforma aborda una necesidad en el mercado uruguayo al ofrecer una solución integral que beneficia a dos grupos clave:

- **Clientes**: Facilitar la búsqueda y reserva de servicios estéticos.
- **Proveedores**: Optimizar la gestión de sus negocios con herramientas avanzadas.

Los pilares fundamentales de Agenda Glam son:

- **Gestión integral**: Sistema completo para reservas, seguimiento, promociones y análisis estadístico.
- **Escalabilidad**: Arquitectura preparada para integrar pagos en línea, sincronización con calendarios e inteligencia artificial.
- **Experiencia simplificada**: Diseño intuitivo y accesible para usuarios de todas las edades.
- **Enfoque estético masculino**: Estilo sofisticado con una paleta de colores y elementos visuales atractivos para el público objetivo.

El modelo de negocio se sustentará en suscripciones para proveedores, comisiones por reserva, servicios premium y publicidad destacada, asegurando diversas fuentes de ingresos.

## Funcionalidades Principales

### Gestión de Reservas

#### Proceso de Reserva:
- Búsqueda y selección de locales.
- Elección de servicios individuales o paquetes.
- Opciones para reprogramar o cancelar reservas.

#### Notificaciones:
- Confirmaciones, recordatorios y alertas de cambios vía push o email.

### Perfil del Negocio

#### Información pública:
- Descripción, servicios, horarios, ubicación, imágenes y reseñas.
- Gestión de promociones y cupones.

#### Diseño:
- Estilo minimalista con personalización limitada para mantener uniformidad.

### Dashboards y Gestión Interna

#### Paneles de Control:
- **Dueños**: Promociones, estadísticas y administración de agendas.
- **Empleados**: Agenda diaria y gestión de reservas asignadas.
- **Administradores**: Reportes y análisis global de la plataforma.

## Usuarios y Roles

### Dueños de locales y empleados:
- Dashboards diferenciados para gestión y administración.
- Herramientas para promociones, agendas y estadísticas.
- Control de disponibilidad y servicios.

### Clientes:
- Acceso a una página pública para buscar locales y servicios.
- Registro para gestionar reservas e historial.
- Visualización de información detallada de proveedores.

### Administradores:
- Panel central para supervisión, reportes y análisis de uso.

## Requerimientos Funcionales y No Funcionales

### Requerimientos Funcionales

1. Registro e inicio de sesión con roles diferenciados.
2. Creación y edición de perfiles de negocio.
3. Sistema de búsqueda y filtrado por ubicación, tipo de servicio, precio, etc.
4. Calendario en tiempo real con disponibilidad de horarios.
5. Sistema de reservas con selección de servicios, fecha y hora.
6. Notificaciones automáticas para confirmaciones y recordatorios.
7. Panel de administración con estadísticas y herramientas de gestión.
8. Sistema de reseñas y calificaciones.
9. Gestión de promociones y descuentos.
10. Generación de reportes sobre uso, tendencias y rendimiento.

### Requerimientos No Funcionales

1. Interfaz intuitiva y visualmente atractiva con enfoque masculino.
2. Diseño responsivo para móvil, tablet y escritorio.
3. Tiempos de respuesta rápidos (menos de 2 segundos en operaciones clave).
4. Alta disponibilidad (99.9% uptime).
5. Seguridad robusta para datos personales y transacciones.
6. Escalabilidad para soportar crecimiento en usuarios y reservas.
7. Accesibilidad conforme a estándares WCAG.
8. Soporte inicial en español, con posibilidad de agregar más idiomas.

## Flujos de Usuario Principales

### Para Clientes

#### Búsqueda y Reserva:
1. Buscar servicios por ubicación o categoría.
2. Filtrar resultados según preferencias.
3. Seleccionar local, revisar perfil y elegir servicios/horarios.
4. Confirmar reserva y recibir notificación.

#### Gestión de Citas:
1. Ver historial y citas próximas en el perfil.
2. Reprogramar o cancelar citas.
3. Recibir recordatorios y calificar servicios post-atención.

### Para Proveedores

#### Gestión de Agenda:
1. Configurar horarios de disponibilidad.
2. Ver reservas diarias, semanales o mensuales.
3. Confirmar, reprogramar o cancelar citas.
4. Recibir alertas de nuevas reservas.

#### Administración de Negocio:
1. Actualizar perfil y catálogo de servicios.
2. Crear promociones y descuentos.
3. Analizar estadísticas y reportes.
4. Responder a reseñas de clientes.

## Stack Tecnológico

### Frontend: Flutter

**Razón de la elección:**
- Desarrollo nativo para móvil, web y escritorio desde un solo código base.
- Interfaces fluidas y atractivas gracias a Dart y el motor gráfico Skia.
- Ideal para un diseño sofisticado orientado al público masculino.
- Escalabilidad y facilidad para integrar nuevas funcionalidades.

### Backend: Firebase

**Razón de la elección:**
- Plataforma BaaS con autenticación, base de datos en tiempo real, notificaciones y análisis integrados.
- Integración sencilla con Flutter.
- Escalabilidad automática para manejar picos de uso.
- Seguridad robusta para datos sensibles.

## Arquitectura Propuesta

### Estructura del Proyecto

```
lib/
├── core/                  # Funcionalidades centrales y utilidades
│   ├── constants/         # Constantes de la aplicación
│   ├── di/                # Inyección de dependencias
│   │   ├── injection.dart # Configuración de Get_It
│   │   └── modules/       # Módulos de inyección
│   ├── enums/             # Enumeraciones globales
│   ├── theme/             # Configuración del tema
│   └── utils/             # Funciones de utilidad
├── data/                  # Capa de datos
│   ├── models/            # Modelos de datos
│   ├── repositories/      # Implementaciones de repositorios
│   └── services/          # Servicios externos (Firebase, etc.)
│       └── auth/          # Servicios de autenticación
├── domain/                # Lógica de negocio
│   ├── entities/          # Entidades de dominio
│   ├── repositories/      # Interfaces de repositorios
│   └── usecases/          # Casos de uso
├── presentation/          # Capa de presentación
│   ├── blocs/             # BLoCs para gestión de estado
│   │   └── auth/          # BLoC de autenticación
│   ├── pages/             # Páginas de la aplicación
│   │   ├── auth/          # Páginas de autenticación
│   │   │   ├── login/     # Componentes de login
│   │   │   └── register/  # Componentes de registro
│   │   ├── legal/         # Páginas de documentos legales
│   │   └── password_reset/# Páginas de recuperación de contraseña
│   └── widgets/           # Widgets reutilizables
│       ├── auth/          # Widgets de autenticación
│       ├── common/        # Widgets comunes
│       ├── home/          # Widgets de la página principal
│       └── welcome/       # Widgets de bienvenida
└── main.dart              # Punto de entrada de la aplicación
```

### Patrón de Gestión de Estado

Se recomienda utilizar el patrón BLoC (Business Logic Component) para la gestión de estado, ya que:
- Separa la lógica de negocio de la UI
- Facilita las pruebas unitarias
- Permite un flujo de datos unidireccional y predecible
- Es recomendado oficialmente por Flutter para aplicaciones de complejidad media-alta

## Progreso del Proyecto

### Estado Actual

- El proyecto se encuentra en fase de desarrollo activo con siete oleadas de implementación completadas.
- Se ha implementado un sistema completo de autenticación con múltiples métodos (email, Google, teléfono).
- Se ha desarrollado un sistema de consentimiento legal con versionado de documentos.
- Se ha implementado un sistema de inyección de dependencias utilizando get_it y injectable.
- La arquitectura sigue los principios de Clean Architecture con separación clara de responsabilidades.
- El proyecto utiliza el patrón BLoC para la gestión de estado, siguiendo las mejores prácticas.


## Plan de Pruebas

### Pruebas Unitarias
- Validación de modelos y lógica de negocio
- Verificación de casos de uso y repositorios
- Pruebas de servicios de autenticación
- Pruebas de BLoCs con estados y eventos

### Pruebas de Integración
- Interacción entre componentes
- Flujos de datos entre capas
- Integración con Firebase

### Pruebas de UI
- Validación de interfaces y experiencia de usuario
- Pruebas de responsividad en diferentes dispositivos
- Pruebas de accesibilidad

### Pruebas de Aceptación
- Validación de flujos completos de usuario
- Verificación de requisitos funcionales
- Pruebas de rendimiento en condiciones reales

## Conclusión

Agenda Glam tiene el potencial de transformar la gestión de servicios estéticos masculinos en Uruguay, ofreciendo una solución que simplifica la experiencia del cliente y potencia la eficiencia de los proveedores. Con un diseño intuitivo, un stack tecnológico escalable y un enfoque en la seguridad, esta plataforma está destinada a convertirse en un referente en el mercado.

El proyecto cuenta con una base sólida en términos de concepto, planificación y tecnología seleccionada. La implementación por oleadas ha permitido un desarrollo estructurado y bien documentado, facilitando la gestión del proyecto y asegurando la calidad del producto final.

*Documentación actualizada: 20 de abril de 2025*