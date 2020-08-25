part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  AuthenticationState();
}

class AuthenticationStateUninitialized extends AuthenticationState {
  @override
  List<Object> get props => ['AuthenticationStateUninitialized'];
}

class AuthenticationStateInitialized
    extends AuthenticationStateUnauthenticated {
  @override
  List<Object> get props => ['AuthenticationStateUninitialized'];
}

class AuthenticationStateAuthenticated extends AuthenticationState {
  final User user;

  AuthenticationStateAuthenticated(this.user);

  @override
  List<Object> get props => ["AuthenticationStateAuthenticated", user];
}

class AuthenticationStateAuthenticationError
    extends AuthenticationStateInitialized {
  @override
  List<Object> get props => ['AuthenticationStateAuthenticationError'];
}

class AuthenticationStateAuthenticationErrorCleared
    extends AuthenticationStateInitialized {
  @override
  List<Object> get props => ['AuthenticationStateAuthenticationErrorCleared'];
}

class AuthenticationStateAuthenticating extends AuthenticationStateInitialized {
  @override
  List<Object> get props => ['AuthenticationStateAuthenticating'];
}

class AuthenticationStateUnauthenticated extends AuthenticationState {
  @override
  List<Object> get props => ['AuthenticationStateUnauthenticated'];
}
