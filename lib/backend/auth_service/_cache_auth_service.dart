part of 'auth_service.dart';

// ignore: constant_identifier_names

class CacheAuthService implements AuthService {
  CacheAuthService._internal();
  static final CacheAuthService instance = CacheAuthService._internal();

  @override
  Future<void> login({required String? username, required String? password}) async {}

  @override
  Future<void> logout() async {}
}
