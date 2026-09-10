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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBRW42nBxzlGBNdIuCBZmpCAxUOiGgPpMo',
    appId: '1:294384143330:web:a6d4c3f181677a3b7d87bb',
    messagingSenderId: '294384143330',
    projectId: 'zad-food-rescue',
    authDomain: 'zad-food-rescue.firebaseapp.com',
    storageBucket: 'zad-food-rescue.firebasestorage.app',
    measurementId: 'G-KD7WB2NG2R',
  );
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB4tFb2uJMWZpfmGn0UkCVxEnfREGs4j_o',
    appId: '1:294384143330:android:83ce7243bade656b7d87bb',
    messagingSenderId: '294384143330',
    projectId: 'zad-food-rescue',
    storageBucket: 'zad-food-rescue.firebasestorage.app',
  );
}