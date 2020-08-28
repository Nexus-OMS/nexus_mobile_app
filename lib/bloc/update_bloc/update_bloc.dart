import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:nexus_mobile_app/bloc/repositories/update_repository.dart';
import 'package:nexus_mobile_app/models/update.dart';

part 'update_event.dart';
part 'update_state.dart';

class UpdateBloc extends Bloc<UpdateEvent, UpdateState> {
  UpdateRepository _repository;

  UpdateBloc({@required UpdateRepository repository})
      : assert(repository != null),
        _repository = repository,
        super(UpdateStateUninitialized());

  @override
  Stream<UpdateState> mapEventToState(
    UpdateEvent event,
  ) async* {
    if (event is UpdateEventPage) {
      yield* _mapPageToState();
    } else if (event is UpdateEventRefresh) {
      yield* _mapRefreshToState(event.completer);
    }
  }

  Stream<UpdateState> _mapPageToState() async* {
    try {
      final updates = await _repository.all();
      if (updates == null || updates.isEmpty) {
        yield UpdateStateNoData();
      } else {
        yield UpdateStateHasData(updates);
      }
    } catch (_) {
      yield UpdateStateError();
    }
  }

  Stream<UpdateState> _mapRefreshToState(Completer completer) async* {
    try {
      yield UpdateStateLoading();
      final updates = await _repository.all();
      completer.complete();
      if (updates == null || updates.isEmpty) {
        yield UpdateStateNoData();
      } else {
        yield UpdateStateHasData(updates);
      }
    } catch (_) {
      yield UpdateStateError();
    }
  }
}
