import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _database;

  DatabaseHelper._instance();

  Future<Database> get db async {
    _database ??= await initDb();
    return _database!;
  }

  static Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'events.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  static Future<void> _createDb(Database db, int version) async {
    await db.execute('''
          CREATE TABLE Event (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            location TEXT NOT NULL,
            date TEXT NOT NULL,
            max_participants INTEGER NOT NULL,
            description TEXT,
            current_participants INTEGER DEFAULT 0,
            is_finished BOOLEAN DEFAULT 0
          )
        ''');
    await db.execute('''
          CREATE TABLE EventReview (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            event_id INTEGER NOT NULL,
            stars INTEGER NOT NULL,
            text TEXT NOT NULL,
            FOREIGN KEY (event_id) REFERENCES Event (id) ON DELETE CASCADE
          )
        ''');
    await db.execute('''
          CREATE TABLE EventTrack (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL
          )
        ''');
    await db.execute('''
          CREATE TABLE Event_EventTrack (
            event_id INTEGER NOT NULL,
            eventtrack_id INTEGER NOT NULL,
            PRIMARY KEY (event_id, eventtrack_id),
            FOREIGN KEY (event_id) REFERENCES Event (id) ON DELETE CASCADE,
            FOREIGN KEY (eventtrack_id) REFERENCES EventTrack (id) ON DELETE CASCADE
          )
        ''');
  }

  static Future<void> printDatabaseContents() async {
    final db = await instance.db;
    final events = await db.query('Event');
    print('--- Event ---');
    for (var event in events) {
      print(event);
    }
  }

  static Future<int> insertEvent(Map<String, dynamic> event) async {
    final db = await instance.db;
    return await db.insert('Event', event);
  }

  static Future<List<Map<String, dynamic>>> getEvents() async {
    final db = await instance.db;
    return await db.query('Event');
  }

  static Future<int> updateEvent(Map<String, dynamic> event) async {
    final db = await instance.db;
    return await db.update(
      'Event',
      event,
      where: 'id = ?',
      whereArgs: [event['id']],
    );
  }

  static Future<int> deleteEvent(int id) async {
    final db = await instance.db;
    return await db.delete('Event', where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> insertEventReview(Map<String, dynamic> review) async {
    final db = await instance.db;
    return await db.insert('EventReview', review);
  }

  static Future<List<Map<String, dynamic>>> getEventReviews(int eventId) async {
    final db = await instance.db;
    return await db.query(
      'EventReview',
      where: 'event_id = ?',
      whereArgs: [eventId],
    );
  }

  static Future<int> updateEventReview(Map<String, dynamic> review) async {
    final db = await instance.db;
    return await db.update(
      'EventReview',
      review,
      where: 'id = ?',
      whereArgs: [review['id']],
    );
  }

  static Future<int> deleteEventReview(int id) async {
    final db = await instance.db;
    return await db.delete('EventReview', where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> insertEventTrack(Map<String, dynamic> track) async {
    final db = await instance.db;
    return await db.insert('EventTrack', track);
  }

  static Future<List<Map<String, dynamic>>> getEventTracks() async {
    final db = await instance.db;
    return await db.query('EventTrack');
  }

  static Future<int> updateEventTrack(Map<String, dynamic> track) async {
    final db = await instance.db;
    return await db.update(
      'EventTrack',
      track,
      where: 'id = ?',
      whereArgs: [track['id']],
    );
  }

  static Future<int> deleteEventTrack(int id) async {
    final db = await instance.db;
    return await db.delete('EventTrack', where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> getEventsByEventTrack(
    int eventTrackId,
  ) async {
    final db = await instance.db;
    return await db.rawQuery(
      '''
          SELECT Event.*
          FROM Event
          INNER JOIN Event_EventTrack ON Event.id = Event_EventTrack.event_id
          WHERE Event_EventTrack.eventtrack_id = ?
          ''',
      [eventTrackId],
    );
  }

  static Future<int> deleteEventEventTrack(
    int eventId,
    int eventTrackId,
  ) async {
    final db = await instance.db;
    return await db.delete(
      'Event_EventTrack',
      where: 'event_id = ? AND eventtrack_id = ?',
      whereArgs: [eventId, eventTrackId],
    );
  }

  static Future<void> deleteAllData() async {
    final db = await instance.db;

    // Delete all rows from each table
    await db.delete('Event');
    await db.delete('EventReview');
    await db.delete('EventTrack');
    await db.delete('Event_EventTrack');

    // Reset AUTOINCREMENT counters for all tables
    await db.execute("DELETE FROM sqlite_sequence WHERE name='Event';");
    await db.execute("DELETE FROM sqlite_sequence WHERE name='EventReview';");
    await db.execute("DELETE FROM sqlite_sequence WHERE name='EventTrack';");
  }

  static Future<int> associateEventToEventTrack(
    int eventId,
    int eventTrackId,
  ) async {
    final db = await instance.db;
    return await db.insert(
      'Event_EventTrack',
      {'event_id': eventId, 'eventtrack_id': eventTrackId},
      conflictAlgorithm:
          ConflictAlgorithm.ignore, // Prevent duplicate associations
    );
  }
}
