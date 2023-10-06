import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class CacheUserService {
  CacheUserService._internal();
  static final CacheUserService instance = CacheUserService._internal();

  Future<List<User>> getUsers({Filter? filter, List<SortOption>? sort, PaginationParams? pagination}) {
    // TODO: implement getUsers
    throw UnimplementedError();
  }

  Future<User> getUser() {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }
}
