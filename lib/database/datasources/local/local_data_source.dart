import '../../../models/event.dart';
import '../../../models/event_review.dart';
import '../../../models/event_track.dart';
import 'i_local_data_source.dart';
import '../../../database/db_helper.dart';

class LocalDataSource implements ILocalDataSource {
  @override
  Future<void> insertEvent(Event event) async {
    final map = event.toMap();
    print('insertEvent() → map: $map');
    try {
      await DatabaseHelper.insertEvent(event.toMap());
    } catch (e) {
      print('Error inserting event: $e');
    }
  }

  @override
  Future<List<Event>> getEvents() async {
    // cambiar a getEvents por trackId
    // trackId es atributo de Event
    // llamado en widgets/scrollable.dart
    final events = await DatabaseHelper.getEvents();
    return events.map((event) => Event.fromMap(event)).toList();
  }

  @override
  Future<void> insertEventReview(EventReview eventReview) async {
    await DatabaseHelper.insertEventReview(eventReview.toMap());
  }

  @override
  Future<List<EventReview>> getEventReviews(int eventId) async {
    final reviews = await DatabaseHelper.getEventReviews(eventId);
    return reviews.map((review) => EventReview.fromMap(review)).toList();
  }

  @override
  Future<void> saveAsPending(Event event) async {
    await DatabaseHelper.insertPendingEvent(event.toMap());
  }

  @override
  Future<List<Event>> getPendingEvents() async {
    final pending = await DatabaseHelper.getPendingEvents();
    return pending.map((e) => Event.fromMap(e)).toList();
  }

  @override
  Future<List<EventTrack>> getEventTracks() async {
    final tracks = await DatabaseHelper.getEventTracks();
    return tracks.map((track) => EventTrack.fromMap(track)).toList();
  }

  @override
  Future<void> insertEventTrack(EventTrack track) async {
    try {
      await DatabaseHelper.insertEventTrack(track.toMap());
    } catch (e) {
      print('Error inserting track: $e');
      rethrow;
    }
  }
}
