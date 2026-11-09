import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

abstract class DbHelper {
  static Future<void> initPlatform() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

  static Future<String> getDatabasePath(String dbName) async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      try {
        final docDir = await getApplicationDocumentsDirectory();
        final dbPath = p.join(docDir.path, 'SuaraKampus', dbName);
        final dir = Directory(p.dirname(dbPath));
        if (!await dir.exists()) {
          await dir.create(recursive: true);
        }
        return dbPath;
      } catch (_) {
        final fallbackDir = Directory(p.join(Directory.current.path, '.dart_tool'));
        if (!await fallbackDir.exists()) {
          await fallbackDir.create(recursive: true);
        }
        return p.join(fallbackDir.path, dbName);
      }
    } else {
      final databasesPath = await getDatabasesPath();
      return p.join(databasesPath, dbName);
    }
  }
}

