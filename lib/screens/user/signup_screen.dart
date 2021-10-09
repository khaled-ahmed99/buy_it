import 'package:buy_it/constants.dart';
import 'package:buy_it/provider/modalHud.dart';
import 'package:buy_it/screens/user/homepage_screen.dart';
import 'package:buy_it/screens/user/login_screen.dart';
import 'package:buy_it/services/auth.dart';
import 'package:buy_it/widgets/custom_textfield.dart';
import 'package:buy_it/widgets/logo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  static const String id = 'SignUp';
  final GlobalKey<FormState> _globalKey = GlobalKey();
  String _name, _email, _password;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kMainColor,
      body: Consumer<ModalHud>(
        builder: (context, modalHud, child) => ModalProgressHUD(
          inAsyncCall: modalHud.isLoading,
          child: Form(
            key: _globalKey,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Logo(size: size),
                    SizedBox(
                      height: size.height / 15,
                    ),
                    CustomTextField(
                      hint: "Enter your name",
                      icon: Icons.perm_identity,
                      onClick: (value) => _name = value,
                    ),
                    SizedBox(
                      height: size.height * .03,
                    ),
                    CustomTextField(
                      hint: "Enter your email",
                      icon: Icons.email,
                      onClick: (value) => _email = value,
                    ),
                    SizedBox(
                      height: size.height * .03,
                    ),
                    CustomTextField(
                      hint: "Enter your password",
                      icon: Icons.lock,
                      onClick: (value) => _password = value,
                    ),
                    SizedBox(
                      height: size.height * .05,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 120),
                      child: FlatButton(
                        onPressed: () async {
                          modalHud.changeIsLoading(true);
                          if (_globalKey.currentState.validate()) {
                            try {
                              _globalKey.currentState.save();
                              await Auth.signUp(_email, _password);
                              Navigator.pushNamed(context, HomePageScreen.id);
                              modalHud.changeIsLoading(false);
                            } on FirebaseAuthException catch (ex) {
                              modalHud.changeIsLoading(false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(ex.message)));
                            }
                          }
                          modalHud.changeIsLoading(false);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: Colors.black,
                        child: Text(
                          'Sign up',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * .03,
                    ),
                    Center(
                      child: RichText(
                        text: TextSpan(
                            text: "Do have an account ? ",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            children: [
                              TextSpan(
                                text: 'Log in',
                                style: TextStyle(color: Colors.black),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Navigator.pushNamed(
                                      context, LogInScreen.id),
                              )
                            ]),
                      ),
                    ),
                    SizedBox(
                      height: size.height * .05,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
