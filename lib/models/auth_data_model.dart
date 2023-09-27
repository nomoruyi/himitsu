import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'auth_data_model.g.dart';

@HiveType(typeId: 0)
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

  Map<String, dynamic> toMap() {
    return {
      'firstInitialization': firstInitialization,
      'licenseKey': licenseKey,
      'username': username,
      'password': password,
      'sessionID': sessionID,
    };
  }

  factory AuthData.fromMap(Map<String, dynamic> map) {
    return AuthData(
      firstInitialization: map['firstInitialization'] as bool,
      licenseKey: map['licenseKey'] as String,
      username: map['username'] as String,
      password: map['password'] as String,
      sessionID: map['sessionID'] as String,
    );
  }

  @override
  List<Object?> get props => [firstInitialization, username];

  AuthData copyWith({bool? firstInitialization, String? licenseKey, String? username, String? password, String? sessionID}) {
    return AuthData(
      firstInitialization: firstInitialization ?? this.firstInitialization,
      licenseKey: licenseKey ?? this.licenseKey,
      username: username ?? this.username,
      password: password ?? this.password,
      sessionID: sessionID ?? this.sessionID,
    );
  }
}
