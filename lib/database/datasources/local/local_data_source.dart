import '../../../models/event.dart';
import '../../../models/event_track.dart';
import '../../../models/event_review.dart';
import 'i_local_data_source.dart';
import '../../../database/db_helper.dart';
import '../../../models/subscribed_event.dart';

class LocalDataSource implements ILocalDataSource{
  @override
  Future<void> insertEvent(Event event) async {
    await DatabaseHelper.insertEvent(event.toMap());
  }
  @override
  Future<List<Event>> getEvents() async {
    final events = await DatabaseHelper.getEvents();
    return events.map((event) => Event.fromMap(event)).toList();
  }
}