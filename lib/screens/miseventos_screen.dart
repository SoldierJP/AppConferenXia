import 'package:flutter/material.dart';
import 'package:primerproyectomovil/widgets/scrollable.dart';
import '../widgets/searchbar.dart' as custom;

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
              ScrollableEventList(itemCount: 10,),
            ],
          ),
        ),

      ),
    );
  }
}