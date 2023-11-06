import 'package:himitsu_app/models/crypt_model.dart';
import 'package:himitsu_app/utils/utils.export.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

abstract class ClientUtil {
  static final StreamChatClient client = StreamChatClient(env.apiKey, logLevel: Level.FINE);
  // static final StreamChatPersistenceClient persistenceClient = StreamChatPersistenceClient(connectionMode: ConnectionMode.background);

  static OwnUser user = OwnUser(id: 'test', name: 'Test', image: 'https://www.hackerspace-ffm.de/wiki/images/Test-sign_640.png');
  static String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidGVzdCJ9.ZD8CK3qZ8dtKM35zSTwcGF4sd2U-qgMY8UmCe7R_YC4';

  static JSONCryptKeyPair? keyPair;

  @pragma('vm:entry-point')
  static Future<void> init() async {
/*
    AuthData authData = AuthService.authBox.get(HiveBox.auth.name)!;
    authData.keyPair ??= await CryptUtil.generateKeys();
    keyPair ??= authData.keyPair;
*/

    user = await client.connectUser(user, token);
    // OwnUser ownUser = await client.connectUser(user.copyWith(extraData: {'publicKey': keyPair!.publicKey}), token);

/*    authData.user = ownUser;
    authData.token = token;

    await authData.save();*/

    log.t('${user.extraData}   ???? PUBLIC_KEY');
    log.i('User: $user');
  }
}
