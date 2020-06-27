part of 'update_bloc.dart';

@immutable
abstract class UpdateEvent extends Equatable {
  UpdateEvent();
}

class UpdateEventPage extends UpdateEvent {
  final int page;
  final int size;
  UpdateEventPage({this.page, this.size});
  @override
  List<Object> get props => ['UpdateEventPage', page, size];
}

class UpdateEventRefresh extends UpdateEvent {
  final Completer completer;
  UpdateEventRefresh(this.completer);
  @override
  List<Object> get props => ['UpdateEventRefresh'];
}
