import 'package:equatable/equatable.dart';
import '../../repositories/cart_repository/cart_model.dart';

/// Abstract class for all CartEvents
abstract class CartEvent extends Equatable {
  /// Abstract constructor for CartEvents
  const CartEvent();

  @override
  List<Object> get props => [];
}

/// Added once a user is authenticated
class LoadCart extends CartEvent {
  /// Email of the user to populate cart with
  final String user;

  /// Default constructor for LoadCart event
  const LoadCart(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'LoadCart { user: $user }';
}

/// Added whenever the cart is updated
class CartUpdated extends CartEvent {
  /// Updated cart to represent in state
  final Cart cart;

  /// Default constructor for CartUpdated event
  const CartUpdated({this.cart});

  @override
  List<Object> get props => [cart];

  @override
  String toString() => 'CartUpdated { cart: $cart }';
}

/// Added when a cart is submitted as an order
class CartReset extends CartEvent {
  ///Default constructor for CartReset event
  const CartReset();

  @override
  String toString() => 'CartSubmitted';
}
