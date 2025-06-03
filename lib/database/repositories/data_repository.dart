import 'package:flutter/cupertino.dart';
import 'package:primerproyectomovil/models/event_track.dart';

import '../core/network_info.dart';
import '../datasources/local/i_local_data_source.dart';
import '../datasources/remote/i_remote_data_source.dart';
import '../datasources/remote/i_remote_api_data_source.dart';
import '../../models/event.dart';
import '../../models/event_review.dart';
import 'package:loggy/loggy.dart';
import '../../utils/config.dart';
import '../../utils/version_storage.dart';

class DataRepository {
  final IRemoteDataSource _remoteDataSource;
  final ILocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  final IRemoteApiDataSource _remoteApiDataSource;
  final VersionStorage _versionStorage;

  DataRepository(this._remoteDataSource, this._localDataSource, this._networkInfo, this._remoteApiDataSource, this._versionStorage);
  // Fetch events from remote data source
  Future<List<Event>> fetchEvents() async {
    final v = await _versionStorage.getLocalVersion();
    debugPrint('Local API version: ${v.version}');
    final remoteVersion = await _remoteApiDataSource.getApiVersion();
    debugPrint('Remote API version: $remoteVersion');
    if (await _networkInfo.isConnected() && remoteVersion > v.version) { // Si hay una conexion a internet
      debugPrint('Fetching events from remote data source');
      await _versionStorage.setLocalVersion(remoteVersion); // Actualizar la version local
      final events = await _remoteDataSource.getEvents();
      for (final event in events) {
        await _localDataSource.insertEvent(event); // Guardar en la base de datos local
      }
      return events;
    } else {
      debugPrint('Fetching events from local data source');
      return await _localDataSource.getEvents();
    }
  }
  Future<void> insertEventReview(EventReview eventReview) async {
    if(await _networkInfo.isConnected()) { // Si hay una conexion a internet y la version remota es mayor
      debugPrint('Inserting event review to remote data source');
      await _remoteDataSource.addEventReview(eventReview); // guardarlo en el remoto
      debugPrint('Event review inserted to remote data source: ${eventReview.toMap()}');
      final eventReviews = await _remoteDataSource.getEventReviews(eventReview.eventId);
      
      for (final eventReview in eventReviews) {
        await _localDataSource.insertEventReview(eventReview); // actualizar el cache local
      }
      final cachedEventReviews = await _localDataSource.getEventReviews(eventReview.eventId);
      for (final eventReview in cachedEventReviews) {
        await _remoteDataSource.addEventReview(eventReview); // guardar cacheados
      }
    } else {
      debugPrint('Inserting event review to local data source');
      await _localDataSource.insertEventReview(eventReview); // guardarlo en el local
    }
  }
  Future<List<EventTrack>> fetchEventTracks() async {
    final v = await _versionStorage.getLocalVersion();
    debugPrint('Local API version: ${v.version}');
    final remoteVersion = await _remoteApiDataSource.getApiVersion();
    debugPrint('Remote API version: $remoteVersion');
    // if (remoteVersion > v.version) {
    //   debugPrint('Updating local API version to $remoteVersion');
    //   await _versionStorage.setLocalVersion(remoteVersion);
    // } else {
    //   debugPrint('Local API version is up to date: ${v.version}');
    // }
    if (await _networkInfo.isConnected() && remoteVersion > v.version ) { // Si hay una conexion a internet
      debugPrint('Fetching event tracks from remote data source');
      await _versionStorage.setLocalVersion(remoteVersion); // Actualizar la version local
      final eventTracks = await _remoteDataSource.getEventTracks();
      for (final eventTrack in eventTracks) {
        await _localDataSource.insertEventTrack(eventTrack); // Guardar en la base de datos local
      }
      return eventTracks;
    } else {
      debugPrint('Fetching event tracks from local data source');
      return await _localDataSource.getEventTracks();
    }
  }
  
}