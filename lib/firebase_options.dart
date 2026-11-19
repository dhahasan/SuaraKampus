// File generated for Firebase initialization in SuaraKampus.
// Anda dapat mengganti konfigurasi di bawah ini dengan konfigurasi Firebase Project Anda
// (atau menggunakan FlutterFire CLI: flutterfire configure)

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        return android;
    }
  }

  // Konfigurasi Web

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyANFcfLgSYNAziKX2AcB28tHe-eq9X_YKY',
    appId: '1:260205955090:web:71d9d2f9b776956bad30cb',
    messagingSenderId: '260205955090',
    projectId: 'suara-kampus-c7364',
    authDomain: 'suara-kampus-c7364.firebaseapp.com',
    storageBucket: 'suara-kampus-c7364.firebasestorage.app',
    measurementId: 'G-012DFKX4H7',
  );
  // Konfigurasi Android

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBd_Gx3SoauX11J_xInVCmydnQHGGDjSIE',
    appId: '1:260205955090:android:faf25ebc9cd9bb3ead30cb',
    messagingSenderId: '260205955090',
    projectId: 'suara-kampus-c7364',
    storageBucket: 'suara-kampus-c7364.firebasestorage.app',
  );
  // Konfigurasi iOS
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDemoSuaraKampusIosApiKey12345678901',
    appId: '1:123456789012:ios:demoSuaraKampusIosId',
    messagingSenderId: '123456789012',
    projectId: 'suarakampus-app',
    storageBucket: 'suarakampus-app.appspot.com',
    iosBundleId: 'com.example.suaraKampus',
  );
}
