import 'package:flutter/material.dart';
import 'package:primerproyectomovil/widgets/scrollable.dart';
import 'package:provider/provider.dart';
import '../widgets/searchbar.dart' as custom;
import 'package:primerproyectomovil/database/db_helper.dart';
import 'package:primerproyectomovil/models/event.dart';
import 'package:primerproyectomovil/widgets/EventTrackerBar.dart';
import '../database/repositories/data_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  int? selectedTrackId;
  String searchQuery = '';

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

  Future<List<Event>> loadFilteredEvents() async {
    final all =
        await Provider.of<DataRepository>(context, listen: false).fetchEvents();
    return all.where((e) {
      final matchesQuery =
          searchQuery.isEmpty ||
          e.name.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesTrack =
          selectedTrackId == null || e.eventTrackId == selectedTrackId;
      return matchesQuery && matchesTrack;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<DataRepository>(context, listen: false);
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                child: Text(
                  'Descubrir eventos',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              custom.SearchBar(
                hintText: 'Buscar eventos',
                onSubmitted: (value) {
                  // 👈 Cuando se presiona Enter
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              EventTrackBar(dataRepository: repo, onTrackTapped: onTrackTapped),
              const SizedBox(height: 8),
              FutureBuilder<List<Event>>(
                future: loadFilteredEvents(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
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
