import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:himitsu_app/backend/auth_service/auth_service.dart';
import 'package:himitsu_app/models/auth_data_model.dart';
import 'package:himitsu_app/utils/utils.export.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

abstract class NotificationUtil {
  static FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  static AndroidNotificationChannel? androidChannel;
  static NotificationDetails? generalNotificationDetails;

  static Future<void> init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    androidChannel = const AndroidNotificationChannel(
      'himitsu_channel_id', // id
      'Himitsu Channel', // title
      description: 'This channel is used for the himitsu chat app.',
      // description
      importance: Importance.max,
      playSound: true,
      showBadge: true,
      enableLights: true,
      enableVibration: true,
      ledColor: Colors.deepPurple,
    );

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('notification_icon');
    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        // null --> IOS Versions < 10 won't receive foreground notifications
        onDidReceiveLocalNotification: null);
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin?.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationSelected, onDidReceiveBackgroundNotificationResponse: onNotificationSelected);
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(androidChannel!.id, androidChannel!.name,
        channelDescription: androidChannel?.description,
        // icon: android.smallIcon,
        importance: androidChannel!.importance,
        priority: Priority.max
        // other properties...
        );
    DarwinNotificationDetails iosDetails = const DarwinNotificationDetails();
    generalNotificationDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await flutterLocalNotificationsPlugin
        ?.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel!);
  }

  static void onNotificationSelected(NotificationResponse response) {
    log.d('PayLoad: ${response.payload}');

    if (response.payload == null) return;

/*    try {
      json.decode(utf8.decode(response.payload!.codeUnits));
    } on FormatException {
      try {
        json.decode(response.payload!);
      } on FormatException {
        throw NetworkUtil('error.http.5xx');
      }
    }*/

    String cleanedString = jsonEncode(response.payload);

    final Map<String, String> data = json.decode(cleanedString);
    handleMessage(RemoteMessage(data: data));
  }

  @pragma('vm:entry-point')
  static void setForegroundNotificationListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log.i('FOREGROUND NOTIFICATION RECEIVED');
      log.i('Message data: ${message.data}');

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.

      // if (!isForCurrentDevice(message)) return;

      await handleMessage(message);
    });
  }

  @pragma('vm:entry-point')
  static void setBackgroundNotificationListener() async {
    // FirebaseMessaging.onBackgroundMessage((message) {});

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      log.i('BACKGROUND NOTIFICATION RECEIVED');
      log.i('Message data: ${message.data}');

      await handleMessage(message);
    });
  }

  @pragma('vm:entry-point')
  static void setTerminatedNotificationListener() async {
    FirebaseMessaging.instance.getInitialMessage().then((initialMessage) async {
      if (initialMessage != null) {
        log.i('TERMINATED NOTIFICATION RECEIVED');
        log.i(initialMessage);

        await handleMessage(initialMessage);
      }
    }).onError((error, stackTrace) {
      throw Exception(stackTrace.toString());
    });
  }

  static Future<void> streamBackgroundHandler(Event event) async {
    log.f('Event type: ${event.type}');

    if (event.type == 'message.new') {
      RemoteMessage message = RemoteMessage(senderId: event.message?.user?.id);
      await handleMessage(message);
    }
  }

  @pragma('vm:entry-point')
  static Future<void> handleMessage(RemoteMessage message) async {
    // await HiveUtil.init();
    // AuthData authData = AuthService.authBox.get(HiveBox.auth.name)!;
    await BuildEnvironment.init(flavor: BuildFlavor.production);

    try {
      // await ClientUtil.persistenceClient.connect(ClientUtil.user.id);

      await ClientUtil.client.connectUser(
        ClientUtil.user,
        ClientUtil.token,
        connectWebSocket: false,
      );

      log.w('MESSAGE RECEIVED');

      final Map<String, dynamic> data = message.data;

      final String messageId = data['id'];

      final GetMessageResponse response = await ClientUtil.client.getMessage(messageId);
      // final String? receiverPublikKey = response.message.user?.extraData['publicKey'] as String?;

      String messageText = response.message.text ?? '';

      /*   if (receiverPublikKey != null) {
      final List<int> deriveKey = await CryptUtil.deriveKey(authData.keyPair!.privateKey, receiverPublikKey);
      messageText = await CryptUtil.decryptMessage(messageText, deriveKey);
    }
*/
      if (flutterLocalNotificationsPlugin == null) {
        await init();
      }

      flutterLocalNotificationsPlugin!.show(
          1, 'Nachricht von ${response.message.user?.name} in ${response.channel?.name}', messageText, generalNotificationDetails,
          payload: messageText);
    } catch (e) {
      log.f(e);
    }
  }

  static bool isForCurrentDevice(RemoteMessage message) {
    AuthData? authData = AuthService.authBox.get(HiveBox.auth.name);
    String? receiverId = message.data['receiver_id'];

    if (authData == null) return false;

    if (receiverId == null || receiverId == ClientUtil.user.id) return true;

    return false;
  }
}

enum DataType { none, incident, building, department, room, device, contact }
