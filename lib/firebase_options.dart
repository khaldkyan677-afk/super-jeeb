import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return web;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyARQpdt3TUURGwOEF43I9vbeZRMU0KsaAg',
    appId: '1:595798653741:web:b378c2bee69252bd9331a4',
    messagingSenderId: '595798653741',
    projectId: 'super-jeep',
    authDomain: 'super-jeep.firebaseapp.com',
    storageBucket: 'super-jeep.firebasestorage.app',
    measurementId: 'G-3940JY169N',
  );
}
