import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'auth_data_model.g.dart';

@HiveType(typeId: 1)
class AuthData extends HiveObject with EquatableMixin {
  @HiveField(0)
  late bool firstInitialization;
  @HiveField(1)
  late String? licenseKey;
  @HiveField(2)
  late String? username;
  @HiveField(3)
  late String? password;
  @HiveField(4)
  late String? sessionID;
/*
  @HiveField(4)
  late String? androidGoogleMapsKey;
*/

  AuthData({this.firstInitialization = true, this.licenseKey, this.username, this.password, this.sessionID});

  @override
  // TODO: implement props
  List<Object?> get props => [firstInitialization, username];

/*
  static deleteToken() async {
    this.delete()
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('idToken', token);
  }
*/
}
