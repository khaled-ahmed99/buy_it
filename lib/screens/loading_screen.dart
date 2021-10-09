import 'package:buy_it/constants.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  static const String id = 'LoadingScreen';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(
            constraints: BoxConstraints.expand(),
            color: kMainColor,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          ),
        ));
  }
}
