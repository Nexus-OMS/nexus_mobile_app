part of 'user_bloc.dart';

@immutable
abstract class UserState extends Equatable {
  UserState();
}

class UserStateUninitialized extends UserState {
  @override
  List<Object> get props => ['UserStateUninitialized'];
}

class UserStateLoading extends UserStateHasData {
  UserStateLoading(user) : super(user);
  @override
  List<Object> get props => ['UserStateLoading', user];
}

class UserStateHasData extends UserState {
  final User user;
  UserStateHasData(this.user);
  @override
  List<Object> get props => ['UserStateHasData', user];
}

class UserStateError extends UserState {
  @override
  List<Object> get props => ['UserStateError'];
}
