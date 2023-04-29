import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 2)
class Message extends HiveObject with EquatableMixin {
  @HiveField(0)
  String? id;
  @HiveField(1)
  late String text;

  Message({
    this.id,
    required this.text,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] as String,
      text: map['text'] as String,
    );
  }

  Message copyWith({
    String? id,
    String? text,
  }) {
    return Message(
      id: id ?? this.id,
      text: text ?? this.text,
    );
  }

  @override
  List<Object?> get props => [id];
}
