part of 'organization_bloc.dart';

@immutable
abstract class OrganizationState extends Equatable {
  OrganizationState();
}

class OrganizationStateUninitialized extends OrganizationState {
  @override
  List<Object> get props => ['OrganizationStateUninitialized'];
}

class OrganizationStateLoading extends OrganizationStateHasData {
  OrganizationStateLoading(units, levels, positions)
      : super(units, levels, positions);
  @override
  List<Object> get props => ['OrganizationStateLoading', units, levels];
}

class OrganizationStateHasData extends OrganizationState {
  final List<Unit> units;
  final List<Level> levels;
  final Position positions;
  OrganizationStateHasData(this.units, this.levels, this.positions);
  @override
  List<Object> get props => ['OrganizationStateHasData', units, levels];
}

class OrganizationStateNoData extends OrganizationState {
  @override
  List<Object> get props => ['OrganizationStateNoData'];
}

class OrganizationStateError extends OrganizationState {
  @override
  List<Object> get props => ['OrganizationStateError'];
}
