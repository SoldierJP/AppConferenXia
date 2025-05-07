import 'package:flutter/material.dart';
import 'package:primerproyectomovil/widgets/scrollable.dart';
import '../widgets/searchbar.dart' as custom;
import 'package:primerproyectomovil/database/db_helper.dart';
import 'package:primerproyectomovil/models/event.dart';

class MisEventosScreen extends StatefulWidget {
  const MisEventosScreen({super.key});

  @override
  MisEventosScreenState createState() => MisEventosScreenState();
}

class MisEventosScreenState extends State<MisEventosScreen> {
  int selectedIndex = 1;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _futureEvents = loadSubscribedEvents();
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Future<List<Event>> loadSubscribedEventsFiltered() async {
    final all = await DatabaseHelper.getSubscribedEvents();
    if (searchQuery.isEmpty) return all;
    return all
        .where((e) => e.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  late Future<List<Event>> _futureEvents;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              onSubmitted: (value) {
                setState(() {
                  searchQuery = value;
                  _futureEvents = loadSubscribedEventsFiltered();
                });
              },
            ),
            Expanded(
              child: FutureBuilder<List<Event>>(
                future: _futureEvents,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final events = snapshot.data ?? [];
                    return ScrollableEventList(
                      events: events,
                      onRefresh: () {
                        setState(() {
                          _futureEvents = loadSubscribedEventsFiltered();
                        });
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
