import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:himitsu_app/backend/channel_service/_himitsu_channel_service.dart';
import 'package:himitsu_app/utils/stream_client_util.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

part 'channel_event.dart';
part 'channel_state.dart';

class ChannelBloc extends Bloc<ChannelEvent, ChannelState> {
  ChannelBloc() : super(ChannelInitial()) {
    on<CreateChannel>(_onCreateChannel);
  }

  Future<void> _onCreateChannel(CreateChannel event, Emitter<ChannelState> emit) async {
    event.users.add(ClientUtil.currentUser.user);

    await HimitsuChannelService.instance.createChannel(event.name, type: event.multi ? 'multi' : 'single', users: event.users);
  }
}
