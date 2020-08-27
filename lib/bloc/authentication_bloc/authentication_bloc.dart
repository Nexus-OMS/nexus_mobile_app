import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:nexus_mobile_app/bloc/repositories/authentication_repository.dart';
import 'package:nexus_mobile_app/models/User.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository repository;

  AuthenticationBloc({@required this.repository})
      : assert(repository != null),
        super(AuthenticationStateUninitialized());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationEventAppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is AuthenticationEventSignOut) {
      yield* _mapLoggedOutToState();
    } else if (event is AuthenticationEventReceivedClient) {
      yield* _mapReceivedClientToState();
    } else if (event is AuthenticationEventSignInCredentials) {
      yield* _mapSignInCredentialsToState(event.username, event.password);
    } else if (event is AuthenticationEventClearError) {
      yield* _mapClearErrorToState();
    } else if (event is AuthenticationEventRefresh) {
      yield* _mapRefreshToState();
    }
  }

  Stream<AuthenticationState> _mapRefreshToState() async* {
    try {
      final user = await repository.refresh();
      if (user != null) {
        yield AuthenticationStateAuthenticated(user);
      }
    } catch (_) {
      yield AuthenticationStateUnauthenticated();
    }
  }

  Stream<AuthenticationState> _mapSignInCredentialsToState(
      String username, String password) async* {
    try {
      yield AuthenticationStateAuthenticating();
      final user = await repository.signIn(username, password);
      if (user != null) {
        yield AuthenticationStateAuthenticated(user);
      } else {
        yield AuthenticationStateAuthenticationError();
      }
    } catch (_) {
      yield AuthenticationStateUnauthenticated();
    }
  }

  Stream<AuthenticationState> _mapReceivedClientToState() async* {
    yield AuthenticationStateInitialized();
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await repository.init();
      if (isSignedIn) {
        final user = repository.user;
        yield AuthenticationStateAuthenticated(user);
      } else {
        yield AuthenticationStateUnauthenticated();
      }
    } catch (_) {
      yield AuthenticationStateUnauthenticated();
    }
  }

  Stream<AuthenticationState> _mapClearErrorToState() async* {
    yield AuthenticationStateAuthenticationErrorCleared();
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    await repository.signOut();
    yield AuthenticationStateUnauthenticated();
  }
}
