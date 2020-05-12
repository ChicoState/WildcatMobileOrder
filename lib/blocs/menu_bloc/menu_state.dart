import 'package:equatable/equatable.dart';
import '../../repositories/menu_repository/menu_entity.dart';

/// Abstract class representing MenuState
abstract class MenuState extends Equatable {
  /// Abstract MenuState constructor
  const MenuState();

  @override
  List<Object> get props => [];
}

/// State representing when menus are loading
class MenusLoading extends MenuState {}

/// State providing most up to date list of menus/location data
class MenusLoaded extends MenuState {
  /// List of menus/location data
  final List<Menu> menus;

  /// Default constructor for MenusLoaded
  const MenusLoaded([this.menus = const []]);

  @override
  List<Object> get props => [menus];

  @override
  String toString() => 'MenusLoaded { menus: $menus }';
}

/// State representing that menus are not loaded
class MenusNotLoaded extends MenuState {}
