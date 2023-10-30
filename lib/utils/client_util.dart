import 'package:himitsu_app/models/crypt_model.dart';
import 'package:himitsu_app/utils/crypt_util.dart';
import 'package:himitsu_app/utils/env_util.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

abstract class ClientUtil {
  static final StreamChatClient client = StreamChatClient(env.apiKey, logLevel: Level.FINE);

  static User user = User(id: 'test', name: 'Test', image: 'https://www.hackerspace-ffm.de/wiki/images/Test-sign_640.png');
  static String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidGVzdCJ9.ZD8CK3qZ8dtKM35zSTwcGF4sd2U-qgMY8UmCe7R_YC4';

  static JSONCryptKeyPair? keyPair;

  static Future<void> init() async {
    keyPair ??= await CryptUtil.generateKeys();

    OwnUser ownUser = await client.connectUser(user.copyWith(extraData: {'publicKey': keyPair!.publicKey}), token);

    user = ownUser;

    log.t('${user.extraData}   ???? PUBLIC_KEY');
    log.i('User: $ownUser');
/*
    AuthData authData = AuthData();

    authData.keyPair = keyPair;
    authData.user = ownUser;
    authData.token = token;

    await AuthService.authBox.put('auth', authData);
*/
  }
}
