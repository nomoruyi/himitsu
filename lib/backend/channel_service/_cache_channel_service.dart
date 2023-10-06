import 'package:himitsu_app/backend/channel_service/channel_service.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class CacheChannelService extends ChannelService {
  CacheChannelService._internal();
  static final CacheChannelService instance = CacheChannelService._internal();

  @override
  Future<List<User>> getChannels({Filter? filter, List<SortOption>? sort, PaginationParams? pagination}) {
    // TODO: implement getUsers
    throw UnimplementedError();
  }

  @override
  Future<void> createChannel(String? name, {required String type, required List<User> users}) {
    // TODO: implement getUsers
    throw UnimplementedError();
  }
}
