
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
      case TargetPlatform.macOS:
        return macos;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCrQBZGrWPIJkBTV64wXbYoGq6JdNe1hGk',
    appId: '1:452771527674:android:f21ce54489f97efc54c243',      
    messagingSenderId: '452771527674',
    projectId: 'leavemanagementsystem-5dcb0',
    storageBucket: 'leavemanagementsystem-5dcb0.appspot.com',
    authDomain: 'leavemanagementsystem-5dcb0.firebaseapp.com',
    measurementId: 'YOUR_MEASUREMENT_ID_IF_ANY', // optional
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCrQBZGrWPIJkBTV64wXbYoGq6JdNe1hGk',
    appId: '1:452771527674:android:f21ce54489f97efc54c243',           // e.g., "1:123456789:android:abcdef123"
    messagingSenderId: '452771527674',
    projectId: 'leavemanagementsystem-5dcb0',
    storageBucket: 'leavemanagementsystem-5dcb0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY_HERE',
    appId: 'YOUR_IOS_APP_ID_HERE',               // e.g., "1:123456789:ios:abcdef123"
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'leavemanagementsystem-5dcb0',
    storageBucket: 'leavemanagementsystem-5dcb0.appspot.com',
    iosClientId: 'YOUR_IOS_CLIENT_ID_HERE',      // optional
    iosBundleId: 'YOUR_IOS_BUNDLE_ID_HERE',      // optional
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR_MACOS_API_KEY_HERE',
    appId: 'YOUR_MACOS_APP_ID_HERE',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'leavemanagementsystem-5dcb0',
    storageBucket: 'leavemanagementsystem-5dcb0.appspot.com',
  );
}
