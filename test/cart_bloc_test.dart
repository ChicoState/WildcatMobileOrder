import 'package:WildcatMobileOrder/blocs/cart_bloc/bloc.dart';
import 'package:WildcatMobileOrder/repositories/cart_repository/cart_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockCartBloc extends MockBloc<CartEvent,CartState> implements CartBloc {}

void main () {
  final mockCart = MockCartBloc();

  group('CartBlocTesting', () {
    blocTest(
      'emits [] when nothing is added',
      build: () async => CartBloc(),
      expect: [],
    );

    blocTest(
      'emits [1] when CounterEvent.increment is added',
      build: () async => CartBloc(),
      act: (bloc) => bloc.add(CartEvent),
      skip: 0,
      expect: [0, 1],
    );
  });
}
