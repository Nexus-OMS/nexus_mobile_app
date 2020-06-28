part of 'search_bloc.dart';

@immutable
abstract class SearchEvent extends Equatable {
  SearchEvent();
}

class SearchEventRefresh extends SearchEvent {
  final Completer completer;
  final String query;
  SearchEventRefresh(this.completer, this.query);
  @override
  List<Object> get props => ['SearchEventRefresh', query];
}

class SearchEventPage extends SearchEvent {
  final int page;
  final int size;
  final String query;
  SearchEventPage(this.query, {this.page, this.size});
  @override
  List<Object> get props => ['SearchEventPage', page, size, query];
}
