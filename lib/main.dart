import 'package:WildcatMobileOrder/shared/loading.dart';
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
  final UserRepository userRepository = UserRepository();

  runApp(MyApp(userRepository));
}

final ThemeData td = ThemeData(
  primaryColor: Colors.red[800],
);

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  final MenuRepository menuRepository = MenuRepository(Firestore.instance);

  MyApp(this.userRepository);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) =>
                  AuthenticationBloc(userRepository: this.userRepository)
                    ..add(AppStarted())),
          BlocProvider(
              create: (context) => MenuBloc(menuRepository: menuRepository)),
        ],
        child: MaterialApp(home:
            BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
          if (state is Unauthenticated) {
            return Login2(userRepository: userRepository);
          }
          if (state is Authenticated) {
            // start to load menus
            BlocProvider.of<MenuBloc>(context).add(LoadMenus());
            return Landing();
          }
          return Loading();
        })));
  }
}
