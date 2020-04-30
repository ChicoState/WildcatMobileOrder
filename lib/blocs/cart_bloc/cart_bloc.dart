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
      Cart myCart = Cart(List<CartItem>(), '', user);
      yield CartLoaded(cart: myCart);
    } else if (event is CartUpdated) {
      _mapCartUpdatedToState(event);
    }
  }

  Stream<CartState> _mapLoadCartToState(LoadCart event) async* {
    Cart myCart = Cart(List<CartItem>(), '', user);
    yield CartLoaded(cart: myCart);
    try {
      await Future.delayed(Duration(seconds: 1));
      add(CartUpdated(cart: Cart(List<CartItem>(), '', user)));
    } catch (_) {
      print('something went wrong');
    }
  }

  Stream<CartState> _mapCartUpdatedToState(CartUpdated event) async* {
    yield CartLoaded(cart: event.cart);
  }
}
