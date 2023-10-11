import 'package:himitsu_app/backend/channel_service/_cache_channel_service.dart';
import 'package:himitsu_app/backend/channel_service/channel_service.dart';
import 'package:himitsu_app/utils/client_util.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class HimitsuChannelService implements ChannelService {
  final CacheChannelService cacheChannelService;

  HimitsuChannelService._internal(this.cacheChannelService);
  static final HimitsuChannelService instance = HimitsuChannelService._internal(CacheChannelService.instance);

  @override
  Future<List<User>> getChannels({Filter? filter, List<SortOption>? sort, PaginationParams? pagination}) async {
    // TODO: implement getUsers
    throw UnimplementedError();
  }

  @override
  Future<void> createChannel(String? name, {required String type, required List<User> users}) async {
    List<String> memberIds = users.map((user) => user.id).toList();

    final Map<String, dynamic> channelData = {'members': memberIds};

    if (type == 'multi') {
      channelData['name'] = name;
    }

    ClientUtil.client.createChannel(type, channelData: channelData);
  }
}
