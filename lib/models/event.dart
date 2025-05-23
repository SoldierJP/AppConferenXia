class Event {
  final int? id;
  final String name;
  final String location;
  final String date;
  final int maxParticipants;
  final String ? description;
  int currentParticipants;
  final bool isFinished;
  final String ? image;
  final int ? eventTrackId;

  Event({
    this.id,
    required this.name,
    required this.location,
    required this.date,
    required this.maxParticipants,
    this.description,
    this.currentParticipants = 0,
    this.isFinished = false,
    this.image,
    this.eventTrackId,
  });

  // Convert Event to Map (for SQLite)
  Map<String, dynamic> toMap() {
  final map = <String, dynamic>{
    'id': id,                             // int?
    'name': name,                         // non-null String
    'location': location,                 // non-null String
    'date': date,                         // non-null String
    'max_participants': maxParticipants,  // non-null int
    'current_participants': currentParticipants,
    'is_finished': isFinished ? 1 : 0,
    'event_track_id': eventTrackId,
  };

  // only include these if they’re non-null
  if (description != null) {
    map['description'] = description;
  }
  if (image != null) {
    map['image'] = image;
  }
  if (eventTrackId != null) {
    map['event_track_id'] = eventTrackId;
  }

  return map;
}
  // Create an Event from a Map
  factory Event.fromMap(Map<String, dynamic> m) {
  return Event(
    id: (m['id'] as num?)?.toInt(),

    name:     (m['name']             as String?) ?? '',
    location: (m['location']         as String?) ?? '',
    date:     (m['date']             as String?) ?? '',

    // ▶️ Use camelCase here
    maxParticipants:     (m['maxParticipants']     as num?)?.toInt() ?? 0,
    currentParticipants: (m['currentParticipants'] as num?)?.toInt() ?? 0,

    // ▶️ isFinished comes in as a bool already
    isFinished: (m['isFinished'] as bool?) ?? false,

    description: m['description']           as String?,
    image:       m['image']                 as String?,

    // if you ever set eventTrackId:
    eventTrackId: (m['eventTrackId'] as num?)?.toInt(),
  );
}
}
