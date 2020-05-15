import 'package:equatable/equatable.dart';
import '../../repositories/repositories.dart';

/// Abstract class representing MenuEvent
abstract class MenuEvent extends Equatable {
  /// Abstract MenuEvent constructor
  const MenuEvent();

  @override
  List<Object> get props => [];
}

/// Event added to get and subscribe to the current menu
class LoadMenus extends MenuEvent {}

/// Event added whenever menu data changes
class MenusUpdated extends MenuEvent {
  /// List of all menus/locations
  final List<Menu> menus;

  /// Default constructor for MenusUpdated event
  const MenusUpdated(this.menus);

  @override
  List<Object> get props => [menus];
}
