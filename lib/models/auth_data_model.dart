import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

part 'auth_data_model.g.dart';

@HiveType(typeId: 0)
class AuthData extends HiveObject with EquatableMixin {
  @HiveField(0)
  late bool firstInitialization;
  @HiveField(1)
  late OwnUser? user;
  @HiveField(3)
  late String? token;

/*
  @HiveField(4)
  late String? androidGoogleMapsKey;
*/

  AuthData({this.firstInitialization = true, this.user, this.token});

  Map<String, dynamic> toMap() {
    return {
      'firstInitialization': firstInitialization,
      'username': user,
      'sessionID': token,
    };
  }

  factory AuthData.fromMap(Map<String, dynamic> map) {
    return AuthData(
      firstInitialization: map['firstInitialization'] as bool,
      user: map['username'] as OwnUser,
      token: map['sessionID'] as String,
    );
  }

  @override
  List<Object?> get props => [firstInitialization, user];

  AuthData copyWith({bool? firstInitialization, String? licenseKey, OwnUser? user, String? password, String? token}) {
    return AuthData(
      firstInitialization: firstInitialization ?? this.firstInitialization,
      user: user ?? this.user,
      token: token ?? this.token,
    );
  }
}
