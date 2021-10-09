import 'package:buy_it/constants.dart';
import 'package:buy_it/models/product.dart';
import 'package:buy_it/screens/admin/editProduct_screen.dart';
import 'package:buy_it/services/store.dart';
import 'package:buy_it/widgets/myPopupMenuItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buy_it/extensions.dart';

class ManageProductsScreen extends StatelessWidget {
  static const String id = 'ManageProducts';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: kMainColor,
        body: StreamBuilder<QuerySnapshot>(
          stream: Store.loadProducts(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black,
                ),
              );
            List<Product> products = [];
            for (var doc in snapshot.data.docs) {
              var product = doc.data();
              products.add(
                Product(
                  pId: doc.id,
                  pName: product[kProductName],
                  pPrice: product[kProductPrice],
                  pDescription: product[kProductDescription],
                  pCategory: product[kProductCategory],
                  pLocation: product[kProductLocation],
                ),
              );
            }
            products
                .sort((a, b) => a.pName.numPart().compareTo(b.pName.numPart()));
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  child: LayoutBuilder(
                    builder: (context, constraints) => GestureDetector(
                      onTapUp: (details) async {
                        double dx, dy, dx2, dy2;
                        dx = details.globalPosition.dx;
                        dy = details.globalPosition.dy;
                        dx2 = size.width - details.globalPosition.dx;
                        dy2 = size.height - details.globalPosition.dx;
                        await showMenu(
                            context: context,
                            position: RelativeRect.fromLTRB(dx, dy, dx2, dy2),
                            items: [
                              MyPopupMenuItem(
                                child: Text('Edit'),
                                onClick: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(
                                      context, EditProductScreen.id,
                                      arguments: products[index]);
                                },
                              ),
                              MyPopupMenuItem(
                                child: Text('Delete'),
                                onClick: () {
                                  Store.deleteProduct(products[index].pId);
                                  Navigator.pop(context);
                                },
                              ),
                            ]);
                      },
                      child: Stack(
                        fit: StackFit.expand,
                        alignment: AlignmentDirectional.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: AssetImage(
                                    products[index].pLocation,
                                  ),
                                  fit: BoxFit.cover,
                                )),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              height: constraints.maxHeight / 3,
                              width: constraints.maxWidth,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                                color: Colors.white.withOpacity(.6),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      products[index].pName,
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                    Text(
                                      "${products[index].pPrice}\$",
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }
}
