import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as path;
import 'package:primerproyectomovil/database/db_helper.dart'; // Adjust path as needed

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
}
