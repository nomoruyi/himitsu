import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class User extends HiveObject with EquatableMixin {
  @HiveField(0)
  int? id;
  @HiveField(1)
  late String username;
  @HiveField(3)
  String? profilePic;
  @HiveField(4)
  String? sessionID;

  User({this.id, required this.username, this.profilePic, this.sessionID});

  User.fromMap(Map data) {
    id = data['id'];
    username = data['username'];
    profilePic = data['profilePic'];
    sessionID = data['sessionID'];
  }

  @override
  List<Object?> get props => [id, username];
}
