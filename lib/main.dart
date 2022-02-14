import 'package:flutter/material.dart';
import 'package:pep/models/user.dart';
import 'package:pep/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pep/wrapper.dart';
import 'package:provider/provider.dart';
import 'ui/shared/utils/constants.dart' as constants;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return StreamProvider<UserAttributes?>.value(
        initialData: null,
        value: AuthService().onAuthStateChanged,
        builder: (context, snapshot) {
          return MaterialApp(
              title: 'pep',
              theme: ThemeData(
                fontFamily: 'Montserrat',
                primarySwatch: Colors.blue,
                textTheme: const TextTheme(
                    // CAN CHANGE HEADLINE AND P STYLELS HERE
                    ),
                textSelectionTheme: const TextSelectionThemeData(
                  cursorColor: constants.Colors.mainColor,
                  selectionColor: constants.Colors.mainColor,
                  selectionHandleColor: constants.Colors.mainColor,
                ),
              ),
              home: Wrapper()
              // initialRoute: "/",
              // routes: {
              //   "/": (context) => Wrapper(),
              //   "/login": (context) => Login(),
              //   "/register": (context) => Register(),
              //   "/profile": (context) => Profile()
              // },
              );
        });
    // );
  }
}
