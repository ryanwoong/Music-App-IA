import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pep/services/auth.dart';
import 'package:pep/ui/views/authenticate/register.dart';
import '../../shared/utils/constants.dart' as constants;

class Login extends StatelessWidget {
  const Login({ Key? key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    final AuthService authService = AuthService();

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text("pep", style: constants.ThemeText.titleText),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "email"
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: "password"
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                style: constants.Button.textButton,
                child: const Text(
                  "log in",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  authService.signIn(_emailController.text.trim(), _passwordController.text);
                },
              )
            ),
            RichText(
              text: TextSpan(
                style: constants.ThemeText.smallText,
                children: <TextSpan>[
                  const TextSpan(
                      text: "don't have an account? "),
                  TextSpan(
                      text: "sign up",
                      style:
                          constants.ThemeText.linkText,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Register()));
                        }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

