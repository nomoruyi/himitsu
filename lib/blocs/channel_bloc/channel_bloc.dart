import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:himitsu_app/backend/channel_service/_himitsu_channel_service.dart';
import 'package:himitsu_app/utils/stream_client_util.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

part 'channel_event.dart';
part 'channel_state.dart';

class HChannelBloc extends Bloc<HChannelEvent, HChannelState> {
  HChannelBloc() : super(ChannelInitial()) {
    on<CreateChannel>(_onCreateChannel);
  }

  Future<void> _onCreateChannel(CreateChannel event, Emitter<HChannelState> emit) async {
    event.users.add(ClientUtil.currentUser.user);

    HimitsuChannelService.instance
        .createChannel(event.name, type: event.type, users: event.users)
        .then((value) => emit(ChannelCreated()))
        .onError((error, stackTrace) => emit(ChannelCreationFailed()));
  }
}
