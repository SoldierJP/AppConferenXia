// test/widgets/EventTrackerBar_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:primerproyectomovil/widgets/EventTrackerBar.dart';
void main() {


  group('EventTrackBar Widget Tests', () {
    testWidgets('Displays tracks and responds to taps', (WidgetTester tester) async {
      // 2) Arrange
      final fakeTracks = [
      {'id': 1, 'name': 'Track 1'},
      {'id': 2, 'name': 'Track 2'},
    ];
      int? tappedTrackId;
      void onTrackTapped(int? id) => tappedTrackId = id;

      // 3) Act
      await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EventTrackBar(
            onTrackTapped: (id) => tappedTrackId = id,
            loadTracks: () async => fakeTracks,  // ← inject your mock
          ),
        ),
      ),
    );
      await tester.pumpAndSettle();

      // 4) Assert
      expect(find.byType(EventTrackBar), findsOneWidget);
      
      final track1Button = find.widgetWithText(ElevatedButton, 'Track 1');
      expect(track1Button, findsOneWidget);
      await tester.tap(track1Button);
      await tester.pump();
      expect(tappedTrackId, 1);

      final track2Button = find.widgetWithText(ElevatedButton, 'Track 2');
      expect(track2Button, findsOneWidget);
      await tester.tap(track2Button);
      await tester.pump();
      expect(tappedTrackId, 2);
    });
  });
}
