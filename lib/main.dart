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
  final MenuRepository _menuRepository = MenuRepository();

  runApp(MyApp(_userRepository, _menuRepository));
}

final ThemeData td = ThemeData(
  primaryColor: Colors.red[800],
);

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  final MenuRepository menuRepository;

  MyApp(this.userRepository, this.menuRepository);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                AuthenticationBloc(userRepository: userRepository)
                  ..add(AppStarted())),
        BlocProvider(
            create: (context) => MenuBloc(menuRepository: menuRepository)),
        BlocProvider(
          create: (context) => CartBloc(),
        ),
      ],
      child: MaterialApp(home:
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
      })),
    );
  }
}
