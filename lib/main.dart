import 'package:flutter/material.dart';
import 'package:lab_manager/models/lab_user.dart';
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

// This widget is the root of your application.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<LabUser?>.value(
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
