import 'package:himitsu_app/backend/user_service/user_service.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class CacheUserService extends UserService {
  CacheUserService._internal();
  static final CacheUserService instance = CacheUserService._internal();

  @override
  Future<List<User>> getUsers({Filter? filter, List<SortOption>? sort, PaginationParams? pagination}) {
    // TODO: implement getUsers
    throw UnimplementedError();
  }

  @override
  Future<User> getUser() {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }
}
