import 'package:equatable/equatable.dart';

/// AuthenticationEvent's for AuthenticationBloc
abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

/// Event when app is started
class AppStarted extends AuthenticationEvent {}

/// Event when user is logged in
class LoggedIn extends AuthenticationEvent {}

/// Event when user is logged out
class LoggedOut extends AuthenticationEvent {}
