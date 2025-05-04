import 'package:primerproyectomovil/database/db_helper.dart';
import 'package:intl/intl.dart';

Future<void> seedDatabase() async {
  await DatabaseHelper.insertEvent({
    'name': 'Tech Summit 2025',
    'location': 'New York',
    'date': DateFormat(
      'yyyy-MM-dd HH:mm:ss',
    ).format(DateTime.now().add(Duration(minutes: 5))),
    'max_participants': 200,
    'description': 'Annual technology conference.',
    // 'image': 'assets/images/tech.png',
  });

  await DatabaseHelper.insertEvent({
    'name': 'Music Fest',
    'location': 'Los Angeles',
    'date': DateFormat(
      'yyyy-MM-dd HH:mm:ss',
    ).format(DateTime.now().add(Duration(minutes: 5))),
    'max_participants': 500,
    'description': 'A festival for music lovers.',
    // 'image': 'assets/images/music.png',
  });
  await DatabaseHelper.insertEvent({
    'name': 'Sports Marathon 2025',
    'location': 'Chicago',
    'date': DateFormat(
      'yyyy-MM-dd HH:mm:ss',
    ).format(DateTime.now().add(Duration(minutes: 10))),
    'max_participants': 300,
    'description': 'Join the biggest sports marathon of the year.',
    //
  });

  await DatabaseHelper.insertEvent({
    'name': 'Art Expo',
    'location': 'San Francisco',
    'date': DateFormat(
      'yyyy-MM-dd HH:mm:ss',
    ).format(DateTime.now().add(Duration(minutes: 15))),
    'max_participants': 150,
    'description': 'Explore inspiring artworks from around the world.',
    // 'image': 'assets/images/art.png',
  });

  await DatabaseHelper.insertEvent({
    'name': 'Food Carnival',
    'location': 'Austin',
    'date': DateFormat(
      'yyyy-MM-dd HH:mm:ss',
    ).format(DateTime.now().add(Duration(minutes: 20))),
    'max_participants': 250,
    'description': 'Taste dishes from various cultures in one place.',
    // 'image': 'assets/images/food.png',
  });

  await DatabaseHelper.insertEventTrack({'name': 'Technology'});
  await DatabaseHelper.insertEventTrack({'name': 'Music'});
  await DatabaseHelper.insertEventTrack({'name': 'Sport'});
  await DatabaseHelper.insertEventTrack({'name': 'Art'});
  await DatabaseHelper.insertEventTrack({'name': 'Food'});

  await DatabaseHelper.associateEventToEventTrack(
    1,
    1,
  ); // Tech Summit -> Technology
  await DatabaseHelper.associateEventToEventTrack(2, 2); // Music Fest -> Music
  await DatabaseHelper.associateEventToEventTrack(3, 3);
  await DatabaseHelper.associateEventToEventTrack(4, 4);
  await DatabaseHelper.associateEventToEventTrack(5, 5);
}
