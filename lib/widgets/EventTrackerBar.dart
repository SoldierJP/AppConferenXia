import 'package:flutter/material.dart';
import 'package:primerproyectomovil/database/db_helper.dart';

class EventTrackBar extends StatefulWidget {
  final void Function(int?) onTrackTapped;
  const EventTrackBar({super.key, required this.onTrackTapped});

  @override
  State<EventTrackBar> createState() => _EventTrackBarState();
}

class _EventTrackBarState extends State<EventTrackBar> {
  List<Map<String, dynamic>> tracks = [];

  @override
  void initState() {
    super.initState();
    loadTracks();
  }

  void loadTracks() async {
    final result = await DatabaseHelper.getEventTracks();
    setState(() {
      tracks = result;
    });
  }

  void onTrackTap(Map<String, dynamic> track) {
    // Aquí podrías hacer algo como filtrar eventos por track
    widget.onTrackTapped(track['id'] as int?);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Track seleccionado: ${track['name']}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45, // Altura como la de la search bar
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: tracks.length,
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final track = tracks[index];
            return ElevatedButton(
              onPressed: () => widget.onTrackTapped(track['id']),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple.shade100,
                foregroundColor: Colors.deepPurple.shade800,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
              child: Text(track['name']),
            );
          },
        ),
      ),
    );
  }
}