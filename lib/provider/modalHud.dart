import 'package:flutter/material.dart';

class ModalHud extends ChangeNotifier {
  bool isLoading = false;

  void changeIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
