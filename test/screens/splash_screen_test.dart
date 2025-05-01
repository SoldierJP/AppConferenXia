// test/screens/splash_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:primerproyectomovil/screens/splash_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();               // bootstrap FFI
    databaseFactory = databaseFactoryFfi;  // override global factory
  });

  group('SplashScreen Widget Tests', () {
    testWidgets('Displays gradient background, image, and text', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: SplashScreen(),
        ),
      );
      await tester.pump();
      

      // Assert gradient background
      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.gradient, isNotNull);
      expect(find.byType(Image), findsOneWidget);
      expect(find.image(const AssetImage('assets/images/uninorte.png')), findsOneWidget);
      expect(find.text('ConferenXia'), findsOneWidget);

      await tester.pump(const Duration(seconds: 4));

      await tester.pump();
    });
    testWidgets('SplashScreen navigates after 4s', (tester) async {
      final obs = TestNavObserver();

      await tester.pumpWidget(MaterialApp(
        home: const SplashScreen(),
        navigatorObservers: [obs],
      ));

      await tester.pump();               // schedule the timer
      await tester.pump(const Duration(seconds: 4)); // fire it
      await tester.pump(const Duration(milliseconds: 300)); // finish transition

      // Assert our observer saw the replace
      expect(obs.didReplaceCalled, isTrue);
    });
  });
}

class TestNavObserver extends NavigatorObserver {
  bool didReplaceCalled = false;

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    didReplaceCalled = true;
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}