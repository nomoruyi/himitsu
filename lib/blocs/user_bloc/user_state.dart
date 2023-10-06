part of 'user_bloc.dart';

abstract class UserState {
  const UserState();
}

class UserInitial extends UserState {}

class UserSuccess extends UserState {}

class UserFailed extends UserState {}

class UserFound extends UserSuccess {
  final User user;

  UserFound(this.user);
}

class UsersFound extends UserSuccess {}

class UserNotFound extends UserFailed {}

class MoreThanOneUserFound extends UserFailed {}
