import 'package:flutter/material.dart';
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
    final primaryColor = Color.fromRGBO(20, 33, 61, 1);
    final availableSpots = event.maxParticipants - event.currentParticipants;

    return Scaffold(
      appBar: AppBar(
        title: Text(event.name),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'event-image-${event.id}',
              child: Image.network(
                'https://picsum.photos/400/200?random=${event.id}',
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color:
                          availableSpots > 5
                              ? Colors.green[100]
                              : Colors.orange[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$availableSpots cupos disponibles de ${event.maxParticipants}',
                      style: TextStyle(
                        color:
                            availableSpots > 5
                                ? Colors.green[800]
                                : Colors.orange[800],
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
                      Text(
                        DateFormat(
                          'yyyy-MM-dd',
                        ).format(DateTime.parse(event.date)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('HH:mm').format(DateTime.parse(event.date)),
                      ),
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
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed:
                          (availableSpots > 0 || isSubscribed)
                              ? () async {
                                if (isSubscribed) {
                                  await DatabaseHelper.deleteSubscribedEvent(
                                    event.id!,
                                  );
                                  final updatedEvent = {
                                    'id': event.id,
                                    'name': event.name,
                                    'location': event.location,
                                    'date': event.date,
                                    'max_participants': event.maxParticipants,
                                    'description': event.description,
                                    'current_participants':
                                        event.currentParticipants - 1,
                                    'is_finished': event.isFinished ? 1 : 0,
                                  };
                                  await DatabaseHelper.updateEvent(
                                    updatedEvent,
                                  );
                                  setState(() {
                                    event.currentParticipants--;
                                    isSubscribed = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Registro cancelado para ${event.name}',
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                } else {
                                  await DatabaseHelper.insertSubscribedEvent(
                                    event.id!,
                                  );
                                  final updatedEvent = {
                                    'id': event.id,
                                    'name': event.name,
                                    'location': event.location,
                                    'date': event.date,
                                    'max_participants': event.maxParticipants,
                                    'description': event.description,
                                    'current_participants':
                                        event.currentParticipants + 1,
                                    'is_finished': event.isFinished ? 1 : 0,
                                  };
                                  await DatabaseHelper.updateEvent(
                                    updatedEvent,
                                  );
                                  setState(() {
                                    event.currentParticipants++;
                                    isSubscribed = true;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Reserva confirmada para ${event.name}',
                                      ),
                                      backgroundColor: primaryColor,
                                    ),
                                  );
                                }
                              }
                              : null,
                      child: Text(
                        availableSpots == 0 && !isSubscribed
                            ? 'AGOTADO'
                            : isSubscribed
                            ? 'CANCELAR REGISTRO'
                            : 'RESERVAR ENTRADA',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  isPastEvent
                      ? SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: primaryColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => EventFeedbackScreen(
                                      event: widget.event,
                                    ),
                              ),
                            );
                          },
                          child: Text(
                            'Calificar evento',
                            style: TextStyle(
                              fontSize: 16,
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
