import 'package:flutter/material.dart';
import 'package:primerproyectomovil/screens/miseventos_screen.dart';
import 'package:primerproyectomovil/screens/splash_screen.dart';
import 'data_seed.dart';
import 'data_delete.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //deleteAllData();
  seedDatabase();   //descomentar para agregar datos, ir al data_Seed.dart para cambiarlos datos insertados.
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
