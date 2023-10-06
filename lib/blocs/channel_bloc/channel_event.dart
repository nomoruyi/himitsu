part of 'channel_bloc.dart';

@immutable
abstract class ChannelEvent {}

class CreateChannel extends ChannelEvent {
  final String? name;
  final List<User> users;
  final bool multi;

  CreateChannel(this.name, {this.multi = false, required this.users});
}
