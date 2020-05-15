import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import '../../repositories/repositories.dart';
import './bloc.dart';

/// Manages updating price and menu information dynamically
class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final MenuRepository _menuRepository;
  StreamSubscription _menuSubscription;

  /// Default constructor for MenuBloc, requires a MenuRepository
  MenuBloc({@required MenuRepository menuRepository})
      : assert(menuRepository != null),
        _menuRepository = menuRepository;

  @override
  MenuState get initialState => MenusLoading();

  @override
  Stream<MenuState> mapEventToState(MenuEvent event) async* {
    if (event is LoadMenus) {
      _menuSubscription?.cancel();
      _menuSubscription = _menuRepository.getMenus().listen(
            (menus) => add(MenusUpdated(menus)),
          );
    } else if (event is MenusUpdated) {
      yield MenusLoaded(event.menus);
    }
  }
}
