import 'package:buy_it/models/product.dart';
import 'package:buy_it/services/store.dart';
import 'package:buy_it/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';

class EditProductScreen extends StatelessWidget {
  static const String id = 'EditProduct';
  final GlobalKey<FormState> _globalKey = GlobalKey();
  String _name, _price, _description, _category, _imageLocation;

  @override
  Widget build(BuildContext context) {
    final Product product = ModalRoute.of(context).settings.arguments;
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
                  initialValue: product.pName,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                CustomTextField(
                  hint: "Product Price",
                  onClick: (value) => _price = value,
                  initialValue: product.pPrice,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                CustomTextField(
                  hint: "Product Description",
                  onClick: (value) => _description = value,
                  initialValue: product.pDescription,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                CustomTextField(
                  hint: "Product Category",
                  onClick: (value) => _category = value,
                  initialValue: product.pCategory,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                CustomTextField(
                  hint: "Product Location",
                  onClick: (value) => _imageLocation = value,
                  initialValue: product.pLocation,
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_globalKey.currentState.validate()) {
                      _globalKey.currentState.save();
                      if (!(product.pName == _name &&
                          product.pPrice == _price &&
                          product.pDescription == _description &&
                          product.pCategory == _category &&
                          product.pLocation == _imageLocation)) {
                        product
                          ..pName = _name
                          ..pPrice = _price
                          ..pDescription = _description
                          ..pCategory = _category
                          ..pLocation = _imageLocation;
                        Store.editProduct(product.pId, {
                          kProductName: product.pName,
                          kProductPrice: product.pPrice,
                          kProductDescription: product.pDescription,
                          kProductCategory: product.pCategory,
                          kProductLocation: product.pLocation,
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text('the product has been edited successfully'),
                          duration: Duration(seconds: 2),
                        ));
                      } else
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('No edit occurred!'),
                          duration: Duration(seconds: 2),
                        ));
                    }
                  },
                  child: Text(
                    'Edit Product',
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
