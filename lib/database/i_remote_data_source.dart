import '../models/event.dart';
import '../models/event_track.dart';
import '../models/event_review.dart';

abstract class IRemoteDataSource {
  Future<List<Event>> getEvents();
  // Future<List<EventTrack>> getEventTracks();
  // Future<List<EventReview>> getEventReviews(int eventId);
  // Future<EventReview> addEventReview(EventReview eventReview);
  // Future<Event> updateEvent(Event event);
}