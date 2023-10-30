import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:himitsu_app/models/auth_data_model.dart';
import 'package:himitsu_app/models/crypt_model.dart';
import 'package:himitsu_app/models/user_adapter.dart';
import 'package:himitsu_app/utils/settings_util.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

abstract class HiveUtil {
  static Future<void> init() async {
    await Hive.initFlutter();
    await initHiveForFlutter();

/*
  await Hive.openBox<SettingsData>('settings');
  Hive.registerAdapter(SettingsDataAdapter());
*/
    final settings = await Hive.openBox('settings');

    if (settings.isEmpty) {
      settings.put('language', 'de');
      settings.put('size', UIType.standard.name);
      settings.put('theme', ThemeMode.system.name);
      settings.put('useSystemTheme', true);
    }

    Hive.registerAdapter(JSONCryptKeyPairAdapter());
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(AuthDataAdapter());
    // Hive.registerAdapter(UserAdapter());

    await Hive.openBox<JSONCryptKeyPair>('crypt');
    await Hive.openBox<User>('user');
    await Hive.openBox<AuthData>('auth');
  }
}
