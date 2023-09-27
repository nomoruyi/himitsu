// ignore_for_file: constant_identifier_names

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:himitsu_app/backend/graphql_config.dart';
import 'package:himitsu_app/models/auth_data_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

part '_cache_auth_service.dart';
part '_himitsu_auth_service.dart';

enum ResponseResult { no_such_user, wrong_password, ok, relogon, logout_ok }

abstract class AuthService {
  static final authBox = Hive.box<AuthData>('auth');
  Future<void> login({required String? username, required String? password});
  Future<void> logout();
}
