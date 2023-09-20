import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:himitsu_app/backend/auth_service/auth_service.dart';
import 'package:himitsu_app/models/auth_data_model.dart';
import 'package:himitsu_app/utils/env_util.dart';

abstract class NotificationUtil {
  static late final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  static late final AndroidNotificationChannel androidChannel;
  static late final NotificationDetails generalNotificationDetails;

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

    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: onNotificationSelected);
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(androidChannel.id, androidChannel.name,
        channelDescription: androidChannel.description,
        // icon: android.smallIcon,
        importance: androidChannel.importance,
        priority: Priority.high
        // other properties...
        );
    DarwinNotificationDetails iosDetails = const DarwinNotificationDetails();
    generalNotificationDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  static onNotificationSelected(NotificationResponse response) {
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

  static setForegroundNotificationListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log.i('FOREGROUND NOTIFICATION RECEIVED');
      log.i('Message data: ${message.data}');

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        if (!isForCurrentDevice(message)) return;

        flutterLocalNotificationsPlugin.show(notification.hashCode, notification.title, notification.body, generalNotificationDetails,
            payload: message.data.toString());
      }
    });
  }

  static setBackgroundNotificationListener() {
    // FirebaseMessaging.onBackgroundMessage((message) {});
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log.i('BACKGROUND NOTIFICATION RECEIVED');
      log.i('Message data: ${message.data}');

      handleMessage(message);
    });
  }

  static setTerminatedNotificationListener() async {
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

  static void handleMessage(RemoteMessage message) {
    // String userId = message.data['id'];
    String? messageType = message.data['type'];
    String? route;

    if (messageType == DataType.incident.name) {
      route = 'incident_details';
    } else if (messageType == DataType.building.name) {
      route = 'building_details';
    } else if (messageType == DataType.department.name) {
      route = 'department_details';
    } else if (messageType == DataType.room.name) {
      route = 'room_details';
    } else if (messageType == DataType.device.name) {
      route = 'device_details';
    }
    if (route == null) return;

    // navigatorKey.currentState?.pushNamed(route, arguments: {'id': int.parse(message.data['id'])});

    // log.d('Push successful');
  }

  static bool isForCurrentDevice(RemoteMessage message) {
    AuthData? authData = AuthService.authBox.get('authData');
    String? userId = message.data['user_id'];

    if (authData == null) return false;

    if (userId == null) return true;

    return true;
  }
}

enum DataType { none, incident, building, department, room, device, contact }
