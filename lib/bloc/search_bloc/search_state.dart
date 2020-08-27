part of 'search_bloc.dart';

@immutable
abstract class SearchState extends Equatable {
  SearchState();
}

class SearchStateUninitialized extends SearchState {
  @override
  List<Object> get props => ['SearchStateUninitialized'];
}

class SearchStateLoading extends SearchState {
  @override
  List<Object> get props => ['SearchStateLoading'];
}

class SearchStateHasData extends SearchState {
  final List<User> users;
  final List<Update> updates;
  SearchStateHasData(this.users, this.updates);
  @override
  List<Object> get props => ['SearchStateHasData', users, updates];
}

class SearchStateError extends SearchState {
  @override
  List<Object> get props => ['SearchStateError'];
}
