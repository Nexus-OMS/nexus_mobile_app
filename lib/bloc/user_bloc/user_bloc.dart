import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:nexus_mobile_app/bloc/repositories/organization_repository.dart';
import 'package:nexus_mobile_app/models/models.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  int user_id;
  OrganizationRepository repository;

  UserBloc(this.repository, this.user_id) : super(UserStateUninitialized());

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is UserEventRefresh) {
      yield* _mapRefreshToState(event.completer);
    }
  }

  Stream<UserState> _mapRefreshToState(Completer completer) async* {
    try {
      User user;
      if (state is UserStateHasData) {
        user = (state as UserStateHasData).user;
      }
      yield UserStateLoading(user);
      user = await repository.getUser(user_id);
      completer.complete();
      yield UserStateHasData(user);
    } catch (err, stacktrace) {
      print(err);
      print(stacktrace);
      yield UserStateError();
    }
  }
}
