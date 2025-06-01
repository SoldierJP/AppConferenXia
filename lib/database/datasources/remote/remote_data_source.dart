import '../../../../../models/event.dart';
import '../../../../../models/event_track.dart';
import '../../../../../models/event_review.dart';
import 'i_remote_data_source.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';


class RemoteDataSource implements IRemoteDataSource{
  final http.Client httpClient;

  final String contractKey = 'kdkja-4bb8-a532-6aaa5fddefa4';

  final String baseUrl = 'https://unidb.openlab.uninorte.edu.co';

  RemoteDataSource({http.Client? httpClient})
      : httpClient = httpClient ?? http.Client();


  @override
 Future<List<Event>> getEvents() async {
  final uri = Uri.parse('$baseUrl/$contractKey/data/events/all')
      .replace(queryParameters: {'format': 'json'});
  final response = await httpClient.get(uri);
  debugPrint('getEvents() → status: ${response.statusCode}');
  debugPrint('getEvents() → body: ${response.body}');

  if (response.statusCode != 200) {
    throw Exception('Error ${response.statusCode}');
  }

  final wrapperList = (jsonDecode(response.body) as Map<String, dynamic>)['data']
      as List<dynamic>;
  debugPrint('getEvents() → wrapperList: $wrapperList');

  // 🔍 Wrap mapping in try/catch to see error
  late List<Event> events;
  try {
    events = wrapperList.map((wrapper) {
      final dataMap = (wrapper as Map<String, dynamic>)['data']
          as Map<String, dynamic>;
      return Event.fromMap(dataMap);
    }).toList();
  } catch (e, st) {
    debugPrint('⚠️ Error while parsing events: $e');
    debugPrint('Stacktrace:\n$st');
    rethrow;
  }

  debugPrint('getEvents() → parsed ${events.length} events');
  debugPrint('getEvents() → final events: $events');
  return events;
}
  @override
  Future<List<EventTrack>> getEventTracks() async {
    List<EventTrack> tracks = [];
    final request = Uri.parse('$baseUrl/$contractKey/data/event_tracks/all')
        .resolveUri(Uri(queryParameters: {'format': 'json'}
    ));
    final response = await httpClient.get(request);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      print('Event tracks data: $data');
      final List<Map<String, dynamic>> onlyData = data
    .map<Map<String, dynamic>>((dynamic item) {
      // `item` is dynamic, but we know it has a Map under the 'data' key
      final dataMap = item['data'] as Map<String, dynamic>;
      return dataMap;
    })
    .toList();
      print('Track data: $onlyData');
      tracks = List<EventTrack>.from(onlyData.map((track) => EventTrack.fromMap(track)));
    } else {
      print ('Error: ${response.statusCode}');
      print ('Body: ${response.body}');
      return Future.error('Error: ${response.statusCode}');
    }
    return Future.value(tracks);
}
  @override
  Future<void> addEventReview(EventReview eventReview) async {
    final request = Uri.parse('$baseUrl/$contractKey/data/store')
        .resolveUri(Uri(queryParameters: {'format': 'json'}
    ));
    final response = await httpClient.post(request,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'table_name': 'event_reviews',
          'data': eventReview.toMap()}));
    if (response.statusCode != 200) {
      print ('Error: ${response.statusCode}');
      print ('Body: ${response.body}');
      return Future.error('Error: ${response.body}');
    }
  }
  @override
  Future<List<EventReview>> getEventReviews(int eventId) async {
    print('Fetching reviews for event ID: $eventId');
    List<EventReview> reviews = [];
    final request = Uri.parse('$baseUrl/$contractKey/data/event_reviews/all?format=json&event_id=$eventId')
        .resolveUri(Uri(queryParameters: {'format': 'json'}
    ));
    final response = await httpClient.get(request);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      final List<Map<String, dynamic>> onlyData = data
    .map<Map<String, dynamic>>((dynamic item) {
      // `item` is dynamic, but we know it has a Map under the 'data' key
      final dataMap = item['data'] as Map<String, dynamic>;
      return dataMap;
    })
    .toList();
      print('Reviews data: $onlyData');
      reviews = List<EventReview>.from(onlyData.map((review) => EventReview.fromMap(review)));
    } else {
      print ('Error: ${response.statusCode}');
      print ('Body: ${response.body}');
      return Future.error('Error: ${response.statusCode}');
    }
    return Future.value(reviews);
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