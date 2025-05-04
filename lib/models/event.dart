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
    return {
      'id': id,
      'name': name,
      'location': location,
      'date': date,
      'max_participants': maxParticipants,
      'description': description,
      'current_participants': currentParticipants,
      'is_finished': isFinished ? 1 : 0,
      'image': image, // Include the new attribute
    };
  }

  // Create an Event from a Map
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      name: map['name'],
      location: map['location'],
      date: map['date'],
      maxParticipants: map['max_participants'],
      description: map['description'],
      currentParticipants: map['current_participants'],
      isFinished: map['is_finished'] == 1,
      image: map['image'], // Map the new attribute
    );
  }
}
