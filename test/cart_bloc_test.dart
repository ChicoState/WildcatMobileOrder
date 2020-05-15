import 'package:WildcatMobileOrder/blocs/cart_bloc/cart_bloc.dart';
import 'package:WildcatMobileOrder/blocs/cart_bloc/cart_event.dart';
import 'package:WildcatMobileOrder/blocs/cart_bloc/cart_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';


class MockCartBloc extends MockBloc<CartEvent, CartState>
    implements CartBloc {}

void main() {
  //MockCartBloc mockCartBloc;

  setUp(() {
    //mockCartBloc = MockCartBloc();
  });
  // test('Example mocked BLoC test', () {
  // whenListen(
  //   mockCartBloc,
  //   Stream.fromIterable([CartLoading, CartLoaded()]),
  // );

//   expectLater(
//     mockCartBloc,
//     emitsInOrder([CartLoading(), CartLoaded()]),
//   );
// });
  //TODO: Add test
}
