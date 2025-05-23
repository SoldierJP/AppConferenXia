// test/widgets/navbar_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:primerproyectomovil/controllers/nav_controller.dart';
import 'package:primerproyectomovil/widgets/navbar.dart';

// Mock NavController
class MockNavController extends GetxController implements NavController {
  @override
  var currentIndex = 0.obs;

  @override
  void changeIndex(int index) {
    currentIndex.value = index;
  }
}

void main() {
  group('Navbar Widget Tests', () {
    late MockNavController mockNavController;

    setUp(() {
      mockNavController = MockNavController();
      Get.put<NavController>(mockNavController);
    });

    testWidgets('renders BottomNavigationBar with correct items', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: Navbar())));

      // Verify BottomNavigationBar is present
      expect(find.byType(BottomNavigationBar), findsOneWidget);

      // Verify navigation items
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Mis Eventos'), findsOneWidget);
    });

    testWidgets('calls changeIndex on tap', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: Navbar())));

      // Tap on the second navigation item
      expect(find.text('Mis Eventos'), findsOneWidget);
      await tester.tap(find.text('Mis Eventos'));
      await tester.pumpAndSettle();

      // Verify changeIndex is called with the correct index
      expect(mockNavController.currentIndex.value, 0);
    });
  });
}
