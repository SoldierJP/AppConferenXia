import 'package:flutter/material.dart';
import 'package:primerproyectomovil/database/db_helper.dart';

class EventTrackBar extends StatefulWidget {
  /// NEW: allow injecting any async loader
  final Future<List<Map<String, dynamic>>> Function() loadTracks;
  final void Function(int?) onTrackTapped;

  const EventTrackBar({
    super.key,
    required this.onTrackTapped,
    this.loadTracks = DatabaseHelper.getEventTracks, 
  });

  @override
  State<EventTrackBar> createState() => _EventTrackBarState();
}

class _EventTrackBarState extends State<EventTrackBar> {
  List<Map<String, dynamic>> tracks = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await widget.loadTracks();
    setState(() => tracks = result);
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
                backgroundColor: const Color(0xFF14213D),
                foregroundColor: Colors.white,
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
