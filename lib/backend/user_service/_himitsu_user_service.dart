import 'package:himitsu_app/backend/user_service/_cache_user_service.dart';
import 'package:himitsu_app/backend/user_service/user_service.dart';
import 'package:himitsu_app/utils/stream_client_util.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class HimitsuUserService implements UserService {
  final CacheUserService cacheUserService;

  HimitsuUserService._internal(this.cacheUserService);
  static final HimitsuUserService instance = HimitsuUserService._internal(CacheUserService.instance);

  @override
  Future<List<User>> getUsers({Filter? filter, List<SortOption>? sort, PaginationParams? pagination}) async {
    final QueryUsersResponse result = await ClientUtil.client.queryUsers(
      filter: filter,
      sort: sort ?? const [SortOption('id')],
      pagination: pagination ?? const PaginationParams(offset: 0, limit: 20),
    );

    return result.users;
  }

  @override
  Future<User> getUser() async {
    return User(id: '');
  }

  @override
  Future<void> logout() async {}
}
