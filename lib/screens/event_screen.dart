import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:primerproyectomovil/database/db_helper.dart';
import 'package:primerproyectomovil/models/event.dart';
import 'package:intl/intl.dart';
import 'package:primerproyectomovil/screens/feedb_screen.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool isPastEvent = false;
  bool isSubscribed = false;

  @override
  void initState() {
    super.initState();
    final eventTime = DateTime.parse(widget.event.date);
    final now = DateTime.now();
    isPastEvent = eventTime.isBefore(now);

    if (!isPastEvent) {
      final delay = eventTime.difference(now);
      Future.delayed(delay, () {
        if (mounted) {
          setState(() {
            isPastEvent = true;
            isSubscribed = false;
          });
        }
      });
    }

    checkIfSubscribed();
  }

  Future<void> checkIfSubscribed() async {
    final result = await DatabaseHelper.isEventSubscribed(widget.event.id!);
    setState(() {
      isSubscribed = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    const primaryColor = Color(0xFF14213D);
    final availableSpots = event.maxParticipants - event.currentParticipants;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: primaryColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: primaryColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(event.name),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'event-${event.id}',
                child: Image.network(
                  event.image ?? 'https://picsum.photos/400/200?random=${event.id}',
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: availableSpots > 5 ? Colors.green[100] : Colors.orange[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$availableSpots cupos disponibles de ${event.maxParticipants}',
                        style: TextStyle(
                          color: availableSpots > 5 ? Colors.green[800] : Colors.orange[800],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Descripción del evento:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.description ?? 'Descripción no disponible',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Detalles:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16),
                        const SizedBox(width: 8),
                        Text(DateFormat('yyyy-MM-dd').format(DateTime.parse(event.date))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 16),
                        const SizedBox(width: 8),
                        Text(DateFormat('HH:mm').format(DateTime.parse(event.date))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16),
                        const SizedBox(width: 8),
                        Text(event.location),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: (availableSpots > 0 || isSubscribed) ? () async {
                          if (isSubscribed) {
                            await DatabaseHelper.deleteSubscribedEvent(event.id!);
                            final updatedEvent = {
                              'id': event.id,
                              'name': event.name,
                              'location': event.location,
                              'date': event.date,
                              'max_participants': event.maxParticipants,
                              'description': event.description,
                              'current_participants': event.currentParticipants - 1,
                              'is_finished': event.isFinished ? 1 : 0,
                            };
                            await DatabaseHelper.updateEvent(updatedEvent);
                            setState(() {
                              event.currentParticipants--;
                              isSubscribed = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Te has dado de baja del evento "${event.name}"'),
                                backgroundColor: primaryColor,
                              ),
                            );
                          } else {
                            await DatabaseHelper.insertSubscribedEvent(event.id!);
                            final updatedEvent = {
                              'id': event.id,
                              'name': event.name,
                              'location': event.location,
                              'date': event.date,
                              'max_participants': event.maxParticipants,
                              'description': event.description,
                              'current_participants': event.currentParticipants + 1,
                              'is_finished': event.isFinished ? 1 : 0,
                            };
                            await DatabaseHelper.updateEvent(updatedEvent);
                            setState(() {
                              event.currentParticipants++;
                              isSubscribed = true;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Reserva confirmada para "${event.name}"'),
                                backgroundColor: primaryColor,
                              ),
                            );
                          }
                        } : null,
                        child: Text(
                          availableSpots == 0 && !isSubscribed
                              ? 'AGOTADO'
                              : isSubscribed
                                  ? 'CANCELAR REGISTRO'
                                  : 'RESERVAR ENTRADA',
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (isPastEvent)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    EventFeedbackScreen(event: widget.event),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: primaryColor),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Calificar evento',
                            style: TextStyle(
                              fontSize: 16,
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
