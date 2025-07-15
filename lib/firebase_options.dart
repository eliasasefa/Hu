// File refactored to use environment variables from .env file.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// NOTE: Ensure dotenv is loaded before using DefaultFirebaseOptions, e.g.:
///   await dotenv.load(fileName: ".env");
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

  static FirebaseOptions get web => FirebaseOptions(
        apiKey: 'your-web-api-key',
        appId: 'your-web-app-id',
        messagingSenderId: 'your-web-messaging-sender-id',
        projectId: 'your-web-project-id',
        authDomain: 'your-web-auth-domain',
        storageBucket: 'your-web-storage-bucket',
      );

  static FirebaseOptions get android => FirebaseOptions(
        apiKey: 'AIzaSyAOWt8-rQdcHLkjfinXfyF-VxgrsFUJ3Tw',
        appId: '1:164188610636:android:c3218e045d5965a4ac14e9',
        messagingSenderId: '164188610636',
        projectId: 'hu-app-b200b',
        storageBucket: 'hu-app-b200b.firebasestorage.app',
      );

  static FirebaseOptions get ios => FirebaseOptions(
        apiKey: 'your-ios-api-key',
        appId: 'your-ios-app-id',
        messagingSenderId: 'your-ios-messaging-sender-id',
        projectId: 'your-ios-project-id',
        storageBucket: 'your-ios-storage-bucket',
        iosBundleId: 'your-ios-bundle-id',
      );

  static FirebaseOptions get macos => FirebaseOptions(
        apiKey: 'your-macos-api-key',
        appId: 'your-macos-app-id',
        messagingSenderId: 'your-macos-messaging-sender-id',
        projectId: 'your-macos-project-id',
        storageBucket: 'your-macos-storage-bucket',
        iosBundleId: 'your-macos-bundle-id',
      );
}
