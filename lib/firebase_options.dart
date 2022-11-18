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
    apiKey: 'AIzaSyA9DWhLL5zqIiva49iJ6TXot-m6HzllZPs',
    appId: '1:736806620309:web:b16788cb14eb5372421f9c',
    messagingSenderId: '736806620309',
    projectId: 'whatsforlunch-621ad',
    authDomain: 'whatsforlunch-621ad.firebaseapp.com',
    storageBucket: 'whatsforlunch-621ad.appspot.com',
    measurementId: 'G-9XMQ9C6JTS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAc6kpKPYe73yrxe3_4yAgUc-II6gxJ2a8',
    appId: '1:736806620309:android:6c2b3e683aaf145c421f9c',
    messagingSenderId: '736806620309',
    projectId: 'whatsforlunch-621ad',
    storageBucket: 'whatsforlunch-621ad.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA8gz_m3reeU0ukebsHA2nTHzlowvKv-Jg',
    appId: '1:736806620309:ios:484a12736a15783e421f9c',
    messagingSenderId: '736806620309',
    projectId: 'whatsforlunch-621ad',
    storageBucket: 'whatsforlunch-621ad.appspot.com',
    iosClientId: '736806620309-1kuj3669psd7rs9vnl3k1vdsr8ef1elm.apps.googleusercontent.com',
    iosBundleId: 'com.example.whatsForLunch',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA8gz_m3reeU0ukebsHA2nTHzlowvKv-Jg',
    appId: '1:736806620309:ios:484a12736a15783e421f9c',
    messagingSenderId: '736806620309',
    projectId: 'whatsforlunch-621ad',
    storageBucket: 'whatsforlunch-621ad.appspot.com',
    iosClientId: '736806620309-1kuj3669psd7rs9vnl3k1vdsr8ef1elm.apps.googleusercontent.com',
    iosBundleId: 'com.example.whatsForLunch',
  );
}
