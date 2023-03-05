part of 'auth_service.dart';

class HimitsuAuthService implements AuthService {
  final CacheAuthService cacheTourService;

  HimitsuAuthService._internal(this.cacheTourService);
  static final HimitsuAuthService instance = HimitsuAuthService._internal(CacheAuthService.instance);

  @override
  Future<void> login({required String? username, required String? password}) async {}

  @override
  Future<void> logout() async {}
}
