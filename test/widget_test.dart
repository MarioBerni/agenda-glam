// Prueba básica para verificar que la página de bienvenida se carga correctamente

import 'package:flutter_test/flutter_test.dart';

import 'package:agenda_glam/main.dart';

void main() {
  testWidgets('Verificar que la página de bienvenida se carga correctamente', (
    WidgetTester tester,
  ) async {
    // Construir nuestra app y generar un frame
    await tester.pumpWidget(const MyApp());

    // Verificar que la página de bienvenida se muestra correctamente
    // Buscamos elementos clave que deberían estar presentes en la página de bienvenida
    expect(find.text('QUIERO AGENDARME'), findsOneWidget);
    expect(find.text('INICIAR SESIÓN'), findsOneWidget);

    // Verificar que se muestra la sección de beneficios
    expect(find.text('Por qué elegir Agenda Glam'), findsOneWidget);

    // Verificar que se muestra la sección de socios
    expect(find.text('Nuestros Socios'), findsOneWidget);
  });
}
