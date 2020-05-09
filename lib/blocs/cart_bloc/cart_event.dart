import 'package:equatable/equatable.dart';
import '../../repositories/cart_repository/cart_model.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
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
  List<Object> get props => [cart];

  @override
  String toString() => 'CartUpdated { cart: $cart }';
}

class CartReset extends CartEvent {
  const CartReset();

  @override
  String toString() => 'CartSubmitted';
}
