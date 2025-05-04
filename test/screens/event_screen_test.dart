// test/screens/event_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:primerproyectomovil/models/event.dart';
import 'package:primerproyectomovil/screens/event_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:primerproyectomovil/screens/feedb_screen.dart';


void main() {

  setUpAll(() {
    // 1) Load the ffi implementation
    sqfliteFfiInit();
    // 2) Override the global factory so openDatabase() works in tests
    databaseFactory = databaseFactoryFfi;

  });

  group('EventDetailScreen Tests', () {
    final testEvent = Event(
      id: 1,
      name: 'Test Event',
      location: 'Test Location',
      date: DateTime.now().add(Duration(days: 1)).toIso8601String(),
      maxParticipants: 10,
      currentParticipants: 5,
      description: 'Test Description',
      isFinished: false,
    );

    testWidgets('Renders event details correctly', (WidgetTester tester) async {
      
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: EventDetailScreen(event: testEvent),
          ),
        );
        await tester.pumpAndSettle();
        await tester.pump(const Duration(days: 1));
      });

      expect(find.text('Test Location'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
      expect(find.text('5 cupos disponibles de 10'), findsOneWidget);
    });

    testWidgets('Subscribe button exists', (WidgetTester tester) async {
      
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: EventDetailScreen(event: testEvent)),
          ),
        );
        await tester.pumpAndSettle();
        await tester.pump(const Duration(days: 1));
        
      });
      final btnFinder = find.widgetWithText(ElevatedButton, 'RESERVAR ENTRADA');
      expect(btnFinder, findsOneWidget);
    });

    testWidgets('Calificar evento button visibility for past events', (WidgetTester tester) async {
      final pastEvent = Event(name: 'Past Event', location: 'Test Location', date: DateTime.now().subtract(Duration(days: 1)).toIso8601String(), maxParticipants: 10, currentParticipants: 5, description: 'Test Description', isFinished: true, id: 1);  

     await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: EventDetailScreen(event: pastEvent),
          ),
        );
        await tester.pumpAndSettle();
        await tester.pump(const Duration(days: 1));
      });


      final feedbackButton = find.text('Calificar evento');
      expect(feedbackButton, findsOneWidget);
      await tester.ensureVisible(feedbackButton);

      await tester.tap(feedbackButton);
      await tester.pumpAndSettle();

      expect(find.byType(EventFeedbackScreen), findsOneWidget);
    });

    testWidgets('Button disabled when no spots available', (WidgetTester tester) async {
      final fullEvent = Event(name: 'Full Event', location: 'Test Location', date: DateTime.now().add(Duration(days: 1)).toIso8601String(), maxParticipants: 10, currentParticipants: 10, description: 'Test Description', isFinished: false, id: 1 
      );

      
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: EventDetailScreen(event: fullEvent),
          ),
        );
        await tester.pumpAndSettle();
        await tester.pump(const Duration(days: 1));
      });

      final subscribeButton = find.text('AGOTADO');
      expect(subscribeButton, findsOneWidget);
      expect(tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed, isNull);
    });
  });
}