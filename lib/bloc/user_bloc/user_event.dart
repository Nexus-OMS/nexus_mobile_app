part of 'user_bloc.dart';

@immutable
abstract class UserEvent extends Equatable {
  UserEvent();
}

class UserEventRefresh extends UserEvent {
  final Completer completer;
  UserEventRefresh(this.completer);
  @override
  List<Object> get props => ['UserEventRefresh'];
}
