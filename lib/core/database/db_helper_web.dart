import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

abstract class DbHelper {
  static Future<void> initPlatform() async {
    databaseFactory = databaseFactoryFfiWeb;
  }

  static Future<String> getDatabasePath(String dbName) async {
    return dbName;
  }
}

