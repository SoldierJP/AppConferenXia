import 'package:flutter/material.dart';
import 'package:primerproyectomovil/database/db_helper.dart';
import '../database/repositories/data_repository.dart';
import '../models/event_track.dart';

class EventTrackBar extends StatefulWidget {
  /// NEW: allow injecting any async loader
  final DataRepository dataRepository;
  final void Function(int?) onTrackTapped;

  const EventTrackBar({
    super.key,
    required this.onTrackTapped,
    required this.dataRepository
  });

  @override
  State<EventTrackBar> createState() => _EventTrackBarState();
}

class _EventTrackBarState extends State<EventTrackBar> {
  late final Future<List<EventTrack>> Function() _loader;

  @override
  void initState() {
    super.initState();
    _loader = widget.dataRepository.fetchEventTracks;
    _load();
  }
  
  List<EventTrack> _tracks = [];
  bool _isLoading = true;

  Future<void> _load() async {
    try {
      print('Loading event tracks...');
      final tracks = await _loader();
      print('Loaded ${tracks.length} event tracks');
      setState(() {
        _tracks = tracks;
        _isLoading = false;
      });
    } catch (e, st) {
  print('🔴 _load() caught error: $e');
  print('Stack trace:\n$st');
  setState(() => _isLoading = false);
}
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return SizedBox(
      height: 45, // Altura como la de la search bar
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _tracks.length,
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final track = _tracks[index];
            return ElevatedButton(
              onPressed: () => widget.onTrackTapped(track.id),
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
              child: Text(track.name),
            );
          },
        ),
      ),
    );
  }
}
