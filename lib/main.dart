///@nodoc
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lab_manager/screens/authenticate/authenticate.dart';
import 'package:lab_manager/screens/authenticate/register.dart';
import 'package:lab_manager/screens/authenticate/sign_in.dart';
import 'package:lab_manager/screens/home/home.dart';
import 'package:lab_manager/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lab_manager/services/auth.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

/// MyApp is the root widget for the whole project.
/// We use MaterialApp in order to style the app and route through the pages.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          // Wrapper Screen
          '/': (_) => const Wrapper(),
          // Home Screens
          '/home': (_) => const Home(),
          // Authentication Screens
          '/authenticate': (_) => const Authenticate(),
          '/authenticate/sign_in': (_) => SignIn(),
          '/authenticate/register': (_) => Register(),
        },
        // home: Wrapper(),
      ),
    );
  }
}
