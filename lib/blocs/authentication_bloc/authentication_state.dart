import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// AuthenticationState for AuthenticationBloc
abstract class AuthenticationState extends Equatable {
  /// Abstract constructor for AuthenticationState
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

/// Represents an Uninitialized AuthenticationState
class Uninitialized extends AuthenticationState {}

/// Represents an Authorized (logged in) AuthenticationState
class Authenticated extends AuthenticationState {
  /// FirebaseUser object available when logged in
  final FirebaseUser user;

  /// Authenticated constructor
  const Authenticated(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'Authenticated { user : $user }';
}

/// Represents an Unauthenticated state
class Unauthenticated extends AuthenticationState {}
