import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:flash_chat/constants.dart' as constant;
import 'package:flash_chat/components/rounded_button.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  static final String id = "WelcomeScreen";

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  Widget getTypeWritterAnimation({@required String text}) {
    return SizedBox(
      child: DefaultTextStyle(
          style: const TextStyle(
            fontSize: 45.0,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'Agne',
          ),
          child: AnimatedTextKit(
              repeatForever: false,
              totalRepeatCount: 5,
              animatedTexts: [
                TypewriterAnimatedText(text, speed: Duration(milliseconds: 100))
              ])),
    );
  }

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: Duration(seconds: 1), upperBound: 80);

    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: "logo",
                  child: Container(
                    height: controller.value,
                    child: Image.asset(
                      'images/logo.png',
                    ),
                  ),
                ),
                getTypeWritterAnimation(text: "Flash Chat")
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              label: "Log In",
              color: constant.kPrimaryButtonColor,
              onTap: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(
              label: "Register",
              color: constant.kSecondaryButtonColor,
              onTap: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
