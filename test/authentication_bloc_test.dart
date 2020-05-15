import 'dart:math';

import 'package:WildcatMobileOrder/blocs/blocs.dart';
import 'package:WildcatMobileOrder/repositories/repositories.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  AuthenticationBloc authenticationBloc;
  //Using mockito to create a mock user repo object to work with
  UserRepository userRepository;

  setUp(() {
    userRepository = UserRepository(
        firebaseAuth: MockFirebaseAuth(), googleSignIn: MockGoogleSignIn());
    authenticationBloc = AuthenticationBloc(userRepository: userRepository);
  });

  tearDown(() {
    authenticationBloc?.close();
  });

  test('testing an initial state', () {
    expect(authenticationBloc.initialState, Uninitialized());
  });

  test('close does not emit new states', () {
    expectLater(
      authenticationBloc,
      emitsInOrder(<dynamic>[Uninitialized(), emitsDone]),
    );
    authenticationBloc.close();
  });

  group('AppStart', () {
    test('emits [uninitialized, unauthenticated] for invalid token', () {
      expectLater(
        authenticationBloc,
        emitsInOrder(<AuthenticationState>[
          Uninitialized(),
          Unauthenticated(),
        ]),
      );

      authenticationBloc.add(AppStarted());
    });
    test('automatic sign in', () async {
      final user = await userRepository.signInWithGoogle();
      authenticationBloc.add(AppStarted());
      expectLater(
          authenticationBloc,
          emitsInOrder(<AuthenticationState>[
            Uninitialized(),
            Authenticated(user),
          ]));
    });
  });

  group('UserRepository', () {
    test('is signed in returns true after sign in', () async {
      await userRepository.signInWithGoogle();
      expect(await userRepository.isSignedIn(), true);
    });
    test('is signed in returns false without sign in', () async {
      final _userRepository = UserRepository(
          firebaseAuth: MockFirebaseAuth(), googleSignIn: MockGoogleSignIn());
      expect(await _userRepository.isSignedIn(), false);
    });
    test('sign out makes isSignedIn() false', () async {
      userRepository.signOut();
      expect(await userRepository.isSignedIn(), false);
    });
    test('default isSignedIn() is false', () async {
      final _userRepository = UserRepository(
          firebaseAuth: MockFirebaseAuth(), googleSignIn: MockGoogleSignIn());
      expect(await _userRepository.isSignedIn(), false);
    });
  });

  group('Authenticated', () {
    test('emits [uninitialized, authenticated] when login successful',
        () async {
      final user = await userRepository.signInWithGoogle();
      expectLater(
        authenticationBloc,
        emitsInOrder(<AuthenticationState>[
          Uninitialized(),
          Authenticated(user),
        ]),
      );
      authenticationBloc.add(LoggedIn());
    });

    test('emits [unauthenticated] after LoggedOut', () async {
      authenticationBloc.add(LoggedOut());
      await emitsExactly<AuthenticationBloc, AuthenticationState>(
          authenticationBloc, <AuthenticationState>[Unauthenticated()]);
    });
    test('LoggedOut event actually triggers log out', () async {
      final user = await userRepository.signInWithGoogle();
      authenticationBloc.add(LoggedIn());
      authenticationBloc.add(LoggedOut());
      expectLater(
          authenticationBloc,
          emitsInOrder(<AuthenticationState>[
            Uninitialized(),
            Authenticated(user),
            Unauthenticated(),
          ]));
    });
  });
}
