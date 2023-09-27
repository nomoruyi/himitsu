part of 'auth_service.dart';

class HimitsuAuthService implements AuthService {
  final CacheAuthService cacheAuthService;

  HimitsuAuthService._internal(this.cacheAuthService);
  static final HimitsuAuthService instance = HimitsuAuthService._internal(CacheAuthService.instance);

  GraphQLClient client = GraphQLConfig.instance.createClient();

  @override
  Future<void> login({required String? username, required String? password}) async {
    // throw 'Go to Login page';
  }

  @override
  Future<void> logout() async {}
}
