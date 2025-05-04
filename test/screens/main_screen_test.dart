// test/screens/main_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:primerproyectomovil/screens/main_screen.dart';
import 'package:primerproyectomovil/screens/home_screen.dart';
import 'package:primerproyectomovil/screens/miseventos_screen.dart';
import 'package:primerproyectomovil/widgets/navbar.dart';
import 'package:primerproyectomovil/controllers/nav_controller.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class MockNavController extends GetxController implements NavController {
  @override
  var currentIndex = 0.obs;

  @override
  void changeIndex(int index) {
    currentIndex.value = index;
  }
}

void main() {
  setUpAll(() {
    // 1) Load the ffi implementation
    sqfliteFfiInit();
    // 2) Override the global factory so openDatabase() works in tests
    databaseFactory = databaseFactoryFfi;
  });
  group('NavWrapper Widget Tests', () {
    late MockNavController mockNavController;
    setUp(() {
      mockNavController = MockNavController();
      Get.reset();
      Get.put<NavController>(mockNavController);
    });

    testWidgets('Displays the correct screen based on currentIndex', (WidgetTester tester) async {
      // Arrange
    

      await tester.pumpWidget(
        MaterialApp(
          home: NavWrapper(),
        ),
      );

      // Assert HomeScreen is displayed
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(MisEventosScreen), findsNothing);

      // Act
      mockNavController.currentIndex.value = 1;
      await tester.pump();

      // Assert MisEventosScreen is displayed
      expect(find.byType(HomeScreen), findsNothing);
      expect(find.byType(MisEventosScreen), findsOneWidget);
    });

    testWidgets('Displays Navbar widget', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: NavWrapper(),
        ),
      );

      // Assert Navbar is displayed
      expect(find.byType(Navbar), findsOneWidget);
    });
  });
}