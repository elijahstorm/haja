import 'package:firebase_core/firebase_core.dart';

import 'options.dart';

class FirebaseApi {
  static bool disabled = false;

  static Future<FirebaseApp> init() {
    return Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
