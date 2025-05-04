import '../core/network_info.dart';
import '../datasources/local/i_local_data_source.dart';
import '../datasources/remote/i_remote_data_source.dart';
import '../../models/event.dart';
import '../../models/event_track.dart';
import '../../models/event_review.dart';
import '../../models/subscribed_event.dart';
import 'package:loggy/loggy.dart';



class DataRepository {
  final IRemoteDataSource _remoteDataSource;
  final ILocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  DataRepository(this._remoteDataSource, this._localDataSource, this._networkInfo);
  // Fetch events from remote data source
  Future<List<Event>> fetchEvents() async {
    if (await _networkInfo.isConnected()) {
      logInfo('Fetching events from remote data source');
      final events = await _remoteDataSource.getEvents();
      for (final event in events) {
        await _localDataSource.insertEvent(event);
      }
      return events;
    } else {
      logInfo('Fetching events from local data source');
      return await _localDataSource.getEvents();
    }
  }
}