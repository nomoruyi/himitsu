import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'auth_data_model.g.dart';

@HiveType(typeId: 0)
class AuthData extends HiveObject with EquatableMixin {
  @HiveField(0)
  late bool firstInitialization;
  @HiveField(1)
  late String? username;
  @HiveField(2)
  late String? password;
  @HiveField(3)
  late String? token;

/*
  @HiveField(4)
  late String? androidGoogleMapsKey;
*/

  AuthData({this.firstInitialization = true, this.username, this.password, this.token});

  Map<String, dynamic> toMap() {
    return {
      'firstInitialization': firstInitialization,
      'username': username,
      'password': password,
      'sessionID': token,
    };
  }

  factory AuthData.fromMap(Map<String, dynamic> map) {
    return AuthData(
      firstInitialization: map['firstInitialization'] as bool,
      username: map['username'] as String,
      password: map['password'] as String,
      token: map['sessionID'] as String,
    );
  }

  @override
  List<Object?> get props => [firstInitialization, username];

  AuthData copyWith({bool? firstInitialization, String? licenseKey, String? username, String? password, String? sessionID}) {
    return AuthData(
      firstInitialization: firstInitialization ?? this.firstInitialization,
      username: username ?? this.username,
      password: password ?? this.password,
      token: sessionID ?? this.token,
    );
  }
}
