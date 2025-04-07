import 'package:flutter/material.dart';
import 'package:primerproyectomovil/database/db_helper.dart';
import 'package:primerproyectomovil/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 🔥 ¡NECESARIO para await!

  await DatabaseHelper.insertEvent({
    'name': 'Sample Event',
    'location': 'Sample Location',
    'date': '2023-10-01',
    'max_participants': 100,
    'description': 'This is a sample event.',
  });

  await DatabaseHelper.insertEventTrack({'name': 'Sample Track'});

  var tracks = await DatabaseHelper.getEventTracks();
  print('Tracks: $tracks');

  await DatabaseHelper.printDatabaseContents();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
