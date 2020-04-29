import 'package:WildcatMobileOrder/repositories/cart_repository/cart_model.dart';
import 'package:WildcatMobileOrder/repositories/menu_repository/menu_entity.dart';
import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class LoadCart extends CartEvent {}

class CartUpdated extends CartEvent {
  final Cart cart;

  const CartUpdated(this.cart);

  @override
  List<Object> get props => [cart];

  @override
  String toString() => 'CartUpdated { cart: $cart }';
}

class CartMenusUpdated extends CartEvent {
  final List<MenuEntity> menus;

  const CartMenusUpdated(this.menus);

  @override
  List<Object> get props => [menus];

  @override
  String toString() => 'MenusUpdated { menus: $menus }';
}
