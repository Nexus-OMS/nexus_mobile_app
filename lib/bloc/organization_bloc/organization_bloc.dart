import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:nexus_mobile_app/bloc/repositories/organization_repository.dart';
import 'package:nexus_mobile_app/models/models.dart';

part 'organization_event.dart';
part 'organization_state.dart';

class OrganizationBloc extends Bloc<OrganizationEvent, OrganizationState> {
  OrganizationRepository repository;

  OrganizationBloc({@required OrganizationRepository repository})
      : assert(repository != null),
        repository = repository,
        super(OrganizationStateUninitialized());

  @override
  Stream<OrganizationState> mapEventToState(
    OrganizationEvent event,
  ) async* {
    if (event is OrganizationEventRefresh) {
      yield* _mapRefreshToState(event.completer);
    }
  }

  Stream<OrganizationState> _mapRefreshToState(Completer completer) async* {
    repository = OrganizationRepository();
    try {
      yield OrganizationStateLoading(
          repository.units, repository.levels, repository.positions);
      await repository.getUnits();
      await repository.getLevels();
      await repository.getPositions();
      completer.complete();
      yield OrganizationStateHasData(
          repository.units, repository.levels, repository.positions);
    } catch (err, stacktrace) {
      print(err);
      print(stacktrace);
      yield OrganizationStateError();
    }
  }
}
