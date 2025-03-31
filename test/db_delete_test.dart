import 'package:primerproyectomovil/database/db_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() async {
    // Initialize FFI for SQLite
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('Delete all data and verify database is empty', () async {
    // Delete all data from the database
    await DatabaseHelper.deleteAllData();

    // Fetch all data from the database
    final events = await DatabaseHelper.getEvents();

    // Verify that the database is empty
    expect(events.isEmpty, true);
    print(await DatabaseHelper.getEvents());
  });
}