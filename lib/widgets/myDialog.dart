import 'package:buy_it/models/product.dart';
import 'package:buy_it/provider/cartItem.dart';
import 'package:buy_it/services/auth.dart';
import 'package:buy_it/services/store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class MyDialog extends StatefulWidget {
  final List<Product> products;

  MyDialog(this.products);

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  User loggedUser;
  @override
  void initState() {
    loggedUser = Auth.getUser();
    super.initState();
  }

  int getTotalPrice(List<Product> products) {
    int price = 0;
    for (Product product in products) {
      price += int.parse(product.pPrice) * product.pQuantity;
    }
    return price;
  }

  String _address = '';
  String _errMsg;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    int totalPrice = getTotalPrice(widget.products);
    return Dialog(
      child: Container(
        height: size.width * .56,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Price: $totalPrice\$',
                style: Theme.of(context).textTheme.headline6,
              ),
              TextField(
                onChanged: (value) {
                  _address = value;
                },
                cursorColor: kMainColor,
                decoration: InputDecoration(
                  errorText: _errMsg,
                  hintText: 'Enter your Address',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: kSecondaryColor,
                      width: 2,
                    ),
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_address.isNotEmpty) {
                      await Store.storeOrders({
                        kTotalPrice: totalPrice,
                        kAddress: _address,
                        kEmail: loggedUser.email,
                      }, widget.products);
                      Provider.of<CartItem>(context, listen: false).clearCart();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('The order has been added successfully'),
                        duration: Duration(seconds: 2),
                      ));
                    } else {
                      setState(() {
                        _errMsg = 'address is empty!';
                      });
                    }
                  },
                  child: Text('confirm'.toUpperCase()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
