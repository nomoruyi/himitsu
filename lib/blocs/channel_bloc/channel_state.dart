part of 'channel_bloc.dart';

@immutable
abstract class HChannelState {}

class ChannelInitial extends HChannelState {}

class ChannelSuccess extends HChannelState {}

class ChannelFailed extends HChannelState {}

class ChannelCreated extends ChannelSuccess {}

class ChannelCreationFailed extends ChannelFailed {}
