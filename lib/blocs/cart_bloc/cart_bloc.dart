import 'dart:async';
import 'package:bloc/bloc.dart';

import '../../repositories/repositories.dart';
import './bloc.dart';

/// Bloc that manages Cart events and states
class CartBloc extends Bloc<CartEvent, CartState> {
  /// Email of current user
  String user;

  @override
  CartState get initialState => CartLoading();

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    if (event is LoadCart) {
      var currentState = state;
      if (currentState is CartLoaded) {
        yield CartLoaded(cart: currentState.cart);
      } else {
        var myCart = Cart(<CartItem>[], '', user);
        yield CartLoaded(cart: myCart);
      }
    } else if (event is CartUpdated) {
      yield CartLoaded(cart: event.cart);
    } else if (event is CartReset) {
      yield CartLoaded(cart: Cart(<CartItem>[], '', user));
    }
  }
}
