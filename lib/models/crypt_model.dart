// Model class for storing keys
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'crypt_model.g.dart';

@HiveType(typeId: 2)
class JSONCryptKeyPair extends HiveObject with EquatableMixin {
  @HiveField(0)
  final String privateKey;
  @HiveField(1)
  final String publicKey;

  JSONCryptKeyPair({
    required this.privateKey,
    required this.publicKey,
  });

  JSONCryptKeyPair copyWith({
    String? privateKey,
    String? publicKey,
  }) {
    return JSONCryptKeyPair(
      privateKey: privateKey ?? this.privateKey,
      publicKey: publicKey ?? this.publicKey,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'privateKey': privateKey,
      'publicKey': publicKey,
    };
  }

  factory JSONCryptKeyPair.fromMap(Map<String, dynamic> map) {
    return JSONCryptKeyPair(
      privateKey: map['privateKey'] as String,
      publicKey: map['publicKey'] as String,
    );
  }

  @override
  String toString() {
    return 'JSONCryptKeyPair{ privateKey: $privateKey, publicKey: $publicKey,}';
  }
//</editor-fold>

  @override
  List<Object?> get props => [privateKey, publicKey];
}
