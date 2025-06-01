import '../../../models/event.dart';
import '../../../models/event_review.dart';
import '../../../models/event_track.dart';


abstract class ILocalDataSource {
  Future<void> insertEvent(Event event);
  Future<List<Event>> getEvents();
  

  Future<void> insertEventReview(EventReview review);
  Future<List<EventReview>> getEventReviews(int eventId);
  
  Future<void> saveAsPending(Event event);
  Future<List<Event>> getPendingEvents();

  Future<List<EventTrack>> getEventTracks();
  Future<void> insertEventTrack(EventTrack eventTrack);

  //a implementar
  // Future<List<Event>> getEvents();
  // Future<void> updateEvent(Event event);
  // Future<void> deleteEvent(int id);
  // Future<void> insertEventReview(EventReview eventReview);
  // Future<List<EventReview>> getEventReviews(int eventId);
  // Future<void> updateEventReview(EventReview eventReview);
  // Future<void> deleteEventReview(int id);
  // Future<void> insertEventTrack(EventTrack eventTrack);
  // Future<List<EventTrack>> getEventTracks();
  // Future<void> updateEventTrack(EventTrack eventTrack);
  // Future<void> deleteEventTrack(int id);
  // Future<List<Event>> getEventsByTrackId(int trackId);
  // Future<void> insertSubscribedEvent(SubscribedEvent subscribedEvent);
  // Future<List<Event>> getSubscribedEvents();
  // Future<void> deleteSubscribedEvent(int id);
}
