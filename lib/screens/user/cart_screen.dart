import 'package:buy_it/constants.dart';
import 'package:buy_it/models/product.dart';
import 'package:buy_it/provider/cartItem.dart';
import 'package:buy_it/screens/user/productInfo_screen.dart';
import 'package:buy_it/widgets/myDialog.dart';
import 'package:buy_it/widgets/myPopupMenuItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const String id = 'CartScreen';

  Future<void> showCustomDialog(
      List<Product> products, BuildContext context, Size size) async {
    await showDialog(
        context: context, builder: (context) => MyDialog(products));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CartItem cartItem = Provider.of<CartItem>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
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
        title: Text(
          'My Cart',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: cartItem.getProducts.isEmpty
                ? Center(
                    child: Text(
                    'No Products Added',
                    style: Theme.of(context).textTheme.headline6,
                  ))
                : ListView.builder(
                    itemCount: cartItem.getProducts.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        child: GestureDetector(
                          onTapUp: (details) async {
                            double dx, dy, dx2, dy2;
                            dx = details.globalPosition.dx;
                            dy = details.globalPosition.dy;
                            dx2 = size.width - details.globalPosition.dx;
                            dy2 = size.height - details.globalPosition.dx;
                            await showMenu(
                                context: context,
                                position:
                                    RelativeRect.fromLTRB(dx, dy, dx2, dy2),
                                items: [
                                  MyPopupMenuItem(
                                    child: Text('Edit'),
                                    onClick: () {
                                      Navigator.pop(context);
                                      Navigator.pushNamed(
                                          context, ProductInfoScreen.id,
                                          arguments:
                                              cartItem.getProducts[index]);
                                      cartItem.deleteProduct(
                                          cartItem.getProducts[index]);
                                    },
                                  ),
                                  MyPopupMenuItem(
                                    child: Text('Delete'),
                                    onClick: () {
                                      Navigator.pop(context);
                                      cartItem.deleteProduct(
                                          cartItem.getProducts[index]);
                                    },
                                  ),
                                ]);
                          },
                          child: Container(
                            color: kSecondaryColor,
                            height: size.height * .15,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage(
                                      cartItem.getProducts[index].pLocation),
                                  radius: (size.height * .15) / 2,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            cartItem.getProducts[index].pName,
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            '${cartItem.getProducts[index].pPrice}\$',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: Text(
                                          (cartItem
                                                  .getProducts[index].pQuantity)
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          ElevatedButton(
            child: Text(
              'Order'.toUpperCase(),
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
            onPressed: () async {
              await showCustomDialog(cartItem.getProducts, context, size);
            },
          ),
        ],
      ),
    );
  }
}
