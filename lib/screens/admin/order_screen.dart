import 'package:buy_it/constants.dart';
import 'package:buy_it/widgets/order_list.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  static const String id = 'OrderScreen';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: OrderList(
        size: size,
        isAdmin: true,
      ),
    );
  }
}
