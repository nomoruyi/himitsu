import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:himitsu_app/firebase_options.dart';
import 'package:himitsu_app/utils/env_util.dart';
import 'package:himitsu_app/utils/notification_util.dart';
import 'package:himitsu_app/utils/stream_client_util.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

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

    if (token == null) throw Exception('Missing Firebase Token!');

    EmptyResponse emptyResponse = await ClientUtil.client.addDevice(token, PushProvider.firebase, pushProviderName: 'himitsu-firebase');

    FirebaseMessaging.onBackgroundMessage(NotificationUtil.handleMessage);

    log.i('Token saved: ${emptyResponse.duration}');

/*    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      log.i('New Token: $token');
      ChatClientUtil.client.addDevice(token, PushProvider.firebase, pushProviderName: 'himitsu-firebase');
    });*/

    return token;
  }
}
