import 'package:WildcatMobileOrder/repositories/cart_repository/cart_model.dart';
import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
}

class LoadCart extends CartEvent {
  final String user;

  const LoadCart(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'LoadCart { user: $user }';
}

class CartUpdated extends CartEvent {
  final Cart cart;

  const CartUpdated({this.cart});

  @override
  List<Object> get props => [this.cart];

  @override
  String toString() =>
      'CartUpdated { cart: $cart }';
}
