import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'blocs/blocs.dart';
import 'repositories/repositories.dart';
import 'screens/screens.dart';
import 'widgets/widgets.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final _userRepository = UserRepository(
      firebaseAuth: FirebaseAuth.instance, googleSignIn: GoogleSignIn());
  final _menuRepository = MenuRepository(Firestore.instance);

  runApp(MyApp(_userRepository, _menuRepository));
}

/// Theme data to provide for all screens
final ThemeData td = ThemeData(
  primaryColor: Colors.red[800],
);

/// Root widget of the app
class MyApp extends StatelessWidget {
  /// Repository to provide for authentication
  final UserRepository userRepository;

  /// Repository to provide for menu loading
  final MenuRepository menuRepository;

  /// Default constructor requiring a UserRepository and a MenuRepository
  MyApp(this.userRepository, this.menuRepository);

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
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
            BlocProvider.of<CartBloc>(context).user = state.user.email;
            BlocProvider.of<CartBloc>(context).add(LoadCart(state.user.email));
            return Landing(state.user.email);
          }
          return Loading();
        })),
      );
}
