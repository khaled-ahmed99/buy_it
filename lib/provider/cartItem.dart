import 'dart:collection';

import 'package:buy_it/models/product.dart';
import 'package:flutter/cupertino.dart';

class CartItem extends ChangeNotifier {
  List<Product> _products = [];
  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void deleteProduct(Product product) {
    _products.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _products.clear();
    notifyListeners();
  }

  UnmodifiableListView<Product> get getProducts =>
      UnmodifiableListView(_products);
}
