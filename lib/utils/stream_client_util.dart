import 'package:stream_chat_flutter/stream_chat_flutter.dart';

abstract class StreamClientUtil {
  static final StreamChatClient client = StreamChatClient('g5uquupz9smh', logLevel: Level.FINE);

  static ({User user, String token}) test = (
    user: User(id: "test"),
    token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidGVzdCJ9.ZD8CK3qZ8dtKM35zSTwcGF4sd2U-qgMY8UmCe7R_YC4',
  );

  static Future<void> init() async {
    await client.connectUser(test.user, test.token);
  }
}
