import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pep/ui/shared/widgets/loading.dart';
import 'package:pep/ui/views/authenticate/authenticate.dart';
import 'package:pep/ui/views/authenticate/register.dart';
import '../../shared/utils/constants.dart' as constants;
import '../../shared/utils/scroll_behaviour.dart';

class SignIn extends StatefulWidget {
  // Constructor for toggleView function
  final Function? toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  // Private variable
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool isLoading = false;

  // Text field intial states
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
                padding: const EdgeInsets.symmetric(vertical: 125),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("pep", style: constants.ThemeText.titleText),
                    const SizedBox(height: 50.0),
                    Expanded(
                      child: Form(
                          key: _formKey,
                          child: ScrollConfiguration(
                            behavior: ScrollBehaviour(),
                            child: ListView(
                                padding: const EdgeInsets.only(
                                    top: 50.0, left: 50.0, right: 50.0),
                                children: <Widget>[
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
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  ConstrainedBox(
                                    constraints: const BoxConstraints.tightFor(
                                        width: 195, height: 45),
                                    child: TextButton(
                                        style: constants.Button.textButton,
                                        child: const Text(
                                          "log in",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () async {
                                          validator();
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
                                              text: "don't have an account? "),
                                          TextSpan(
                                              text: "sign up",
                                              style:
                                                  constants.ThemeText.linkText,
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Register()),);
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
                                ]),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
