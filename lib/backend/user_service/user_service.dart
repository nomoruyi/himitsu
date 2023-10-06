import 'package:hive_flutter/hive_flutter.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

abstract class UserService {
  static final userBox = Hive.box<User>('user');
  Future<List<User>> getUsers({Filter? filter, List<SortOption>? sort, PaginationParams? pagination});
  Future<User> getUser();
  Future<void> logout();
}
