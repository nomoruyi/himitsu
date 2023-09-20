import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:himitsu_app/firebase_options.dart';
import 'package:himitsu_app/utils/env_util.dart';

abstract class FirebaseUtil {
  static Future<String?> init() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      log.i('New App: ${Firebase.apps.last}');
    }

    await FirebaseMessaging.instance.requestPermission(alert: true, announcement: true, badge: true);

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    String? token = await FirebaseMessaging.instance.getToken();
    log.i('Firebase Token: $token');

    return token;
  }
}
