import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:nexus_mobile_app/bloc/repositories/update_repository.dart';
import 'package:nexus_mobile_app/models/Update.dart';

part 'update_event.dart';
part 'update_state.dart';

class UpdateBloc extends Bloc<UpdateEvent, UpdateState> {
  final UpdateRepository _repository;

  UpdateBloc({@required UpdateRepository repository})
      : assert(repository != null),
        _repository = repository;

  @override
  UpdateState get initialState => UpdateStateUninitialized();

  @override
  Stream<UpdateState> mapEventToState(
    UpdateEvent event,
  ) async* {
    if (event is UpdateEventPage) {
      yield* _mapPageToState();
    }
  }

  Stream<UpdateState> _mapPageToState() async* {
    try {
      yield UpdateStateLoading(_repository.updates);
      final updates = await _repository.page();
      if (updates == null || updates.length == 0) {
        yield UpdateStateNoData();
      } else {
        yield UpdateStateHasData(updates);
      }
    } catch (_) {
      yield UpdateStateError();
    }
  }
}
