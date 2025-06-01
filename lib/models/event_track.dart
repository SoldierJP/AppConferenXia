class EventTrack {
  final int? id;
  final String name;
  final String? description;

  EventTrack({this.id, required this.name, this.description});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'description': description};
  }

  factory EventTrack.fromMap(Map<String, dynamic> map) {
    return EventTrack(
      id: map['id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String?,
    );
  }
}
