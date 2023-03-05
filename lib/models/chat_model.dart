import 'package:equatable/equatable.dart';
import 'package:himitsu_app/models/user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'chat_model.g.dart';

@HiveType(typeId: 1)
class Chat extends HiveObject with EquatableMixin {
  @HiveField(0)
  String? id;
  @HiveField(1)
  late String title;
  @HiveField(3)
  String? imageUrl;
  @HiveField(4)
  late List<User> members = [];

  Chat({this.id, required this.title, this.imageUrl, this.members = const []});

  Chat.fromMap(Map data) {
    id = data['id'];
    title = data['username'];
    imageUrl = data['imageUrl'];
    members = data['members'] ?? [];
  }

  @override
  List<Object?> get props => [id, title];
}
