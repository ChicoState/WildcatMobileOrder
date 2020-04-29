import 'package:WildcatMobileOrder/repositories/cart_repository/cart_model.dart';
import 'package:WildcatMobileOrder/repositories/menu_repository/menu_entity.dart';
import 'package:equatable/equatable.dart';

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

class CartLoadSuccess extends CartState {
  final Cart cart;
  final List<MenuEntity> menus;

  const CartLoadSuccess({this.cart, this.menus});

  @override
  List<Object> get props => [this.cart, this.menus];

  @override
  String toString() => 'CartLoadSuccess { cart: $cart, menus: $menus }';
}
