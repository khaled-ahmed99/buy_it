import 'package:flutter/material.dart';

class AdminMode extends ChangeNotifier {
  bool isAdmin = false;
  void changrIsAdmin(bool value) {
    isAdmin = value;
    notifyListeners();
  }
}
