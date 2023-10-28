import 'package:himitsu_app/backend/auth_service/auth_service.dart';
import 'package:himitsu_app/models/auth_data_model.dart';
import 'package:himitsu_app/utils/env_util.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

abstract class ClientUtil {
  static final StreamChatClient client = StreamChatClient(env.apiKey, logLevel: Level.FINE);

  static OwnUser user = OwnUser(
      id: 'test',
      name: 'Test',
      image:
          'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/e0a370c9-0c60-4f12-ad95-cc8a1361e54c/dfnu4li-d05d3bda-da4a-4ecf-86c6-3eed1de6c0b0.jpg/v1/fill/w_1280,h_1280,q_75,strp/queen_of_cats_by_imaginarydawning_dfnu4li-fullview.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MTI4MCIsInBhdGgiOiJcL2ZcL2UwYTM3MGM5LTBjNjAtNGYxMi1hZDk1LWNjOGExMzYxZTU0Y1wvZGZudTRsaS1kMDVkM2JkYS1kYTRhLTRlY2YtODZjNi0zZWVkMWRlNmMwYjAuanBnIiwid2lkdGgiOiI8PTEyODAifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6aW1hZ2Uub3BlcmF0aW9ucyJdfQ.XJliRdVVmmkag5LdnZ4VWULappH471940C9NC8fHyPk');
  static String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidGVzdCJ9.ZD8CK3qZ8dtKM35zSTwcGF4sd2U-qgMY8UmCe7R_YC4';

  static Future<void> init() async {
    OwnUser ownUser = await client.connectUser(user, token);

    user = ownUser;

    AuthData authData = AuthData();

    authData.user = ownUser;
    authData.token = token;

    AuthService.authBox.put('auth', authData);

    log.i('User: $ownUser');
  }
}
