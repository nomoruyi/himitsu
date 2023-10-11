import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:himitsu_app/backend/auth_service/auth_service.dart';
import 'package:himitsu_app/models/auth_data_model.dart';
import 'package:himitsu_app/utils/client_util.dart';
import 'package:himitsu_app/utils/env_util.dart';
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
        priority: Priority.high
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

  static void setForegroundNotificationListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log.i('FOREGROUND NOTIFICATION RECEIVED');
      log.i('Message data: ${message.data}');

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.

      if (!isForCurrentDevice(message)) return;

      handleMessage(message);
    });
  }

  static void setBackgroundNotificationListener() async {
    // FirebaseMessaging.onBackgroundMessage((message) {});

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log.i('BACKGROUND NOTIFICATION RECEIVED');
      log.i('Message data: ${message.data}');

      handleMessage(message);
    });
  }

  static void setTerminatedNotificationListener() async {
    FirebaseMessaging.instance.getInitialMessage().then((initialMessage) {
      if (initialMessage != null) {
        log.i('TERMINATED NOTIFICATION RECEIVED');
        log.i(initialMessage);

        handleMessage(initialMessage);
      }
    }).onError((error, stackTrace) {
      throw Exception(stackTrace.toString());
    });
  }

  @pragma('vm:entry-point')
  static Future<void> handleMessage(RemoteMessage message) async {
    // String userId = message.data['id'];
    ClientUtil.client.connectUser(
      ClientUtil.currentUser.user,
      ClientUtil.currentUser.token,
      connectWebSocket: false,
    );

    log.w('MESSAGE RECEIVED');

    final Map<String, dynamic> data = message.data;

    final String messageId = data['id'];
    final GetMessageResponse response = await ClientUtil.client.getMessage(messageId);

    if (flutterLocalNotificationsPlugin == null) {
      await init();
    }

    flutterLocalNotificationsPlugin!.show(
        1, 'Nachricht von ${response.message.user?.name} in ${response.channel?.name}', response.message.text, generalNotificationDetails,
        payload: message.data.toString());

    // navigatorKey.currentState?.pushNamed(route, arguments: {'id': int.parse(message.data['id'])});

    // log.d('Push successful');
  }

  static bool isForCurrentDevice(RemoteMessage message) {
    AuthData? authData = AuthService.authBox.get('authData');
    String? receiverId = message.data['receiver_id'];

    if (authData == null) return false;

    if (receiverId == null || receiverId == ClientUtil.currentUser.user.id) return true;

    return false;
  }
}

enum DataType { none, incident, building, department, room, device, contact }
