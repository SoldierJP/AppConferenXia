import 'package:flutter/material.dart';
import 'package:intl/date_symbols.dart';
import 'package:primerproyectomovil/database/repositories/data_repository.dart';
import 'package:primerproyectomovil/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'data_seed.dart';
import 'data_delete.dart';
import '../database/datasources/local/local_data_source.dart';
import '../database/datasources/remote/remote_data_source.dart';
import '../database/core/network_info.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  deleteAllData();
  seedDatabase(); //descomentar para agregar datos, ir al data_Seed.dart para cambiarlos datos insertados.
  runApp(
    Provider<DataRepository>(
      create: (_) {
        final remote = RemoteDataSource();
        final local = LocalDataSource();
        final network = NetworkInfo();
        return DataRepository(remote, local, network);
      },
      child: const MyApp(),
    ),
  );
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
