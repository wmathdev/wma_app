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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD8MUUVsb9flg_ymZn_GZhE6zeeoeeWBIM',
    appId: '1:890497439317:android:29cce2830eff59c5e8a6dc',
    messagingSenderId: '890497439317',
    projectId: 'wmaappproject',
    databaseURL: 'https://wmaappproject.firebaseio.com',
    storageBucket: 'wmaappproject.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCqOXzwwYNBptUq3HAf2Ka25kYAB5IXdQk',
    appId: '1:890497439317:ios:418e9b494fd4652be8a6dc',
    messagingSenderId: '890497439317',
    projectId: 'wmaappproject',
    databaseURL: 'https://wmaappproject.firebaseio.com',
    storageBucket: 'wmaappproject.appspot.com',
    androidClientId: '890497439317-19e07s2fh5kg04h02vkde7mi2d2dr93e.apps.googleusercontent.com',
    iosClientId: '890497439317-5e6tp60fqa4ltr73o1ans3ta9pjhf7bj.apps.googleusercontent.com',
    iosBundleId: 'th.or.wma.app',
  );
}
