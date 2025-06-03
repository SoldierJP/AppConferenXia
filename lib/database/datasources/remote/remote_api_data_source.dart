import 'dart:io';
import 'dart:convert';
import 'package:primerproyectomovil/database/datasources/remote/i_remote_api_data_source.dart';
import '../../../utils/api_version.dart';
import '../../../../utils/config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class RemoteApiDataSource implements IRemoteApiDataSource{
    final http.Client httpClient;

    RemoteApiDataSource({http.Client? httpClient})
      : httpClient = httpClient ?? http.Client();


  @override
Future<int> getApiVersion() async {
  final uri = Uri.parse('$baseUrl/$contractKey/data/version/all')
      .replace(queryParameters: {'format': 'json'});
  final response = await httpClient.get(uri);
  if (response.statusCode != 200) {
    throw HttpException('Error ${response.statusCode}');
  }

  final jsonResponse = response.body;
  debugPrint(jsonResponse);

  // 1) Decode top‐level “data” array
  final wrapperList = (jsonDecode(jsonResponse) as Map<String, dynamic>)['data']
      as List<dynamic>;
  debugPrint('getApiversion() → wrapperList: $wrapperList');

  // 2) Build a List<ApiVersion> but skip any nulls
  final List<ApiVersion> dalist = <ApiVersion>[];
  for (final wrapper in wrapperList) {
    final dataMap = (wrapper as Map<String, dynamic>)['data'] as Map<String, dynamic>;

    // Only proceed if version is non‐null and an int
    final dynamic raw = dataMap['version'];
    if (raw is int) {
      dalist.add(ApiVersion(version: raw));
    } else {
      // You can log or ignore
      debugPrint('Skipping null or non-int version: $raw');
    }
  }

  debugPrint('dalist (filtered): $dalist');
  debugPrint('getApiVersion() → parsed ${dalist.length} valid versions');

  // 3) If there are no valid versions, default to 0 (or throw)
  if (dalist.isEmpty) {
    debugPrint('No non-null version found, defaulting to 0');
    return 0;
  }

  // 4) Otherwise, pick the last (or highest) entry
  final int apiVersion = dalist.last.version;
  debugPrint('getApiVersion() → parsed version: $apiVersion');
  return apiVersion;
}
} 