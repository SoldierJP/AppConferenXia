class EventTrack {
  final int? id;
  final String name;
  final String? image;

  EventTrack({
    this.id,
    required this.name,
    this.image,
  });
  // Convert EventTrack to Map (for SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }
  // Create an EventTrack from a Map
  factory EventTrack.fromMap(Map<String, dynamic> map) {
    return EventTrack(
      id: map['id'],
      name: map['name'],
      image: map['image'],
    );
  }
}