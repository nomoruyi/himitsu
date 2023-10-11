part of 'channel_bloc.dart';

@immutable
abstract class HChannelEvent {}

class CreateChannel extends HChannelEvent {
  final String? name;
  final List<User> users;
  final String type;

  CreateChannel(this.name, this.type, {required this.users});
}
