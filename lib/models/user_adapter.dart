import 'package:hive_flutter/hive_flutter.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 1;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as String,
      role: fields[1] as String?,
      name: fields[1] as String?,
      image: fields[3] as String?,
      createdAt: fields[3] as DateTime?,
      updatedAt: fields[3] as DateTime?,
      lastActive: fields[3] as DateTime?,
      extraData: fields[3] as Map<String, Object?>,
      online: fields[3] as bool,
      banExpires: fields[3] as DateTime?,
      teams: fields[3] as List<String>,
      language: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.role)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.lastActive)
      ..writeByte(7)
      ..write(obj.extraData)
      ..writeByte(8)
      ..write(obj.online)
      ..writeByte(9)
      ..write(obj.banExpires)
      ..writeByte(10)
      ..write(obj.teams)
      ..writeByte(11)
      ..write(obj.language);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UserAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
