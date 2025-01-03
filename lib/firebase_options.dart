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
    apiKey: 'AIzaSyCVo28v3ND0tJ_Vnzy9uBg70_2UufB2vKE',
    appId: '1:1043268276959:web:9ff3f1232e72d4a73c4f6a',
    messagingSenderId: '1043268276959',
    projectId: 'music-concept-app',
    authDomain: 'music-concept-app.firebaseapp.com',
    databaseURL: 'https://music-concept-app-default-rtdb.firebaseio.com',
    storageBucket: 'music-concept-app.appspot.com',
    measurementId: 'G-P17M5W1ERR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDgNIDi_tiAeVwFNkbH-X9lkFogEb74cGs',
    appId: '1:1043268276959:android:d9aa139060b27ff13c4f6a',
    messagingSenderId: '1043268276959',
    projectId: 'music-concept-app',
    databaseURL: 'https://music-concept-app-default-rtdb.firebaseio.com',
    storageBucket: 'music-concept-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA0tq70Fx8z-h5EqKXtIjvIpIm5IL7XT9w',
    appId: '1:1043268276959:ios:5a27064ce8d672773c4f6a',
    messagingSenderId: '1043268276959',
    projectId: 'music-concept-app',
    databaseURL: 'https://music-concept-app-default-rtdb.firebaseio.com',
    storageBucket: 'music-concept-app.appspot.com',
    iosBundleId: 'com.example.beatconnectApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA0tq70Fx8z-h5EqKXtIjvIpIm5IL7XT9w',
    appId: '1:1043268276959:ios:5a27064ce8d672773c4f6a',
    messagingSenderId: '1043268276959',
    projectId: 'music-concept-app',
    databaseURL: 'https://music-concept-app-default-rtdb.firebaseio.com',
    storageBucket: 'music-concept-app.appspot.com',
    iosBundleId: 'com.example.beatconnectApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCVo28v3ND0tJ_Vnzy9uBg70_2UufB2vKE',
    appId: '1:1043268276959:web:cf8120763a1396013c4f6a',
    messagingSenderId: '1043268276959',
    projectId: 'music-concept-app',
    authDomain: 'music-concept-app.firebaseapp.com',
    databaseURL: 'https://music-concept-app-default-rtdb.firebaseio.com',
    storageBucket: 'music-concept-app.appspot.com',
    measurementId: 'G-E5ZZSQMCF9',
  );
}
