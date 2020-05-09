import 'package:equatable/equatable.dart';
import '../../repositories/cart_repository/cart_model.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class InitialCartState extends CartState {
  @override
  List<Object> get props => [];
}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final Cart cart;

  const CartLoaded({this.cart});

  @override
  List<Object> get props => [cart];

  @override
  String toString() => 'Cart Loaded { cart: $cart}';
}
