part of 'auth_service.dart';

class HimitsuAuthService implements AuthService {
  final CacheAuthService cacheTourService;

  HimitsuAuthService._internal(this.cacheTourService);
  static final HimitsuAuthService instance = HimitsuAuthService._internal(CacheAuthService.instance);

  @override
  Future<void> login({required String? username, required String? password}) async {
    throw 'Go to Login page';
  }

  @override
  Future<void> logout() async {}
}
