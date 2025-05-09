import '../core/network_info.dart';
import '../datasources/local/i_local_data_source.dart';
import '../datasources/remote/i_remote_data_source.dart';
import '../../models/event.dart';
import '../../models/event_review.dart';
import 'package:loggy/loggy.dart';



class DataRepository {
  final IRemoteDataSource _remoteDataSource;
  final ILocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  DataRepository(this._remoteDataSource, this._localDataSource, this._networkInfo);
  // Fetch events from remote data source
  Future<List<Event>> fetchEvents() async {
    if (await _networkInfo.isConnected()) { // Si hay una conexion a internet
      logInfo('Fetching events from remote data source');
      final events = await _remoteDataSource.getEvents();
      for (final event in events) {
        await _localDataSource.insertEvent(event); // Guardar en la base de datos local
      }
      return events;
    } else {
      logInfo('Fetching events from local data source');
      return await _localDataSource.getEvents();
    }
  }
  Future<void> insertEventReview(EventReview eventReview) async {
    if(await _networkInfo.isConnected()) {
      logInfo('Inserting event review to remote data source');
      await _remoteDataSource.addEventReview(eventReview); // guardarlo en el remoto
      final eventReviews = await _remoteDataSource.getEventReviews(eventReview.eventId);
      for (final eventReview in eventReviews) {
        await _localDataSource.insertEventReview(eventReview); // actualizar el cache local
      }
      final cachedEventReviews = await _localDataSource.getEventReviews(eventReview.eventId);
      for (final eventReview in cachedEventReviews) {
        await _remoteDataSource.addEventReview(eventReview); // guardar cacheados
      }
    } else {
      logInfo('Inserting event review to local data source');
      await _localDataSource.insertEventReview(eventReview); // guardarlo en el local
    }
  }
  
}