import 'dart:async';
import 'package:WildcatMobileOrder/blocs/menu_bloc/menu_bloc.dart';
import 'package:WildcatMobileOrder/blocs/menu_bloc/menu_state.dart';
import 'package:WildcatMobileOrder/repositories/repositories.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import './bloc.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final MenuBloc menuBloc;
  final String user;
  StreamSubscription menuSubscription;
  List<MenuEntity> menus;

  CartBloc({@required this.menuBloc, @required this.user}) {
    menuSubscription = menuBloc.listen((state) {
      if (state is MenusLoaded) {
        add(CartMenusUpdated((menuBloc.state as MenusLoaded).menus));
      }
    });
  }

  @override
  CartState get initialState => CartLoading();

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    if (event is CartMenusUpdated) {
      _mapMenusUpdatedToState(event);
    } else if (event is LoadCart) {
      _mapLoadCartToState(event);
    } else if (event is CartUpdated) {
      _mapCartUpdatedToState(event);
    }
  }

  Stream<CartState> _mapMenusUpdatedToState(CartMenusUpdated event) async* {
    final currentState = state;
    menus = event.menus;
    if (currentState is CartLoadSuccess) {
      yield CartLoadSuccess(cart: currentState.cart, menus: event.menus);
    } else {
      yield CartLoading();
    }
  }

  Stream<CartState> _mapLoadCartToState(LoadCart event) async* {
    // do some logic and query persistent storage
    yield CartLoading();
    await Future.delayed(Duration(seconds: 1));
    yield CartLoadSuccess(cart: Cart(List<CartItem>(), ''), menus: menus);
  }

  Stream<CartState> _mapCartUpdatedToState(CartUpdated event) async* {
    final currentState = state;
    if (currentState is CartLoadSuccess) {
      yield CartLoadSuccess(cart: event.cart, menus: currentState.menus);
    }
  }
}
