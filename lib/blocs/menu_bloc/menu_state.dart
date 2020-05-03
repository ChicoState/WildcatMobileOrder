import 'package:WildcatMobileOrder/repositories/menu_repository/menu_entity.dart';
import 'package:equatable/equatable.dart';

abstract class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object> get props => [];
}

class MenusLoading extends MenuState {}

class MenusLoaded extends MenuState {
  final List<MenuEntity> menus;

  const MenusLoaded([this.menus = const []]);

  @override
  List<Object> get props => [menus];

  @override
  String toString() => 'MenusLoaded { menus: $menus }';
}

class MenusNotLoaded extends MenuState {}
