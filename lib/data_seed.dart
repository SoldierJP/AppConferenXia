import 'package:primerproyectomovil/database/db_helper.dart';
import 'package:intl/intl.dart';

Future<void> seedDatabase() async {
  await DatabaseHelper.insertEvent({
    'name': 'Tech Summit 2025',
    'location': 'New York',
    'date': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().add(Duration(minutes: 5))),
    'max_participants': 200,
    'description': 'Annual technology conference.',
  });

  await DatabaseHelper.insertEvent({
    'name': 'Music Fest',
    'location': 'Los Angeles',
    'date': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().add(Duration(minutes: 5))),
    'max_participants': 500,
    'description': 'A festival for music lovers.',
  });

  await DatabaseHelper.insertEventTrack({'name': 'Technology'});
  await DatabaseHelper.insertEventTrack({'name': 'Music'});
  await DatabaseHelper.insertEventTrack({'name': 'Art'});

  await DatabaseHelper.associateEventToEventTrack(
    1,
    1,
  ); // Tech Summit -> Technology
  await DatabaseHelper.associateEventToEventTrack(2, 2); // Music Fest -> Music
}