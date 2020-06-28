part of 'search_bloc.dart';

@immutable
abstract class SearchState extends Equatable {
  SearchState();
}

class SearchStateUninitialized extends SearchState {
  @override
  List<Object> get props => ['SearchStateUninitialized'];
}

class SearchStateLoading extends SearchStateHasData {
  SearchStateLoading(results) : super(results);
  @override
  List<Object> get props => ['SearchStateLoading', results];
}

class SearchStateHasData extends SearchState {
  final List results;
  SearchStateHasData(this.results);
  List<Object> get props => ['SearchStateHasData', results];
}

class SearchStateError extends SearchState {
  @override
  List<Object> get props => ['SearchStateError'];
}
