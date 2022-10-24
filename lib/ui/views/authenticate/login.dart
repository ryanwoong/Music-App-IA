import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pep/services/auth.dart';
import 'package:pep/ui/views/authenticate/register.dart';
import '../../shared/utils/constants.dart' as constants;


class Login extends StatefulWidget {
  const Login({ Key? key }) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  String? _error = "";
  dynamic _emailValidationMessage;

  Future<dynamic> validateEmail(String value) async {
    _emailValidationMessage = null;

    if (value.isEmpty) {
      _emailValidationMessage = "Enter a email";
      return;
    }
    if (!RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?").hasMatch(value)) {
      _emailValidationMessage = "Please enter a valid email";
      return;
    }
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text("pep", style: constants.ThemeText.titleTextBlue),
                  ],
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Focus(
                    onFocusChange: (hasFocus) {
                      if (!hasFocus) validateEmail(_emailController.text);
                    },
                    child: TextFormField(
                      controller: _emailController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (text) => _emailValidationMessage,
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
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
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
                  child: Text(
                    "$_error",
                    style: constants.ThemeText.errorText
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 45.0,
                    width: 120.0,
                    child: TextButton(
                      style: constants.Button.textButton,
                      child: const Text(
                        "Log In",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await authService.signIn(_emailController.text.trim(), _passwordController.text);
                          } catch (e) {
                            setState(() {
                              _error = "Account doesn't exist or details are incorrect";
                            });
                          }
                        }
                        
                      },
                    ),
                  )
                ),
                RichText(
                  text: TextSpan(
                    style: constants.ThemeText.smallText,
                    children: <TextSpan>[
                      const TextSpan(
                          text: "Don't have an account? "),
                      TextSpan(
                          text: "Sign Up",
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
        ),
      ),
    );
  }
}

