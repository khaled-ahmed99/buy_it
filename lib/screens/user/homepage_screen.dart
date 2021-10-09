import 'package:buy_it/constants.dart';
import 'package:buy_it/models/product.dart';
import 'package:buy_it/screens/user/login_screen.dart';
import 'package:buy_it/screens/user/productInfo_screen.dart';
import 'package:buy_it/services/auth.dart';
import 'package:buy_it/services/store.dart';
import 'package:buy_it/widgets/order_list.dart';
import 'package:circle_bottom_navigation_bar/widgets/tab_data.dart';
import 'package:buy_it/widgets/myNavBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:buy_it/extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cart_screen.dart';

class HomePageScreen extends StatefulWidget {
  static const String id = 'HomePage';
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  User loggedUser;
  @override
  void initState() {
    super.initState();
    loggedUser = Auth.getUser();
  }

  Widget productView(String category) {
    return StreamBuilder<QuerySnapshot>(
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
          if (product[kProductCategory] == category)
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
        products.sort((a, b) => a.pName.numPart().compareTo(b.pName.numPart()));
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: .8,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              child: LayoutBuilder(
                builder: (context, constraints) => GestureDetector(
                  onTap: () => Navigator.pushNamed(
                      context, ProductInfoScreen.id,
                      arguments: products[index]),
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: AssetImage(
                                products[index].pLocation,
                              ),
                              fit: BoxFit.fill,
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  products[index].pName,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                Text(
                                  "${products[index].pPrice}\$",
                                  style: Theme.of(context).textTheme.bodyText1,
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
    );
  }

  int _navBarIndex = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
          backgroundColor: kSecondaryColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              _navBarIndex == 0 ? 'Discover' : 'Orders',
              style: TextStyle(color: Colors.black),
            ),
            actions: _navBarIndex == 0
                ? [
                    Padding(
                      padding: EdgeInsets.only(right: size.width * .03),
                      child: IconButton(
                        icon: Icon(
                          Icons.shopping_cart,
                          color: Colors.black,
                          size: 25,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, CartScreen.id);
                        },
                      ),
                    )
                  ]
                : null,
            backgroundColor: kMainColor,
            bottom: _navBarIndex == 0
                ? TabBar(
                    indicatorColor: kSecondaryColor,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.black45,
                    labelStyle: TextStyle(fontSize: 16),
                    unselectedLabelStyle: TextStyle(fontSize: 14),
                    labelPadding: EdgeInsets.all(4),
                    tabs: [
                      Text('Jackets'),
                      Text('Trousers'),
                      Text('T-Shirts'),
                      Text('Shoes'),
                    ],
                  )
                : null,
          ),
          body: _navBarIndex == 0
              ? TabBarView(
                  children: [
                    productView(kJackets),
                    productView(kTrousers),
                    productView(kTshirts),
                    productView(kShoes),
                  ],
                )
              : OrderList(
                  size: size,
                  isAdmin: false,
                ),
          bottomNavigationBar: CircleBottomNavigationBar(
            initialSelection: _navBarIndex,
            barBackgroundColor: kMainColor,
            activeIconColor: Colors.black,
            inactiveIconColor: Colors.black45,
            circleColor: kSecondaryColor,
            circleSize: 45,
            arcWidth: 76,
            itemTextOff: 1,
            shadowAllowance: 15,
            tabs: [
              TabData(icon: Icons.home_outlined, title: 'home'),
              TabData(icon: Icons.shopping_bag_outlined, title: 'orders'),
              TabData(icon: Icons.close, title: 'sign out'),
            ],
            onTabChangedListener: (value) async {
              if (value == 2) {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                preferences.clear();
                await Auth.signOut();
                Navigator.popAndPushNamed(context, LogInScreen.id);
              } else {
                setState(() {
                  _navBarIndex = value;
                });
              }
            },
          )),
    );
  }
}
