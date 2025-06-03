import 'package:primerproyectomovil/utils/api_version.dart';

abstract class IRemoteApiDataSource {
  Future<int> getApiVersion();
}