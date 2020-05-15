import 'package:equatable/equatable.dart';
import '../../repositories/cart_repository/cart_model.dart';

/// Abstract CartState class
abstract class CartState extends Equatable {
  /// Abstract  constructor for CartState
  const CartState();

  @override
  List<Object> get props => [];
}

/// Placeholder state while cart is loading
class CartLoading extends CartState {}

/// Represents a state with an up to date cart
class CartLoaded extends CartState {
  /// Cart object provided to builders
  final Cart cart;

  /// Default constructor for CartLoaded state
  const CartLoaded({this.cart});

  @override
  List<Object> get props => [cart];

  @override
  String toString() => 'Cart Loaded { cart: $cart}';
}
