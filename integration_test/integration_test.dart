import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:primerproyectomovil/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('flujo de inscripción y cancelación de evento', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Buscar y tocar el primer evento disponible
    final firstEvent = find.byType(GestureDetector).first;
    expect(firstEvent, findsWidgets);
    await tester.tap(firstEvent);
    await tester.pumpAndSettle();

    // Buscar el botón para inscribirse
    final reservarButton = find.text('RESERVAR ENTRADA');
    expect(reservarButton, findsOneWidget);
    await tester.tap(reservarButton);
    await tester.pumpAndSettle();

    // Verificar que el botón cambió a "CANCELAR REGISTRO"
    final cancelarButton = find.text('CANCELAR REGISTRO');
    expect(cancelarButton, findsOneWidget);

    // Tocar el botón de cancelar
    await tester.tap(cancelarButton);
    await tester.pumpAndSettle();

    // Verificar que vuelve a "RESERVAR ENTRADA"
    expect(find.text('RESERVAR ENTRADA'), findsOneWidget);
  });
}
