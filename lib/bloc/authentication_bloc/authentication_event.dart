part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  AuthenticationEvent();
}

class AuthenticationEventAppStarted extends AuthenticationEvent {
  @override
  List<Object> get props => ['AppStarted'];
}

class AuthenticationEventReceivedClient extends AuthenticationEvent {
  @override
  List<Object> get props => ['AppStarted'];
}

class AuthenticationEventSignInCredentials extends AuthenticationEvent {
  final String username;
  final String password;
  AuthenticationEventSignInCredentials(this.username, this.password);
  @override
  List<Object> get props => ['SignInGoogle', username, password];
}

class AuthenticationEventSignOut extends AuthenticationEvent {
  @override
  List<Object> get props => ['SignOut'];
}

class AuthenticationEventClearError extends AuthenticationEvent {
  @override
  List<Object> get props => ['AuthenticationEventClearError'];
}
