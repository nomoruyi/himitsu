import 'package:stream_chat_flutter/stream_chat_flutter.dart';

abstract class ChatClientUtil {
  static final StreamChatClient client = StreamChatClient('g5uquupz9smh', logLevel: Level.FINE);

  static ({User user, String token}) currentUser = (
    user: User(id: "j4ck_th3_dr1pper", image: 'https://www.dampfshop4u.de/media/image/3f/47/78/Jack-The-Dripper-Logo.jpg'),
    token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiajRja190aDNfZHIxcHBlciJ9.p-mUWEwQv47ikZU1hCCP5w3C4ydRiQIOcLCGsGk-vkk',
  );

  static Future<void> init() async {
    await client.connectUser(currentUser.user, currentUser.token);
  }
}
