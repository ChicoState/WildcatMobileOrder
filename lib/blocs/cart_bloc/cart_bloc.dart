import 'dart:async';
import 'package:WildcatMobileOrder/repositories/repositories.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  String user;

  void setUser(String _user) {
    user = _user;
  }

  @override
  CartState get initialState => CartLoading();

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    if (event is LoadCart) {
      CartState currentState = state;
      if (currentState is CartLoaded) {
        yield CartLoaded(cart: currentState.cart);
      } else {
        Cart myCart = Cart(List<CartItem>(), '', user, 0);
        yield CartLoaded(cart: myCart);
      }
    } else if (event is CartUpdated) {
      yield CartLoaded(cart: event.cart);
    } else if (event is CartReset) {
      yield CartLoaded(cart: Cart(List<CartItem>(), '', user, 0));
    }
  }

  Stream<CartState> _mapCartUpdatedToState(CartUpdated event) async* {
    yield CartLoaded(cart: event.cart);
  }
}
