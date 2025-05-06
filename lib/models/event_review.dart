class EventReview {
  final int? id;
  final int eventId;
  final int stars;
  final String text;

  EventReview({
    this.id,
    required this.eventId,
    required this.stars,
    required this.text,
  });
  // Convert EventReview to Map (for SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'event_id': eventId,
      'stars': stars,
      'text': text,
    };
  }
  // Create an EventReview from a Map 
  factory EventReview.fromMap(Map<String, dynamic> map) {
    return EventReview(
      id: map['id'],
      eventId: map['event_id'],
      stars: map['stars'],
      text: map['text'],
    );
  }
}