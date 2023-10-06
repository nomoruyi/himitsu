import 'package:himitsu_app/utils/env_util.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

abstract class ClientUtil {
  static final StreamChatClient client = StreamChatClient('g5uquupz9smh', logLevel: Level.FINE);

  static ({User user, String token}) currentUser = (
    user: User(id: 'test', name: 'Test', image: 'https://icons.veryicon.com/png/o/internet--web/prejudice/user-128.png'),
    token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidGVzdCJ9.ZD8CK3qZ8dtKM35zSTwcGF4sd2U-qgMY8UmCe7R_YC4',
  );

  static Future<void> init() async {
    OwnUser user = await client.connectUser(currentUser.user, currentUser.token);

    log.i('User: $user');
  }
}
