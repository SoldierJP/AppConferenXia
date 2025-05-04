// test/screens/miseventos_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:primerproyectomovil/screens/miseventos_screen.dart';
import 'package:primerproyectomovil/database/db_helper.dart';
import 'package:primerproyectomovil/models/event.dart';
import 'package:primerproyectomovil/widgets/scrollable.dart';
import 'package:primerproyectomovil/widgets/searchbar.dart' as custom; 

@GenerateMocks([DatabaseHelper])
void main() {

  setUp(() {
    final mockEvents = [
        Event(id: 1, name: 'Event 1', location: 'location 1', date: '2023-10-01', description: 'Description 1', maxParticipants: 100, currentParticipants: 0, isFinished: false),
        Event(id: 2, name: 'Event 2', description: 'Description 2', date: '2023-10-02', location: 'location 2', maxParticipants: 50, currentParticipants: 0, isFinished: false),
      ];
  loadSubscribedEvents = () async => mockEvents;
});


  group('MisEventosScreen Widget Tests', () {
    testWidgets('Displays SearchBar widget', (WidgetTester tester) async {
      // Arrange
     

      await tester.pumpWidget(const MaterialApp(
        home: MisEventosScreen(),
      ));

      // Assert
      expect(find.byType(custom.SearchBar), findsOneWidget);
    });

    testWidgets('Displays CircularProgressIndicator while loading', (WidgetTester tester) async {
      // Arrange
      
      await tester.pumpWidget(const MaterialApp(
        home: MisEventosScreen(),
      ));

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Displays events when data is available', (WidgetTester tester) async {
      // Arrange
      
     
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
           MaterialApp(
          home: MisEventosScreen(),
        ));
        await tester.pumpAndSettle();
      });
      // Wait for FutureBuilder to complete
      

      // Assert
      expect(find.byType(ScrollableEventList), findsOneWidget);
    });
  });
}
