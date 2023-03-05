import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:himitsu_app/backend/auth_service/auth_service.dart';
import 'package:himitsu_app/models/auth_data_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final authBox = Hive.box<AuthData>('auth');
  final HimitsuAuthService authService = HimitsuAuthService.instance;

  AuthBloc() : super(AuthInitial()) {
    on<InitializeApp>(_onInitialization);
    on<VerifyLicense>(_onVerifyLicense);
    on<Login>(_onLogin);
    on<Logout>(_onLogout);
  }

  Future<void> _onInitialization(InitializeApp event, Emitter<AuthState> emit) async {
    AuthData? authData = authBox.get('authData');

    if (authData == null || authData.firstInitialization) {
      authData = AuthData(firstInitialization: true);
      authBox.add(authData);

      emit(ShowIntroductionSlides());
      return;
    }

    if (await InternetConnectionChecker().hasConnection) {
      await authService
          .login(username: authData.username, password: authData.password)
          .then((successful) => emit(StartMainApp()))
          .catchError((error) => emit(ShowLoginView()));
    } else {
      await authService.cacheTourService
          .login(username: authData.username, password: authData.password)
          .then((successful) => emit(StartMainApp()))
          .catchError((error) => emit(ShowLoginView()));
    }
  }

  Future<void> _onLogin(Login event, Emitter<AuthState> emit) async {
    emit(VerifyingLogin());

    if (await InternetConnectionChecker().hasConnection) {
      await authService
          .login(username: event.username, password: event.password)
          .then((successful) => emit(LoginSuccessful()))
          .onError((error, stackTrace) => emit(LoginFailed(errorKey: error.toString())));
    } else {
      await authService.cacheTourService
          .login(username: event.username, password: event.password)
          .then((successful) => emit(LoginSuccessful()))
          .onError((error, stackTrace) => emit(LoginFailed(errorKey: error.toString())));
    }
  }

  Future<void> _onLogout(Logout event, Emitter<AuthState> emit) async {
    if (await InternetConnectionChecker().hasConnection) {
      await authService
          .logout()
          .then((value) => emit(LogoutSuccessful()))
          .onError((error, stackTrace) => emit(LogoutFailed(errorKey: error.toString())));
    } else {
      await authService.cacheTourService
          .logout()
          .then((value) => emit(LogoutSuccessful()))
          .onError((error, stackTrace) => emit(LogoutFailed(errorKey: error.toString())));
    }
  }

  Future<void> _onVerifyLicense(VerifyLicense event, Emitter<AuthState> emit) async {
    emit(VerifyingLicense());

    Future.delayed(const Duration(seconds: 3));

    //TODO: Not yet implemented!
/*
    await authService
        .verifyLicense(license: event.licenseKey)
        .then((successful) => emit(LicenseValid()))
        .catchError((error) => emit(LicenseInvalid()));
*/
  }

  @override
  void onChange(Change<AuthState> change) {
    super.onChange(change);

    debugPrint('AUTH - Current STATE: ${change.currentState}');
    debugPrint('AUTH - Next STATE: ${change.nextState}');
  }

  @override
  void onEvent(AuthEvent event) {
    super.onEvent(event);

    debugPrint('AUTH - EVENT emitted: $event');
  }
}
