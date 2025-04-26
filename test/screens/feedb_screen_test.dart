// test/screens/feedb_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:primerproyectomovil/database/db_helper.dart';
import 'package:primerproyectomovil/models/event.dart';
import 'package:primerproyectomovil/models/event_review.dart';
import 'package:primerproyectomovil/screens/feedb_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
@GenerateMocks([DatabaseHelper])
void main() {
  setUpAll(() {
    // 1) Load the ffi implementation
    sqfliteFfiInit();
    // 2) Override the global factory so openDatabase() works in tests
    databaseFactory = databaseFactoryFfi;
  });
  group('EventFeedbackScreen Tests', () {
    final testEvent = Event(id: 1, name: 'Test Event', location: 'Test Location', date: '2023-10-01', description: 'Test Description', maxParticipants: 100, currentParticipants: 0, isFinished: false);

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: EventFeedbackScreen(event: testEvent),
      );
    }

    testWidgets('Displays initial UI components', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Calificaciones y reseñas'), findsNWidgets(2));
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(DropdownButton<bool>), findsOneWidget);
    });

    testWidgets('Star rating selection updates state', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final starButton = find.byIcon(Icons.star_border).first;
      await tester.tap(starButton);
      await tester.pump();

      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('Displays reviews loaded from DatabaseHelper', (WidgetTester tester) async {
      final mockReviews = [
       EventReview(eventId: 1, stars: 5, comment: 'Great event!'),
      EventReview(eventId: 1, stars: 3, comment: 'Average event.'),
      ];
      getEventReviews = (int eventId) async {
    // Filter or ignore eventId if you like; here we return all mockReviews
    return mockReviews.map((review) => <String, dynamic>{
          'eventId': review.eventId,
          'stars': review.stars,
          'text': review.comment,
        }).toList();
  };

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pumpAndSettle();

  

    });
  });
}