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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'members': members,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'] as String,
      title: map['title'] as String,
      imageUrl: map['imageUrl'] as String,
      members: map['members'] as List<User>,
    );
  }
  @override
  List<Object?> get props => [id, title];
}
