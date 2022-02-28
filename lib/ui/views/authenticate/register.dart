import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pep/models/user.dart';
import 'package:pep/services/auth.dart';
import 'package:pep/services/database.dart';
import 'package:pep/ui/views/authenticate/login.dart';
import 'package:pep/wrapper.dart';
import '../../shared/utils/constants.dart' as constants;

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  String? _error = "";
  bool _submitted = false;
  dynamic _usernameValidationMessage;
  dynamic _emailValidationMessage;

  // Release memory that is stored by the controllers
  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<dynamic> validateUsername(String value) async {
    _usernameValidationMessage = null;
    bool checkUsername = await DatabaseService().findUsername(value);

    if (!checkUsername) {
      _usernameValidationMessage = "${value} is taken";
      return;
    }
    if (value.isEmpty) {
      _usernameValidationMessage = "Enter a username";
      return;
    }
    if (!RegExp(r"^(?!.*___|\.|.*\.$|.*\.\.)[a-zA-Z1-9_.]{3,20}$").hasMatch(value)) {
      _usernameValidationMessage = "Ensure your username does not:\n\nStart or end in a period\n2+ underscores in a row\nInclude any special characters\nMore than 2 characters";
      return;
    }
  }

  Future<dynamic> validateEmail(String value) async {
    _emailValidationMessage = null;
    bool checkEmail = await DatabaseService().findEmail(value);

    if (!checkEmail) {
      _emailValidationMessage = "Account exists with this email";
      return;
    }
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
                      if (!hasFocus) validateUsername(_usernameController.text);
                    },
                    child: TextFormField(
                      controller: _usernameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (text) => _usernameValidationMessage,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelText: "Username",
                        filled: true,
                        fillColor: constants.Colors.lightGrey,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20.0)),
                      ),
                    ),
                  ),
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
                            borderRadius: BorderRadius.circular(20.0)),
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
                          borderRadius: BorderRadius.circular(20.0)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child:
                      Text("${_error}", style: constants.ThemeText.errorText),
                ),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 45.0,
                      width: 120.0,
                      child: TextButton(
                        style: constants.Button.textButton,
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              await authService.register(
                                  _usernameController.text.trim(),
                                  _emailController.text.trim(),
                                  _passwordController.text.trim());
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Wrapper()),
                                  (_) => false);
                            } catch (e) {
                              setState(() {
                                _error = "Please supply a valid email";
                              });
                            }
                          }
                        },
                      ),
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
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Login()));
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
