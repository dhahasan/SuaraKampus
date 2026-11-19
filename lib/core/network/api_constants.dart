import 'package:flutter/foundation.dart';

class ApiConstants {
  // PANDUAN BASE URL:
  // 1. Android Emulator: Gunakan 'http://10.0.2.2/suara_kampus_api'
  // 2. Browser (Web) / Windows App: Gunakan 'http://localhost/suara_kampus_api'
  // 3. HP Fisik via Wi-Fi: Ganti dengan IP laptop Anda, misal: 'http://192.168.1.10/suara_kampus_api'
  static String get defaultBaseUrl {
    if (kIsWeb) {
      return 'http://localhost/suara_kampus_api';
    }
    // Jika default target adalah Android Emulator
    return 'http://10.0.2.2/suara_kampus_api';
  }

  // Base URL aktif (bisa diubah saat runtime jika perlu)
  static String baseUrl = defaultBaseUrl;

  // Auth endpoints
  static String get login => '$baseUrl/auth/login.php';
  static String get register => '$baseUrl/auth/register.php';
  static String get verifyKtm => '$baseUrl/auth/verify_ktm.php';

  // Menfess endpoints
  static String get menfess => '$baseUrl/menfess/index.php';
  static String get supportMenfess => '$baseUrl/menfess/support.php';
  static String get moderateMenfess => '$baseUrl/menfess/moderate.php';

  // Reports
  static String get reports => '$baseUrl/reports/index.php';

  // Admin Dispositions
  static String get dispositions => '$baseUrl/dispositions/index.php';

  // Admin Instagram Queue
  static String get instagram => '$baseUrl/instagram/index.php';

  // Admin Analytics
  static String get analytics => '$baseUrl/analytics/index.php';

  // File Upload
  static String get upload => '$baseUrl/upload.php';

  // Ping / Test DB Connection
  static String get test => '$baseUrl/test.php';
}
