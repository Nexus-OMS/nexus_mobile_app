import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:nexus_mobile_app/bloc/repositories/organization_repository.dart';
import 'package:nexus_mobile_app/models/models.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  OrganizationRepository repository;

  UsersBloc(this.repository) : super(UsersStateUninitialized());

  @override
  UsersState get initialState => UsersStateUninitialized();

  @override
  Stream<UsersState> mapEventToState(
    UsersEvent event,
  ) async* {
    if (event is UsersEventRefresh) {
      yield* _mapRefreshToState(event.completer, event.query);
    } else if (event is UsersEventPage) {
      yield* _mapPageToState(event.query);
    }
  }

  Stream<UsersState> _mapRefreshToState(
      Completer completer, String query) async* {
    try {
      List<User> users;
      if (state is UsersStateHasData) {
        users = (state as UsersStateHasData).users;
      }
      yield UsersStateLoading(users);
      users = await repository.pageUsers(query: query, refresh: true);
      completer.complete();
      yield UsersStateHasData(users);
    } catch (err, stacktrace) {
      print(err);
      print(stacktrace);
      yield UsersStateError();
    }
  }

  Stream<UsersState> _mapPageToState(String query) async* {
    try {
      List<User> users;
      if (state is UsersStateHasData) {
        users = (state as UsersStateHasData).users;
      }
      yield UsersStateLoading(users);
      users = await repository.pageUsers(query: query);
      yield UsersStateHasData(users);
    } catch (err, stacktrace) {
      print(err);
      print(stacktrace);
      yield UsersStateError();
    }
  }
}
