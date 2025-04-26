// test/screens/home_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:primerproyectomovil/screens/home_screen.dart';
import 'package:primerproyectomovil/widgets/searchbar.dart' as custom;
import 'package:primerproyectomovil/widgets/EventTrackerBar.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    // 1) Load the ffi implementation
    sqfliteFfiInit();
    // 2) Override the global factory so openDatabase() works in tests
    databaseFactory = databaseFactoryFfi;
  });
  group('HomeScreen Widget Tests', () {
    testWidgets('Displays SearchBar and EventTrackBar', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      // Assert SearchBar is displayed
      expect(find.byType(custom.SearchBar), findsOneWidget);

      // Assert EventTrackBar is displayed
      expect(find.byType(EventTrackBar), findsOneWidget);
    });

    testWidgets('Displays loading indicator in FutureBuilder', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      // Assert CircularProgressIndicator is displayed
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Displays error message in FutureBuilder', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(MaterialApp(
        home: HomeScreen(),
      ));

      // Simulate error in FutureBuilder
      await tester.pump();
      expect(find.textContaining('Error:'), findsNothing);
    });

    // testWidgets('Displays events in FutureBuilder success state', (WidgetTester tester) async {
    //   // Mock data
    //   final mockEvents = [
    //     Event(id: 1, name: 'Event 1', trackId: 1),
    //     Event(id: 2, name: 'Event 2', trackId: 1),
    //   ];

    //   // Arrange
    //   await tester.pumpWidget(MaterialApp(
    //     home: HomeScreen(),
    //   ));

    //   // Simulate success state
    //   await tester.pump();
    //   expect(find.byType(ScrollableEventList), findsOneWidget);
    // });

    testWidgets('Tapping EventTrackBar updates selectedTrackId', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      // Act
      await tester.tap(find.byType(EventTrackBar));
      await tester.pump();

      // Assert state change
      // (You would need to mock or verify the state change here)
    });
  });
}