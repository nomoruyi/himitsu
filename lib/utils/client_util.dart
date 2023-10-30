import 'package:himitsu_app/backend/auth_service/auth_service.dart';
import 'package:himitsu_app/models/auth_data_model.dart';
import 'package:himitsu_app/models/crypt_model.dart';
import 'package:himitsu_app/utils/utils.export.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

abstract class ClientUtil {
  static final StreamChatClient client = StreamChatClient(env.apiKey, logLevel: Level.FINE);

  static OwnUser user = OwnUser(id: 'test', name: 'Test', image: 'https://www.bleepstatic.com/content/hl-images/2022/09/30/cyber-hacker.jpg');
  static String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidGVzdCJ9.ZD8CK3qZ8dtKM35zSTwcGF4sd2U-qgMY8UmCe7R_YC4';

  static JSONCryptKeyPair? keyPair;

  static Future<void> init() async {
    AuthData authData = AuthService.authBox.get(HiveBox.auth.name)!;
    authData.keyPair ??= await CryptUtil.generateKeys();
    keyPair ??= authData.keyPair;

    OwnUser ownUser = await client.connectUser(user.copyWith(extraData: {'publicKey': keyPair!.publicKey}), token);
    user = ownUser;

    authData.user = ownUser;
    authData.token = token;

    await authData.save();

    log.t('${user.extraData}   ???? PUBLIC_KEY');
    log.i('User: $ownUser');
  }
}
