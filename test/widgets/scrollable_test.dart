import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:primerproyectomovil/models/event.dart';
import 'package:primerproyectomovil/widgets/scrollable.dart';

import 'package:network_image_mock/network_image_mock.dart';

void main() {
  testWidgets('Scrollable Event List Test', (WidgetTester tester) async {
    final events = List.generate(10, (index) => Event(
      name: 'Event $index',
      location: 'Location $index',
      date: 'date $index',
      maxParticipants: 100,
      description: 'Description for event $index',
      currentParticipants: 0,
      isFinished: false,
    ));

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            // either this:
            // body: ScrollableEventList(events: events),
            // or wrap in Expanded:
            body: Column(
              children: [
                ScrollableEventList(events: events),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Event 0'), findsOneWidget);
    });
  });
}
