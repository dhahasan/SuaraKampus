abstract class DbHelper {
  static Future<void> initPlatform() async {}
  static Future<String> getDatabasePath(String dbName) async => dbName;
}

