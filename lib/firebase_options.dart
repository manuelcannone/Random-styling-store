// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAndh8ME-DfS8HF7GYBixoiiSwaMZQmDKM',
    appId: '1:867988786644:web:3f5a9e2d6a16f5ab815a41',
    messagingSenderId: '867988786644',
    projectId: 'randomstylingstore-d0bf7',
    authDomain: 'randomstylingstore-d0bf7.firebaseapp.com',
    storageBucket: 'randomstylingstore-d0bf7.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBVP6XSxFb7AKQtD1eKiPSC_QVODd8Sh64',
    appId: '1:867988786644:android:b593eec86fa3d28e815a41',
    messagingSenderId: '867988786644',
    projectId: 'randomstylingstore-d0bf7',
    storageBucket: 'randomstylingstore-d0bf7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDGTHp6XoD4tHooznGuyWyeJzQgTf4m4SM',
    appId: '1:867988786644:ios:09ef6255f7fa51e1815a41',
    messagingSenderId: '867988786644',
    projectId: 'randomstylingstore-d0bf7',
    storageBucket: 'randomstylingstore-d0bf7.appspot.com',
    iosClientId: '867988786644-82q84krpbce8d86vtu8gi4blnm02lnaf.apps.googleusercontent.com',
    iosBundleId: 'com.example.randomstylingstore',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDGTHp6XoD4tHooznGuyWyeJzQgTf4m4SM',
    appId: '1:867988786644:ios:09ef6255f7fa51e1815a41',
    messagingSenderId: '867988786644',
    projectId: 'randomstylingstore-d0bf7',
    storageBucket: 'randomstylingstore-d0bf7.appspot.com',
    iosClientId: '867988786644-82q84krpbce8d86vtu8gi4blnm02lnaf.apps.googleusercontent.com',
    iosBundleId: 'com.example.randomstylingstore',
  );
}
