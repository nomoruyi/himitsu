import 'package:himitsu_app/backend/channel_service/_himitsu_channel_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

abstract class ChannelService {
  static final channelBox = Hive.box<Channel>('channel');

  Future<List<User>> getChannels({Filter? filter, List<SortOption>? sort, PaginationParams? pagination}) {
    // TODO: implement getUsers
    throw UnimplementedError();
  }

  Future<void> createChannel(String? name, {required String type, required List<User> users}) async {
    await HimitsuChannelService.instance.createChannel(name, type: type, users: users);
  }
}
