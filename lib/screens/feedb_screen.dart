import 'package:flutter/material.dart';
import 'package:primerproyectomovil/database/db_helper.dart';
import 'package:primerproyectomovil/models/event.dart';

class EventFeedbackScreen extends StatefulWidget {
  final Event event;

  const EventFeedbackScreen({super.key, required this.event});

  @override
  State<EventFeedbackScreen> createState() => _EventFeedbackScreenState();
}

class _EventFeedbackScreenState extends State<EventFeedbackScreen> {
  int selectedStars = 0;
  final TextEditingController _opinionController = TextEditingController();
  List<Map<String, dynamic>> reviews = [];
  bool showBestRated = true;
  double averageRating = 0.0;

  @override
  void initState() {
    super.initState();
    _loadReviews();
    averageRating = DatabaseHelper.calculateAverageRating(reviews);
  }

  Future<void> _loadReviews() async {
    final data = await getEventReviews(widget.event.id!);
    setState(() {
      reviews = List<Map<String, dynamic>>.from(data);
      _sortReviews();
      averageRating = DatabaseHelper.calculateAverageRating(reviews);
    });
  }

  void _sortReviews() {
    reviews.sort(
      (a, b) =>
          showBestRated
              ? b['stars'].compareTo(a['stars'])
              : a['stars'].compareTo(b['stars']),
    );
  }

  Future<void> _submitReview() async {
    if (selectedStars == 0 || _opinionController.text.isEmpty) return;

    await DatabaseHelper.insertEventReview({
      'event_id': widget.event.id!,
      'stars': selectedStars,
      'text': _opinionController.text,
    });

    _opinionController.clear();
    selectedStars = 0;
    _loadReviews();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF14213D);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calificaciones y reseñas'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Calificaciones y reseñas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '$averageRating de 5',
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const Text(
              'Calificar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Row(
              children: List.generate(
                5,
                (index) => IconButton(
                  icon: Icon(
                    selectedStars > index ? Icons.star : Icons.star_border,
                    color: Colors.blue,
                    size: 32,
                  ),
                  onPressed: () {
                    setState(() {
                      selectedStars = index + 1;
                    });
                  },
                ),
              ),
            ),
            TextField(
              controller: _opinionController,
              decoration: InputDecoration(
                hintText: 'Escribe tu opinión...',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _submitReview,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Center(child: Text('Escribe tu opinión!')),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  'Más favorables',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 8),
                DropdownButton<bool>(
                  value: showBestRated,
                  items: const [
                    DropdownMenuItem(value: true, child: Text('⬆️')),
                    DropdownMenuItem(value: false, child: Text('⬇️')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      showBestRated = value!;
                      _sortReviews();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child:
                  reviews.isEmpty
                      ? const Text("Sin reseñas aún.")
                      : ListView.builder(
                        itemCount: reviews.length,
                        itemBuilder: (context, index) {
                          final review = reviews[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: List.generate(
                                      5,
                                      (i) => Icon(
                                        i < review['stars']
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.amber,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    review['text'],
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
