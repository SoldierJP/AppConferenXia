// lib/models/event_model.dart
class Event {
  final String id;
  final String title;
  final String imageUrl;
  final String description;
  final DateTime date;
  final String time;
  final String location;
  final int totalCapacity;
  int availableSpots;

  Event({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.totalCapacity,
    this.availableSpots = 0,
  }) {
    availableSpots = totalCapacity;
  }

  bool reserveSpot() {
    if (availableSpots > 0) {
      availableSpots--;
      return true;
    }
    return false;
  }

  String get formattedDate {
    return '${date.day}/${date.month}/${date.year}';
  }
}
