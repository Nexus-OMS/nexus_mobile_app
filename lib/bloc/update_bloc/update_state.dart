part of 'update_bloc.dart';

@immutable
abstract class UpdateState extends Equatable {
  UpdateState();
}

class UpdateStateUninitialized extends UpdateState {
  @override
  List<Object> get props => ['UpdateStateUninitialized'];
}

class UpdateStateLoading extends UpdateState {
  UpdateStateLoading();
  @override
  List<Object> get props => ['UpdateStateLoading'];
}

class UpdateStateHasData extends UpdateState {
  final List<Update> updates;
  UpdateStateHasData(this.updates);
  @override
  List<Object> get props => ['UpdateStateHasData', updates];
}

class UpdateStateNoData extends UpdateState {
  @override
  List<Object> get props => ['UpdateStateNoData'];
}

class UpdateStateError extends UpdateState {
  @override
  List<Object> get props => ['UpdateStateError'];
}
