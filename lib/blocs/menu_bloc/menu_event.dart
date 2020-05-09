import 'package:equatable/equatable.dart';
import '../../repositories/repositories.dart';

abstract class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object> get props => [];
}

class LoadMenus extends MenuEvent {}

class MenusUpdated extends MenuEvent {
  final List<MenuEntity> menus;

  const MenusUpdated(this.menus);

  @override
  List<Object> get props => [menus];
}
