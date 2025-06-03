import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import './api_version.dart';

class VersionStorage {
  static const _prefsKey = 'local_api_version_json';

  /// Reads the stored ApiVersion from SharedPreferences.
  /// If nothing is stored, returns ApiVersion(version: 0).
  Future<ApiVersion> getLocalVersion() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_prefsKey);
    if (jsonString == null) {
      // No version saved yet → default to version 0
      return ApiVersion(version: 0);
    }

    try {
      final Map<String, dynamic> map =
          jsonDecode(jsonString) as Map<String, dynamic>;
      return ApiVersion.fromJson(map);
    } catch (e) {
      // If parsing fails for any reason, fall back to version 0
      return ApiVersion(version: 0);
    }
  }

  /// Writes [apiVersion] into SharedPreferences as a JSON string.
 Future<void> setLocalVersion(int versionInt) async {
    final prefs = await SharedPreferences.getInstance();
    final toStore = ApiVersion(version: versionInt);
    final jsonString = jsonEncode(toStore.toJson());
    await prefs.setString(_prefsKey, jsonString);
  }
}
