part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {}

class AuthInitial extends AuthState {
  @override
  List<Object?> get props => [];
}

class InitializationState extends AuthState {
  @override
  List<Object?> get props => [];
}

class ShowIntroductionSlides extends InitializationState {}

class ShowLicenseView extends InitializationState {}

class ShowLoginView extends InitializationState {}

class StartMainApp extends InitializationState {}

class LoginState extends AuthState {
  @override
  List<Object?> get props => [];
}

class VerifyingLogin extends LoginState {}

class LoginSuccessful extends LoginState {}

class LoginFailed extends LoginState {
  final String errorKey;

  LoginFailed({required this.errorKey});

  @override
  List<Object?> get props => [errorKey];
}

class LogoutSuccessful extends LoginState {}

class LogoutFailed extends LoginState {
  final String errorKey;

  LogoutFailed({required this.errorKey});

  @override
  List<Object?> get props => [errorKey];
}

class LicenseState extends AuthState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class VerifyingLicense extends LicenseState {
  VerifyingLicense();
}

class LicenseValid extends LicenseState {
  LicenseValid();
}

class LicenseInvalid extends LicenseState {
  LicenseInvalid();
}
