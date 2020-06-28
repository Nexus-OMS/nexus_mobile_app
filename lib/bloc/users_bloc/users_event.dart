part of 'users_bloc.dart';

@immutable
abstract class UsersEvent extends Equatable {
  UsersEvent();
}

class UsersEventRefresh extends UsersEvent {
  final Completer completer;
  final String query;
  UsersEventRefresh(this.completer, this.query);
  @override
  List<Object> get props => ['UsersEventRefresh', query];
}

class UsersEventPage extends UsersEvent {
  final int page;
  final int size;
  final String query;
  UsersEventPage(this.query, {this.page, this.size});
  @override
  List<Object> get props => ['UsersEventPage', page, size, query];
}
