import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pep/ui/shared/widgets/loading.dart';
import 'package:pep/services/auth.dart';
import 'package:pep/ui/views/authenticate/sign_in.dart';
import '../../shared/utils/constants.dart' as constants;
import '../../shared/utils/scroll_behaviour.dart';

class Register extends StatefulWidget {
  // Constructor for toggleView function
  final Function? toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Private variable
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool isLoading = false;

  // Text field intial states
  String username = '';
  String email = '';
  String password = '';

  validator() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      print("valid");
    } else {
      print("not");
    }
  }

  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Loading()
        : SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              body: Container(
                padding: const EdgeInsets.only(top: 125),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("pep", style: constants.ThemeText.titleText),
                    const SizedBox(height: 50.0),
                    Expanded(
                      child: Form(
                          key: _formKey,
                          child: 
                          ScrollConfiguration(
                            behavior: ScrollBehaviour(),
                            child: ListView(
                                padding: const EdgeInsets.only(
                                    top: 50.0, left: 50.0, right: 50.0),
                                children: <Widget>[
                                  //
                                  // Username Field
                                  //
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: TextFormField(
                                        decoration: const InputDecoration(
                                            hintText: "enter username here",
                                            fillColor:
                                                constants.Colors.lightGrey,
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                              borderSide: BorderSide.none,
                                            )),
                                        validator: (String? value) {
                                          if (value == null) {
                                            return "Please enter something!";
                                          }
                                          if (!RegExp(
                                                  r"^(?!.*___|\.|.*\.$|.*\.\.)[a-z1-9_.]{3,20}$")
                                              .hasMatch(value)) {
                                            return "Ensure your username:\n\nStarts or ends in a underscore\nNo underscores in a row\nDoesn't start or end in a period";
                                          }
                                          return null;
                                        },
                                        onChanged: (val) {
                                          setState(() => username = val);
                                        }
                                      )),
                                  //
                                  // Email Field
                                  //
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: TextFormField(
                                        decoration: const InputDecoration(
                                            hintText: "enter email here",
                                            fillColor:
                                                constants.Colors.lightGrey,
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                              borderSide: BorderSide.none,
                                            )),
                                        validator: (String? value) {
                                          if (value == null) {
                                            return "Please enter something!";
                                          }
                                          if (!RegExp(
                                                  r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                              .hasMatch(value)) {
                                            return "Please enter a valid email";
                                          }
                                          return null;
                                        },
                                        onChanged: (val) {
                                          setState(() => email = val.trim());
                                        },
                                      )),
                                  //
                                  // Password Field
                                  //
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: TextFormField(
                                      obscureText: _isObscure,
                                      decoration: InputDecoration(
                                        hintText: "enter password here",
                                        fillColor: constants.Colors.lightGrey,
                                        filled: true,
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide: BorderSide.none,
                                        ),
                                        suffixIcon: IconButton(
                                          splashColor: Colors.transparent,
                                          color: constants.Colors.darkGrey,
                                          icon: Icon(_isObscure
                                              ? Icons.visibility
                                              : Icons.visibility_off),
                                          onPressed: () {
                                            setState(() {
                                              _isObscure = !_isObscure;
                                            });
                                          },
                                        ),
                                        
                                      ),
                                      validator: (String? value) {
                                        if (value == null) {
                                          return "Please enter something!";
                                        }
                                        // Dont need this for log in only register
                                        // Minimum 8 characters, at least 1 letter and 1 numbe
                                        if (!RegExp(
                                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                            .hasMatch(value)) {
                                          return "Ensure your password has:\n\nAtleast 8 characters\nIncludes a special character (!@#\$&*~)\nIncludes a uppercase\nIncludes a number";
                                        }
                                        return null;
                                      },
                                      onChanged: (val) {
                                          setState(() => password = val);
                                        },
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  ConstrainedBox(
                                    constraints: const BoxConstraints.tightFor(
                                        width: 195, height: 45),
                                    child: TextButton(
                                        style: constants.Button.textButton,
                                        child: const Text(
                                          "register",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () async {
                                          validator();
                                          dynamic result = await _auth.registerUser(username: username, email: email, password: password);
                                          if(result == null) {
                                            setState(() {
                                              isLoading = false;
                                              error = 'Please supply a valid email';
                                            });
                                          }
                                          // if(_formKey.currentState.validate()){
                                          // setState(() => loading = true);
                                          // dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                                          // if(result == null) {
                                          //   setState(() {
                                          //     loading = false;
                                          //     error = 'Could not sign in with those credentials';
                                          //   });
                                          // }
                                          // }
                                        }),
                                  ),
                                  const SizedBox(height: 12.0),
                                  Center(
                                    child: RichText(
                                      text: TextSpan(
                                        style: constants.ThemeText.smallText,
                                        children: <TextSpan>[
                                          const TextSpan(
                                              text:
                                                  "already have an account? "),
                                          TextSpan(
                                              text: "login",
                                              style:
                                                  constants.ThemeText.linkText,
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SignIn()),
                                                  );
                                                }),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12.0),
                                  Center(
                                    child: Text(
                                      error,
                                      style: constants.ThemeText.errorText
                                    ),
                                  )
                                ]
                              ),
                          )
                        ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
