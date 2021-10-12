import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart' as constants;

import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static final String id = "LoginScreen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;
  bool _isLoadingDeactive = true;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: _isLoadingDeactive
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Flexible(
                      child: Hero(
                        tag: "logo",
                        child: Container(
                          height: 200.0,
                          child: Image.asset(
                            'images/logo.png',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 48.0,
                    ),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                      onChanged: (value) {
                        email = value;
                        //Do something with the user input.
                      },
                      decoration: constants.kRoundedTextField
                          .copyWith(hintText: "Enter an email adress"),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    TextField(
                      obscureText: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                      onChanged: (value) {
                        password = value;
                        //Do something with the user input.
                      },
                      decoration: constants.kRoundedTextField
                          .copyWith(hintText: "Enter your password"),
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    RoundedButton(
                        color: constants.kPrimaryButtonColor,
                        label: "Log In",
                        onTap: () async {
                          setState(() {
                            _isLoadingDeactive = false;
                          });
                          try {
                            UserCredential user =
                                await _auth.signInWithEmailAndPassword(
                                    email: email, password: password);
                            if (user != null) {
                              Navigator.pushNamed(context, ChatScreen.id);
                            }
                          } catch (e) {
                            print(e);
                          }
                          setState(() {
                            _isLoadingDeactive = true;
                          });
                        }),
                  ],
                )
              : Center(child: CircularProgressIndicator()),
        ));
  }
}
