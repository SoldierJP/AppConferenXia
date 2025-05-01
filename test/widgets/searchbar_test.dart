// test/widgets/searchbar_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:primerproyectomovil/widgets/searchbar.dart' as custom;


void main() {
  group('SearchBar Widget Tests', () {
    testWidgets('renders with default hint text', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: custom.SearchBar(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(custom.SearchBar), findsOneWidget);

      // Assert
      expect(find.byType(TextField), findsOneWidget);
      final textFieldWidget = tester.widget<TextField>(find.byType(TextField));
      expect(textFieldWidget.decoration?.hintText, 'Buscar eventos...');
    });

    testWidgets('triggers onChanged callback when text is entered', (WidgetTester tester) async {
      // Arrange
      String? enteredText;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: custom.SearchBar(
              onChanged: (value) {
                enteredText = value;
              },
            ),
          ),
        ),
      );

      // Act
      await tester.enterText(find.byType(TextField), 'Flutter');
      await tester.pump();

      // Assert
      expect(enteredText, 'Flutter');
    });

    testWidgets('displays prefix icon', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: custom.SearchBar(),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.search), findsOneWidget);
    });
  });
}