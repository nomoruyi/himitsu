import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class UserService {
  static final userBox = Hive.box<User>('user');
  Future<List<User>> getUsers();
  Future<void> logout();
}
