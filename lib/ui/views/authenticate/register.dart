import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pep/services/auth.dart';
import 'package:pep/ui/views/authenticate/login.dart';
import 'package:pep/wrapper.dart';
import '../../shared/utils/constants.dart' as constants;


class Register extends StatefulWidget {
  const Register({ Key? key }) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
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
              const SizedBox(height: 20.0),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: "Username",
                    filled: true,
                    fillColor: constants.Colors.lightGrey,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20.0)
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: "Email",
                    filled: true,
                    fillColor: constants.Colors.lightGrey,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20.0)
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: "Password",
                    filled: true,
                    fillColor: constants.Colors.lightGrey,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20.0)
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextButton(
                    style: constants.Button.textButton,
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      await authService.register(_usernameController.text.trim(), _emailController.text.trim(), _passwordController.text.trim());
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> Wrapper()), (_) => false );
                    },
                  )),
              RichText(
                text: TextSpan(
                  style: constants.ThemeText.smallText,
                  children: <TextSpan>[
                    const TextSpan(text: "Already have an account? "),
                    TextSpan(
                        text: "Log In",
                        style: constants.ThemeText.linkText,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Login()));
                          }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
