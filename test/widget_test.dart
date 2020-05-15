import 'package:WildcatMobileOrder/repositories/repositories.dart';
import 'package:WildcatMobileOrder/screens/screens.dart';
import 'package:WildcatMobileOrder/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:WildcatMobileOrder/screens/login.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:bloc_test/bloc_test.dart';

class MockMenuBloc extends MockBloc<MenuEvent, MenuState> implements MenuBloc {}

class MockCartBloc extends MockBloc<CartEvent, CartState> implements CartBloc {}

class MockAuthBloc extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  UserRepository userRepository;
  AuthenticationBloc authenticationBloc;
  //MenuRepository menuRepository;

  setUp(() {
    userRepository = UserRepository(
        firebaseAuth: MockFirebaseAuth(), googleSignIn: MockGoogleSignIn());
    //menuRepository = MenuRepository(MockFirestoreInstance());
    authenticationBloc = AuthenticationBloc(userRepository: userRepository);
  });

  tearDown(() {
    authenticationBloc?.close();
  });

  group('login screen init', () {
    testWidgets('Main UI Test', (tester) async {
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
        backgroundColor: Colors.grey[800],
        appBar: AppBar(
          title: Center(
            child: Text('Wildcat Mobile Order'),
          ),
        ),
        body: Container(),
      )));

      final titleFinder = find.text('Wildcat Mobile Order');
      expect(titleFinder, findsOneWidget);
    });
    testWidgets('login screen finds CSU Chico Gmail ', (tester) async {
      await tester.pumpWidget(MaterialApp(
          home: BlocProvider.value(
        value: authenticationBloc,
        child: LoginPage(userRepository: userRepository),
      )));

      expect(find.text('CSU Chico Gmail'), findsOneWidget);
    });
  });
}
