import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:himitsu_app/backend/user_service/_himitsu_user_service.dart';
import 'package:himitsu_app/utils/client_util.dart';
import 'package:himitsu_app/utils/env_util.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<AddUser>(_onAddUser);
  }

  Future<void> _onAddUser(AddUser event, Emitter<UserState> emit) async {
    final List<User> users = await HimitsuUserService.instance.getUsers(filter: Filter.equal('id', event.id));

    log.i('Sheeeesh');
    log.i(users);

    if (users.isEmpty) {
      emit(UserNotFound());
      return;
    }

    if (users.first.id == ClientUtil.user.id) {
      //TODO: Logged in user error
      emit(UserNotFound());
      return;
    }

    log.i('LOOOOL');
    emit(UserFound(users.first));
  }
}
