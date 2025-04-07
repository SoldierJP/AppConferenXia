import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as path;
import 'package:primerproyectomovil/database/db_helper.dart'; // Adjust path as needed
import 'package:primerproyectomovil/models/event.dart';

void main() {
  setUpAll(() async {
    // Initialize FFI for SQLite
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('DatabaseHelper Tests', () {
    test('Insert an Event and retrieve it', () async {
      final event = {
        'name': 'Flutter Meetup',
        'location': 'San Francisco',
        'date': '2024-04-01',
        'max_participants': 100,
        'description': 'A meetup for Flutter enthusiasts',
        'current_participants': 0,
        'is_finished': 0,
      };

      int id = await DatabaseHelper.insertEvent(event);
      expect(id, isNonZero);

      List<Map<String, dynamic>> events = await DatabaseHelper.getEvents();
      expect(events.length, greaterThan(0));
      expect(events.first['name'], equals(event['name']));
    });

    test('Update an Event', () async {
      final event = {
        'id': 1,
        'name': 'Updated Flutter Meetup',
        'location': 'Los Angeles',
        'date': '2024-04-10',
        'max_participants': 150,
        'description': 'An updated meetup',
        'current_participants': 10,
        'is_finished': 0,
      };
      int updatedRows = await DatabaseHelper.updateEvent(event);
      expect(updatedRows, equals(1));

      List<Map<String, dynamic>> events = await DatabaseHelper.getEvents();
      expect(events.first['name'], equals('Updated Flutter Meetup'));
    });

    test('Delete an Event', () async {
      int deletedRows = await DatabaseHelper.deleteEvent(1);
      expect(deletedRows, equals(1));

      List<Map<String, dynamic>> events = await DatabaseHelper.getEvents();
      expect(events.isEmpty, isTrue);
    });
  });

  group('Event Track Association Tests', () {
    test('Create Event, Event Track, Associate and Retrieve', () async {
      // Create an Event
      final event = {
        'name': 'Tech Conference',
        'location': 'New York',
        'date': '2025-05-15',
        'max_participants': 200,
        'description': 'A conference for tech enthusiasts',
        'current_participants': 50,
        'is_finished': 0,
      };
      int eventId = await DatabaseHelper.insertEvent(event);
      expect(eventId, isNonZero);

      // Create an Event Track
      final eventTrack = {'name': 'AI and Machine Learning'};
      int trackId = await DatabaseHelper.insertEventTrack(eventTrack);
      expect(trackId, isNonZero);

      // Associate Event with Event Track
      final association = {'event_id': eventId, 'track_id': trackId};
      int associationId = await DatabaseHelper.associateEventToEventTrack(
        association['event_id']!,
        association['track_id']!,
      );
      expect(associationId, isNonZero);

      // Retrieve Events associated with the Event Track
      List<Map<String, dynamic>> eventsInTrack =
          await DatabaseHelper.getEventsByEventTrack(trackId);
      expect(eventsInTrack.length, equals(1));
      expect(eventsInTrack.first['name'], equals(event['name']));
      expect(eventsInTrack.first['location'], equals(event['location']));
    });
  });

  group('Subscribed Events Tests', () {
    test('Create Event, Subscribe, and Retrieve Subscribed Events', () async {
      // Create an Event
      final event = {
        'name': 'Tech Workshop',
        'location': 'Boston',
        'date': '2025-06-20',
        'max_participants': 50,
        'description': 'A workshop for tech enthusiasts',
        'current_participants': 10,
        'is_finished': 0,
      };
      int eventId = await DatabaseHelper.insertEvent(event);
      expect(eventId, isNonZero);

      // Subscribe to the Event
      final subscription = {
        'event_id': eventId,
      };
      int subscriptionId = await DatabaseHelper.insertSubscribedEvent(subscription);
      expect(subscriptionId, isNonZero);

      // Retrieve Subscribed Events
      List<Event> subscribedEvents = await DatabaseHelper.getSubscribedEvents();
      expect(subscribedEvents.length, greaterThan(0));
      expect(subscribedEvents.first.name, equals(event['name']));
      expect(subscribedEvents.first.location, equals(event['location']));
    });
  });
}
