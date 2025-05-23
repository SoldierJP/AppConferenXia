import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:primerproyectomovil/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Filtrar eventos con "Tech" en el nombre', (
    WidgetTester tester,
  ) async {
    app.main();
    await tester.pumpAndSettle(); // Espera a que cargue la app

    // Encuentra la SearchBar (usamos el hintText como clave)
    final searchField = find.byWidgetPredicate(
      (widget) =>
          widget is TextField &&
          widget.decoration?.hintText == 'Buscar eventos',
    );

    // Asegúrate de que esté presente
    expect(searchField, findsOneWidget);

    // Escribir "Tech" en la barra de búsqueda y enviar Enter
    await tester.enterText(searchField, 'Tech');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle(); // Esperar filtrado

    // Verifica que se muestra el evento filtrado
    expect(find.textContaining('Tech'), findsWidgets);

    // Verifica que eventos no relacionados desaparezcan
    expect(find.text('Music Fest'), findsNothing);
  });
}
