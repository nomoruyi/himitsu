import 'package:stream_chat_flutter/stream_chat_flutter.dart';

abstract class StreamClientUtil {
  static final StreamChatClient client = StreamChatClient('g5uquupz9smh', logLevel: Level.FINE);

  static ({User user, String token}) j4ckTh3Dr1pper = (
    user: User(id: "J4ckTh3Dr1pper"),
    token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiSjRja1RoM0RyMXBwZXIifQ.-AY912C0_pwn8iq38xgz1DMZa6dZUUt1L_pRjgY8pX8',
  );

  static Future<void> init() async {
    await client.connectUser(j4ckTh3Dr1pper.user, j4ckTh3Dr1pper.token);
  }
}
