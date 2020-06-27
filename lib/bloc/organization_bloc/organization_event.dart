part of 'organization_bloc.dart';

@immutable
abstract class OrganizationEvent extends Equatable {
  OrganizationEvent();
}

class OrganizationEventPage extends OrganizationEvent {
  final int page;
  final int size;
  OrganizationEventPage({this.page, this.size});
  @override
  List<Object> get props => ['OrganizationEventPage', page, size];
}

class OrganizationEventRefresh extends OrganizationEvent {
  final Completer completer;
  OrganizationEventRefresh(this.completer);
  @override
  List<Object> get props => ['OrganizationEventRefresh'];
}
