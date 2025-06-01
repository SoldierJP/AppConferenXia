import 'package:primerproyectomovil/models/event.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;

typedef TracksLoader = Future<List<Map<String, dynamic>>> Function();

/// Expose a top-level `getEventTracks` variable, defaulting to your static call
TracksLoader getEventTracks = DatabaseHelper.getEventTracks;

typedef SubscribedEventsLoader = Future<List<Event>> Function();
SubscribedEventsLoader loadSubscribedEvents =
    DatabaseHelper.getSubscribedEvents;

typedef EventReviewsLoader =
    Future<List<Map<String, dynamic>>> Function(int eventId);
EventReviewsLoader getEventReviews = DatabaseHelper.getEventReviews;

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _database;

  DatabaseHelper._instance();

  Future<Database> get db async {
    _database ??= await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'events.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
          CREATE TABLE Event (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            location TEXT NOT NULL,
            date TEXT NOT NULL,
            max_participants INTEGER NOT NULL,
            description TEXT,
            current_participants INTEGER DEFAULT 0,
            is_finished BOOLEAN DEFAULT 0,
            image TEXT, 
            event_track_id INTEGER,
            FOREIGN KEY (event_track_id) REFERENCES EventTrack (id) ON DELETE SET NULL
          )
        ''');
    await db.execute('''
          CREATE TABLE EventReview (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            event_id INTEGER NOT NULL,
            stars INTEGER NOT NULL,
            text TEXT NOT NULL,
            event_track_id INTEGER,
            FOREIGN KEY (event_id) REFERENCES Event (id) ON DELETE CASCADE
          )
        ''');
    await db.execute('''
          CREATE TABLE EventTrack (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            image TEXT
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
    await db.execute('''
          CREATE TABLE SubscribedEvent (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            event_id INTEGER NOT NULL,
            FOREIGN KEY (event_id) REFERENCES Event (id) ON DELETE CASCADE
          )
        ''');
  }

  static Future<int> insertEvent(Map<String, dynamic> event) async {
    final db = await instance.db;
    return await db.insert(
      'Event',
      event,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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
    return await db.insert(
      'EventReview',
      review,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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
    return await db.insert('EventTrack', track,
    conflictAlgorithm: ConflictAlgorithm.replace
    );
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

  static Future<List<Event>> getEventsByEventTrack(int? eventTrackId) async {
    final db = await instance.db;
    if (eventTrackId == null) {
      final rawData = await db.query("Event");
      return rawData.map((map) => Event.fromMap(map)).toList();
    }
    final rawData = await db.rawQuery(
      '''
          SELECT Event.*
          FROM Event
          INNER JOIN Event_EventTrack ON Event.id = Event_EventTrack.event_id
          WHERE Event_EventTrack.eventtrack_id = ?
          ''',
      [eventTrackId],
    );
    return rawData.map((map) => Event.fromMap(map)).toList();
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
    await db.delete('SubscribedEvent');

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

  static Future<int> insertSubscribedEvent(int eventId) async {
    final db = await instance.db;
    return await db.insert('SubscribedEvent', {'event_id': eventId});
  }

  static Future<List<Event>> getSubscribedEvents() async {
    final db = await instance.db;
    final rawData = await db.rawQuery('''
    SELECT Event.*
    FROM Event
    INNER JOIN SubscribedEvent ON SubscribedEvent.event_id = Event.id
  ''');

    return rawData.map((map) => Event.fromMap(map)).toList();
  }

  static Future<List<Event>> getAllEvents() async {
    final db = await instance.db;
    final rawData = await db.query('Event');
    return rawData.map((map) => Event.fromMap(map)).toList();
  }

  static double calculateAverageRating(List<Map<String, dynamic>> reviews) {
    // debería ser un servicio o 'use case',
    // estar por fuera de lógica de la base de datos
    if (reviews.isEmpty) return 0.0;
    double total = 0.0;
    for (var review in reviews) {
      total += review['stars'];
    }
    return total / reviews.length;
  }

  static Future<int> deleteSubscribedEvent(int id) async {
    final db = await instance.db;
    return await db.delete(
      'SubscribedEvent',
      where: 'event_id  = ?',
      whereArgs: [id],
    );
  }

  static Future<bool> isEventSubscribed(int eventId) async {
    final db = await instance.db;
    final result = await db.query(
      'SubscribedEvent',
      where: 'event_id = ?',
      whereArgs: [eventId],
    );
    return result.isNotEmpty;
  }

  static Future<int> insertPendingEvent(Map<String, dynamic> event) async {
    final db = await instance.db;
    return await db.insert(
      'PendingEvent',
      event,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getPendingEvents() async {
    final db = await instance.db;
    return await db.query('PendingEvent');
  }
}
