/// AuthenticationEvent's for AuthenticationBloc
abstract class AuthenticationEvent {}

/// Event when app is started
class AppStarted extends AuthenticationEvent {}

/// Event when user is logged in
class LoggedIn extends AuthenticationEvent {}

/// Event when user is logged out
class LoggedOut extends AuthenticationEvent {}
