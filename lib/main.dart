import 'package:flutter/material.dart';
import 'package:pep/services/auth.dart';
import 'package:pep/ui/shared/widgets/loading.dart';
import 'package:pep/ui/views/home/home.dart';
import 'package:pep/ui/views/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'ui/shared/utils/constants.dart' as constants;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'pep',
      theme: ThemeData(
        fontFamily: 'Montserrat',
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
            // CAN CHANGE HEADLINE AND P STYLELS HERE
            ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: constants.Colors.mainColor,
          selectionColor: constants.Colors.mainColor,
          selectionHandleColor: constants.Colors.mainColor,
        ),
      ),
      home: const MyHomePage(title: 'pep'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Wrapper());
  }
}
