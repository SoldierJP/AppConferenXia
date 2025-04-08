import 'package:primerproyectomovil/database/db_helper.dart';
Future<void> deleteAllData() async {
  await DatabaseHelper.deleteAllData();
}