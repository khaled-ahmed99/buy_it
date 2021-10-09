import 'package:buy_it/constants.dart';
import 'package:buy_it/models/product.dart';
import 'package:buy_it/provider/cartItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_screen.dart';

class ProductInfoScreen extends StatefulWidget {
  static const String id = 'ProductInfo';
  @override
  _ProductInfoState createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfoScreen> {
  int numOfProduct = 0;

  void addProduct(Product product) {
    if (numOfProduct > 0) {
      var cardItem = Provider.of<CartItem>(context, listen: false);
      if (cardItem.getProducts.contains(product))
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('This product already exists in the cart'),
          duration: Duration(seconds: 2),
        ));
      else {
        product.pQuantity = numOfProduct;
        cardItem.addProduct(product);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Added To Cart'),
          duration: Duration(seconds: 2),
        ));
      }
    } else
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please, Identify The Quantity'),
          duration: Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Product product = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage(product.pLocation),
              fit: BoxFit.fill,
            )),
          ),
          Padding(
            padding: EdgeInsets.only(top: size.height * .04),
            child: ListTile(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 25,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.black,
                  size: 25,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, CartScreen.id);
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Column(
              children: [
                Container(
                  height: size.height * .3,
                  width: size.width,
                  color: Colors.white.withOpacity(.6),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.pName,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          product.pDescription,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(fontSize: 16),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '${product.pPrice}\$',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  numOfProduct > 0
                                      ? numOfProduct--
                                      : numOfProduct;
                                });
                              },
                              child: SizedBox(
                                height: 35,
                                width: 35,
                                child: Material(
                                  color: kMainColor,
                                  shape: CircleBorder(),
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.black,
                                    size: 25,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              numOfProduct.toString(),
                              style: TextStyle(fontSize: 60),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  numOfProduct++;
                                });
                              },
                              child: SizedBox(
                                height: 35,
                                width: 35,
                                child: Material(
                                  color: kMainColor,
                                  shape: CircleBorder(),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.black,
                                    size: 25,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  child: Text(
                    'add to cart'.toUpperCase(),
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: kMainColor,
                    minimumSize: Size(size.width, size.height * .12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                  ),
                  onPressed: () {
                    addProduct(product);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
