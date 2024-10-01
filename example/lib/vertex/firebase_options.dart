// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB3TveIMpvDTjTCVbE1a1wSFV2AUayyCcM',
    appId: '1:781366022955:web:40744f23b2e8552a8a2b6e',
    messagingSenderId: '781366022955',
    projectId: 'flutter-ai-toolkit-examp-60bad',
    authDomain: 'flutter-ai-toolkit-examp-60bad.firebaseapp.com',
    storageBucket: 'flutter-ai-toolkit-examp-60bad.appspot.com',
    measurementId: 'G-XZD4KTLF12',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAATjXkV6jQQcMmSBTbenqHVO5G05Hh4mQ',
    appId: '1:781366022955:android:69c1f0a8abf5ace68a2b6e',
    messagingSenderId: '781366022955',
    projectId: 'flutter-ai-toolkit-examp-60bad',
    storageBucket: 'flutter-ai-toolkit-examp-60bad.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD7Khtpqmsb340R3kWuj_18hUiGss2fJ3g',
    appId: '1:781366022955:ios:e97ab5c81a8579df8a2b6e',
    messagingSenderId: '781366022955',
    projectId: 'flutter-ai-toolkit-examp-60bad',
    storageBucket: 'flutter-ai-toolkit-examp-60bad.appspot.com',
    iosBundleId: 'com.example.example',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD7Khtpqmsb340R3kWuj_18hUiGss2fJ3g',
    appId: '1:781366022955:ios:e97ab5c81a8579df8a2b6e',
    messagingSenderId: '781366022955',
    projectId: 'flutter-ai-toolkit-examp-60bad',
    storageBucket: 'flutter-ai-toolkit-examp-60bad.appspot.com',
    iosBundleId: 'com.example.example',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB3TveIMpvDTjTCVbE1a1wSFV2AUayyCcM',
    appId: '1:781366022955:web:365be3963f7f5a7e8a2b6e',
    messagingSenderId: '781366022955',
    projectId: 'flutter-ai-toolkit-examp-60bad',
    authDomain: 'flutter-ai-toolkit-examp-60bad.firebaseapp.com',
    storageBucket: 'flutter-ai-toolkit-examp-60bad.appspot.com',
    measurementId: 'G-VR3YZ5WLG3',
  );
}
