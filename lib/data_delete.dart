import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'database/db_helper.dart';
Future<void> deleteDatabaseFile() async {
  String dbPath = await getDatabasesPath();
  String path = join(dbPath, 'events.db');

  if (await File(path).exists()) {
    await deleteDatabase(path); // This also closes any open DB connections
    print('Database deleted');
  } else {
    print('Database file does not exist');
  }
} 
Future<void>deleteAllData() async {
  await DatabaseHelper.deleteAllData();
}