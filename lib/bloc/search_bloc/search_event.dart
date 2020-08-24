part of 'search_bloc.dart';

@immutable
abstract class SearchEvent extends Equatable {
  SearchEvent();
}

class SearchEventRefresh extends SearchEvent {
  final String query;
  SearchEventRefresh(this.query);
  @override
  List<Object> get props => ['SearchEventRefresh', query];
}
