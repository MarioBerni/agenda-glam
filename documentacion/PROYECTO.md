# Agenda Glam - Informe del Proyecto
Fecha: 12 de abril de 2025

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
│   ├── theme/             # Configuración del tema
│   └── utils/             # Funciones de utilidad
├── data/                  # Capa de datos
│   ├── models/            # Modelos de datos
│   ├── repositories/      # Implementaciones de repositorios
│   └── services/          # Servicios externos (Firebase, etc.)
├── domain/                # Lógica de negocio
│   ├── entities/          # Entidades de dominio
│   ├── repositories/      # Interfaces de repositorios
│   └── usecases/          # Casos de uso
├── presentation/          # Capa de presentación
│   ├── blocs/             # BLoCs para gestión de estado
│   ├── pages/             # Páginas de la aplicación
│   └── widgets/           # Widgets reutilizables
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

- El entorno de desarrollo está configurado para Flutter en Windows.
- Se han instalado Android Studio, el SDK de Flutter y las herramientas necesarias.
- Se ha creado un emulador de Android (Pixel 7 con Android 14) para pruebas.
- El equipo está listo para iniciar el desarrollo del MVP (Producto Mínimo Viable).

### Implementaciones Realizadas

El desarrollo del proyecto se ha organizado en oleadas de implementación, cada una enfocada en aspectos específicos de la aplicación. Hasta la fecha, se han completado las siguientes oleadas:

1. **Oleada 1**: Estructura inicial del proyecto, configuración de Firebase y autenticación básica.
2. **Oleada 2**: Optimización y modularización del código, implementación completa de autenticación con Firebase.
3. **Oleada 3**: Mejora de la experiencia post-autenticación, integración con Firestore y manejo de perfiles de usuario.
4. **Oleada 4**: Implementación de autenticación por teléfono y mejoras de diseño visual.
5. **Oleada 5**: Mejoras en la interfaz de usuario para autenticación por teléfono y correcciones de código.
6. **Oleada 6**: Sistema de consentimiento legal, versionado de documentos y páginas dedicadas para términos y condiciones.

## Plan de Pruebas

### Pruebas Unitarias
- Validación de modelos y lógica de negocio
- Verificación de casos de uso y repositorios

### Pruebas de Integración
- Interacción entre componentes
- Flujos de datos entre capas

### Pruebas de UI
- Validación de interfaces y experiencia de usuario
- Pruebas de responsividad en diferentes dispositivos

### Pruebas de Aceptación
- Validación de flujos completos de usuario
- Verificación de requisitos funcionales

## Documentación de Oleadas de Implementación

### Propósito y Estructura

Los archivos de oleadas de implementación (`OLEADA-IMPLEMENTACIONES-X.md`) tienen como objetivo documentar de manera detallada y estructurada las funcionalidades que ya han sido implementadas y confirmadas en el proyecto. Estos documentos:

- **Registran el progreso real**: Documentan exclusivamente las implementaciones completadas y verificadas, no las planificadas o pendientes.
- **Sirven como referencia técnica**: Proporcionan detalles sobre la arquitectura, patrones de diseño y decisiones técnicas tomadas.
- **Facilitan la incorporación de nuevos desarrolladores**: Ofrecen una visión clara de cómo está construido el sistema.
- **Ayudan en el mantenimiento**: Permiten entender rápidamente qué componentes existen y cómo interactúan.

### Contenido de los Archivos de Oleadas

Cada archivo de oleada típicamente incluye:

1. **Resumen general**: Visión general de lo implementado en esa oleada.
2. **Funcionalidades implementadas**: Lista detallada de características completadas.
3. **Detalles técnicos**: Información sobre la implementación, patrones utilizados y componentes creados.
4. **Archivos creados/modificados**: Registro de los cambios realizados en el código.
5. **Problemas encontrados y soluciones**: Documentación de desafíos técnicos y cómo fueron resueltos.

### Beneficios de la Documentación por Oleadas

- **Trazabilidad**: Permite seguir la evolución del proyecto a lo largo del tiempo.
- **Transparencia**: Proporciona una visión clara de lo que realmente está implementado.
- **Calidad**: Ayuda a mantener estándares de documentación consistentes.
- **Comunicación**: Facilita la comunicación entre miembros del equipo y stakeholders.

## Conclusión

Agenda Glam tiene el potencial de transformar la gestión de servicios estéticos masculinos en Uruguay, ofreciendo una solución que simplifica la experiencia del cliente y potencia la eficiencia de los proveedores. Con un diseño intuitivo, un stack tecnológico escalable y un enfoque en la seguridad, esta plataforma está destinada a convertirse en un referente en el mercado.

El proyecto cuenta con una base sólida en términos de concepto, planificación y tecnología seleccionada. La implementación por oleadas ha permitido un desarrollo estructurado y bien documentado, facilitando la gestión del proyecto y asegurando la calidad del producto final.

*Documentación actualizada: 20 de abril de 2025*