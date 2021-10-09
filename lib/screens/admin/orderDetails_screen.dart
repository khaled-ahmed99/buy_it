import 'package:buy_it/constants.dart';
import 'package:buy_it/models/product.dart';
import 'package:buy_it/services/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  static const String id = 'OrderDetailsScreen';

  @override
  Widget build(BuildContext context) {
    String docId = ModalRoute.of(context).settings.arguments;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: StreamBuilder(
          stream: Store.loadOrderDetails(docId),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black,
                ),
              );
            List<Product> products = [];
            for (DocumentSnapshot doc in snapshot.data.docs) {
              var product = doc.data();
              products.add(Product(
                pName: product[kProductName],
                pPrice: product[kProductPrice],
                pLocation: product[kProductLocation],
                pCategory: product[kProductCategory],
                pQuantity: product[kProductQuantity],
              ));
            }
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Container(
                    color: kSecondaryColor,
                    height: size.height * .15,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              AssetImage(products[index].pLocation),
                          radius: (size.height * .15) / 2,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    products[index].pName,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${products[index].pPrice}\$',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Text(
                                  (products[index].pQuantity).toString(),
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
                );
              },
            );
          }),
    );
  }
}
