import 'package:WildcatMobileOrder/blocs/blocs.dart';
import 'package:WildcatMobileOrder/repositories/repositories.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  AuthenticationBloc authenticationBloc;
  //Using mockito to create a mock user repo object to work with
  MockUserRepository userRepository;

  setUp(() {
    userRepository = MockUserRepository();
    authenticationBloc = AuthenticationBloc(userRepository: userRepository);
  });

  tearDown(() {
    authenticationBloc?.close();
  });

  test('initial state is correct', () {
    expect(authenticationBloc.initialState, Uninitialized());
  });

  test('close does not emit new states', () {
    expectLater(
      authenticationBloc,
      emitsInOrder([Uninitialized(), emitsDone]),
    );
    authenticationBloc.close();
  });
}
