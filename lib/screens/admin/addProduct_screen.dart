import 'package:buy_it/models/product.dart';
import 'package:buy_it/services/store.dart';
import 'package:buy_it/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class AddProductScreen extends StatelessWidget {
  static const id = 'AddProduct';
  final GlobalKey<FormState> _globalKey = GlobalKey();
  String _name, _price, _description, _category, _imageLocation;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kMainColor,
      body: Form(
        key: _globalKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomTextField(
                  hint: "Product Name",
                  onClick: (value) => _name = value,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                CustomTextField(
                  hint: "Product Price",
                  onClick: (value) => _price = value,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                CustomTextField(
                  hint: "Product Description",
                  onClick: (value) => _description = value,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                CustomTextField(
                  hint: "Product Category",
                  onClick: (value) => _category = value,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                CustomTextField(
                  hint: "Product Location",
                  onClick: (value) => _imageLocation = value,
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_globalKey.currentState.validate()) {
                      _globalKey.currentState.save();
                      _globalKey.currentState.reset();
                      Store.addProduct(Product(
                        pName: _name,
                        pPrice: _price,
                        pDescription: _description,
                        pCategory: _category,
                        pLocation: _imageLocation,
                      ));
                    }
                  },
                  child: Text(
                    'Add Product',
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
