import 'package:WildcatMobileOrder/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:WildcatMobileOrder/blocs/blocs.dart';
import 'package:WildcatMobileOrder/repositories/repositories.dart';
import 'package:bloc/bloc.dart';
import 'package:WildcatMobileOrder/screens/screens.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final UserRepository _userRepository = UserRepository();
  final MenuRepository _menuRepository = MenuRepository(Firestore.instance);

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
          create: (context) =>
              AuthenticationBloc(userRepository: _userRepository)
                ..add(AppStarted())),
      BlocProvider(
          create: (context) => MenuBloc(menuRepository: _menuRepository)),
      BlocProvider(
        create: (context) => CartBloc(),
      ),
    ],
    child: MyApp(_userRepository),
  ));
}

final ThemeData td = ThemeData(
  primaryColor: Colors.red[800],
);

class MyApp extends StatelessWidget {
  final UserRepository userRepository;

  MyApp(this.userRepository);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home:
        BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
      if (state is Unauthenticated) {
        return LoginPage(userRepository: userRepository);
      }
      if (state is Authenticated) {
        // start to load menus
        BlocProvider.of<MenuBloc>(context).add(LoadMenus());
        BlocProvider.of<CartBloc>(context).setUser(state.getEmail());
        BlocProvider.of<CartBloc>(context).add(LoadCart(state.getEmail()));
        return Landing(state.getEmail());
      }
      return Loading();
    }));
  }
}
