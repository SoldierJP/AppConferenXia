import 'package:flutter/material.dart';
import 'package:primerproyectomovil/widgets/scrollable.dart';
import '../widgets/searchbar.dart' as custom;
import 'package:primerproyectomovil/database/db_helper.dart';
import 'package:primerproyectomovil/models/event.dart';
import 'package:primerproyectomovil/widgets/EventTrackerBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  int? selectedTrackId;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void onTrackTapped(int? index) {
    setState(() {
      selectedTrackId = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.fromLTRB(
            0,
            MediaQuery.of(context).padding.top,
            0,
            0,
          ),
          child: Column(
            children: [
              custom.SearchBar(
                hintText: 'Buscar eventos',
                onChanged: (value) {},
              ),
              const SizedBox(height: 8),
              EventTrackBar(onTrackTapped: onTrackTapped), // ← Añadido aquí
              const SizedBox(height: 8),
              FutureBuilder<List<Event>>(
                future: DatabaseHelper.getEventsByEventTrack(selectedTrackId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final events = snapshot.data ?? [];
                    return ScrollableEventList(events: events);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
