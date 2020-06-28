part of 'users_bloc.dart';

@immutable
abstract class UsersState extends Equatable {
  UsersState();
}

class UsersStateUninitialized extends UsersState {
  @override
  List<Object> get props => ['UsersStateUninitialized'];
}

class UsersStateLoading extends UsersStateHasData {
  UsersStateLoading(users) : super(users);
  @override
  List<Object> get props => ['UsersStateLoading', users];
}

class UsersStateHasData extends UsersState {
  final List<User> users;
  UsersStateHasData(this.users);
  List<Object> get props => ['UsersStateHasData', users];
}

class UsersStateError extends UsersState {
  @override
  List<Object> get props => ['UsersStateError'];
}
