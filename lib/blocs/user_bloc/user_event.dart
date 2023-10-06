part of 'user_bloc.dart';

abstract class UserEvent {}

class AddUser extends UserEvent {
  final String id;

  AddUser({required this.id});
}
