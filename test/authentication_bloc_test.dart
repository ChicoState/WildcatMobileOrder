import 'package:WildcatMobileOrder/blocs/blocs.dart';
import 'package:WildcatMobileOrder/repositories/repositories.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  AuthenticationBloc authenticationBloc;
  //Using mockito to create a mock user repo object to work with
  UserRepository userRepository;

  setUp(() {
    userRepository = UserRepository(
        firebaseAuth: MockFirebaseAuth(), googleSignin: MockGoogleSignIn());
    authenticationBloc = AuthenticationBloc(userRepository: userRepository);
  });

  test("testing async", () async {
    final user = await userRepository.signInWithGoogle();
    print(user);
  });

  tearDown(() {
    authenticationBloc?.close();
  });

  test('testing an initial state', () {
    expect(authenticationBloc.initialState, Uninitialized());
  });

  // test('close does not emit new states', () {
  //   expectLater(
  //     authenticationBloc,
  //     emitsInOrder([Uninitialized(), emitsDone]),
  //   );
  //   authenticationBloc.close();
  // });

  group('AppStart', () {
    test('emits [uninitialized, unauthenticated] for invalid token', () {
      final expectResponse = [
        Uninitialized(),
        Unauthenticated(),
      ];

      when(userRepository.isSignedIn()).thenAnswer((_) => Future.value(false));

      expectLater(
        authenticationBloc,
        emitsInOrder(expectResponse),
      );

      authenticationBloc.add(AppStarted());
    });
  });

  group('LoggedIn', () {
    test('emits [uninitialized, authenticated] when login successful',
        () async {
      final user = await userRepository.signInWithGoogle();
      final expectResponse = [
        Uninitialized(),
        Authenticated(user),
      ];

      expectLater(
        authenticationBloc,
        emitsInOrder(expectResponse),
      );

      authenticationBloc.add(LoggedIn());
    });
  });
}
