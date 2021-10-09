import 'package:buy_it/constants.dart';
import 'package:buy_it/provider/admin_mode.dart';
import 'package:buy_it/provider/modalHud.dart';
import 'package:buy_it/screens/user/homepage_screen.dart';
import 'package:buy_it/screens/user/signup_screen.dart';
import 'package:buy_it/services/auth.dart';
import 'package:buy_it/widgets/custom_textfield.dart';
import 'package:buy_it/widgets/logo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import '../admin/adminHome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogInScreen extends StatefulWidget {
  static const String id = 'LogIn';

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey();
  static const String _adminEmail = 'khaled@gmail.com';
  String _email, _password;
  bool rememberMe = false;

  Future<void> _validate(BuildContext context) async {
    final modalHud = Provider.of<ModalHud>(context, listen: false);
    modalHud.changeIsLoading(true);
    if (_globalKey.currentState.validate()) {
      _globalKey.currentState.save();
      if (Provider.of<AdminMode>(context, listen: false).isAdmin) {
        if (_email == _adminEmail) {
          try {
            await Auth.signIn(_email, _password);
            Navigator.pushNamed(context, AdminHomeScreen.id);
            modalHud.changeIsLoading(false);
          } on FirebaseAuthException catch (ex) {
            modalHud.changeIsLoading(false);
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(ex.message)));
          }
        } else
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Admin\'s email is wrong')));
      } else {
        try {
          await Auth.signIn(_email, _password);
          Navigator.pushNamed(context, HomePageScreen.id);
          modalHud.changeIsLoading(false);
        } on FirebaseAuthException catch (ex) {
          modalHud.changeIsLoading(false);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(ex.message)));
        }
      }
    }
    modalHud.changeIsLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kMainColor,
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<ModalHud>(context).isLoading,
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
                    height: size.height * .01,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                            checkColor: kSecondaryColor,
                            value: rememberMe,
                            onChanged: (value) =>
                                setState(() => rememberMe = value)),
                        Text(
                          'Remember me',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * .03,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 120),
                    child: FlatButton(
                      onPressed: () {
                        if (rememberMe) keepMeLoggedIn();
                        _validate(context);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: Colors.black,
                      child: Text(
                        'LogIn',
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
                          text: "Don't have an account ? ",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          children: [
                            TextSpan(
                              text: 'Sign up',
                              style: TextStyle(color: Colors.black),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.pushNamed(
                                    context, SignUpScreen.id),
                            )
                          ]),
                    ),
                  ),
                  SizedBox(
                    height: size.height * .03,
                  ),
                  Center(
                    child: DropdownButton<String>(
                      underline: Container(
                        height: 1,
                        color: kSecondaryColor,
                      ),
                      dropdownColor: kSecondaryColor,
                      items: [
                        DropdownMenuItem(
                          child: Text(
                            'I\'m a User',
                          ),
                          value: 'I\'m a User',
                        ),
                        DropdownMenuItem(
                          child: Text(
                            'I\'m an Admin',
                          ),
                          value: 'I\'m an Admin',
                        ),
                      ],
                      value: Provider.of<AdminMode>(context).isAdmin
                          ? 'I\'m an Admin'
                          : 'I\'m a User',
                      onChanged: (value) =>
                          Provider.of<AdminMode>(context, listen: false)
                              .changrIsAdmin(value == 'I\'m an Admin'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void keepMeLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(kKeepMeLoggedIn, true);
  }
}
