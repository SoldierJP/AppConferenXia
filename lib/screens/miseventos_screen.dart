import 'package:flutter/material.dart';
import 'package:primerproyectomovil/widgets/scrollable.dart';
import '../widgets/navbar.dart';
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

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).padding.top, 0, 0),
          child: Column(
            children: [
              custom.SearchBar(
                hintText: 'Buscar eventos',
                onChanged: (value) {},
              ),
              FutureBuilder<List<Event>>(
      future: DatabaseHelper.getSubscribedEvents(),
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