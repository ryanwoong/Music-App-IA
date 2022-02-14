import 'package:flutter/material.dart';
import 'package:pep/models/user.dart';
import 'package:pep/services/auth.dart';
import 'package:pep/ui/shared/widgets/loading.dart';
import 'package:pep/ui/views/authenticate/login.dart';
import 'package:pep/ui/views/home/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    // Use stream builder to get data from auth service
    return StreamBuilder<UserAttributes?>(
        stream: authService.onAuthStateChanged,
        builder: (_, AsyncSnapshot<UserAttributes?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            UserAttributes? user = snapshot.data;
            print("data: ${user}");
            return user == null ? const Login() : Home();
          }
          if (snapshot.hasError) {
            print('SNAPSHOT ERROR: ${snapshot.error}');
            return Text('${snapshot.error}');
          } else {
            return const Loading();
          }
        });
  }
}
