import '../../../../../models/event.dart';
import '../../../../../models/event_track.dart';
import '../../../../../models/event_review.dart';
import 'i_remote_data_source.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RemoteDataSource implements IRemoteDataSource{
  final http.Client httpClient;

  final String contractKey = 'e83b7ac8-bdad-4bb8-a532-6aaa5fddefa4';

  final String baseUrl = 'https://unidb.openlab.uninorte.edu.co';

  RemoteDataSource({http.Client? httpClient})
      : httpClient = httpClient ?? http.Client();


  @override
  Future<List<Event>> getEvents() async {
    List<Event> events = [];
    final request = Uri.parse('$baseUrl/$contractKey/data/events/all')
        .resolveUri(Uri(queryParameters: {'format': 'json'}
    ));
    final response = await httpClient.get(request);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      events = List<Event>.from(data.map((event) => Event.fromMap(event)));
    } else {
      print ('Error: ${response.statusCode}');
      return Future.error('Error: ${response.statusCode}');
    }
    return Future.value(events);
  }
  @override
  Future<void> addEventReview(EventReview eventReview) async {
    final request = Uri.parse('$baseUrl/$contractKey/data/event_reviews')
        .resolveUri(Uri(queryParameters: {'format': 'json'}
    ));
    final response = await httpClient.post(request,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(eventReview.toMap()));
    if (response.statusCode != 200) {
      print ('Error: ${response.statusCode}');
      return Future.error('Error: ${response.statusCode}');
    }
  }
  @override
  Future<List<EventReview>> getEventReviews(int eventId) async {
    List<EventReview> reviews = [];
    final request = Uri.parse('$baseUrl/$contractKey/data/event_reviews')
        .resolveUri(Uri(queryParameters: {'format': 'json'}
    ));
    final response = await httpClient.get(request);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      reviews = List<EventReview>.from(data.map((review) => EventReview.fromMap(review)));
    } else {
      print ('Error: ${response.statusCode}');
      return Future.error('Error: ${response.statusCode}');
    }
    return Future.value(reviews);
  }

  @override
Future<List<EventTrack>> getEventTracks() async {
  final request = Uri.parse('$baseUrl/$contractKey/data/event_tracks')
      .resolveUri(Uri(queryParameters: {'format': 'json'}));
  final response = await httpClient.get(request);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body)['data'];
    return List<EventTrack>.from(data.map((e) => EventTrack.fromMap(e)));
  } else {
    throw Exception('Failed to fetch event tracks');
  }
}

@override
Future<void> uploadEvent(Event event) async {
  final request = Uri.parse('$baseUrl/$contractKey/data/events')
      .resolveUri(Uri(queryParameters: {'format': 'json'}));
  final response = await httpClient.post(request,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(event.toMap()));

  if (response.statusCode != 200) {
    throw Exception('Failed to upload event');
  }
}
}