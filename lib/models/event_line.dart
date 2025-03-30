class EventLine {
  final int? id;
  final String name;
  final String? image;

  EventLine({
    this.id,
    required this.name,
    this.image,
  });
  // Convert EventLine to Map (for SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }
  // Create an EventLine from a Map
  factory EventLine.fromMap(Map<String, dynamic> map) {
    return EventLine(
      id: map['id'],
      name: map['name'],
      image: map['image'],
    );
  }
}