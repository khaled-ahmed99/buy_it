import 'package:buy_it/constants.dart';
import 'package:buy_it/screens/admin/addProduct_screen.dart';
import 'package:buy_it/screens/admin/manageProducts_screen.dart';
import 'package:buy_it/screens/admin/order_screen.dart';
import 'package:flutter/material.dart';

class AdminHomeScreen extends StatelessWidget {
  static const String id = 'AdminHome';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, AddProductScreen.id);
            },
            child: Text(
              'Add Product',
              style: Theme.of(context).textTheme.button,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, ManageProductsScreen.id);
            },
            child: Text(
              'Edit Product',
              style: Theme.of(context).textTheme.button,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, OrderScreen.id);
            },
            child: Text(
              'View Orders',
              style: Theme.of(context).textTheme.button,
            ),
          ),
        ],
      ),
    );
  }
}
