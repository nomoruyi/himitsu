part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {}

class InitializeApp extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class Login extends AuthEvent {
  final String username;
  final String password;

  Login({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}

class Logout extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class Register extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class VerifyLicense extends AuthEvent {
  final String licenseKey;

  VerifyLicense(this.licenseKey);
  @override
  List<Object?> get props => [licenseKey];
}
