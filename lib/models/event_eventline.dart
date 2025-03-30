class EventEventTrack {
  final int eventId;
  final int eventTrackId;

  EventEventTrack({required this.eventId, required this.eventTrackId});

  // Convert from database to model
  factory EventEventTrack.fromMap(Map<String, dynamic> map) {
    return EventEventTrack(
      eventId: map['event_id'],
      eventTrackId: map['eventtrack_id'],
    );
  }

  // Convert from model to database format
  Map<String, dynamic> toMap() {
    return {
      'event_id': eventId,
      'eventtrack_id': eventTrackId,
    };
  }
}
