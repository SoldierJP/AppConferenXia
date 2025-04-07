class SubscribedEvent {
  final int EventId;

  SubscribedEvent({
    required this.EventId,
  });
  // Convert SubscribedEvent to Map (for SQLite)
  Map<String, dynamic> toMap() {
    return {
      'EventId': EventId,
    };
  }
  // Create a SubscribedEvent from a Map
  factory SubscribedEvent.fromMap(Map<String, dynamic> map) {
    return SubscribedEvent(
      EventId: map['EventId'],
    );
  }
  
}
