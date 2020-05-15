import 'package:WildcatMobileOrder/repositories/repositories.dart';
import 'package:WildcatMobileOrder/screens/screens.dart';
import 'package:WildcatMobileOrder/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:WildcatMobileOrder/screens/login.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:mockito/mockito.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  UserRepository userRepository;
  AuthenticationBloc authenticationBloc;

  setUp(() {
    userRepository = UserRepository(
        firebaseAuth: MockFirebaseAuth(), googleSignIn: MockGoogleSignIn());
    authenticationBloc = AuthenticationBloc(userRepository: userRepository);
  });

  group('login screen init', () {
    testWidgets('Main UI Test', (WidgetTester tester) async {
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
  });
}
